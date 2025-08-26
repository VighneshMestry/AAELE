const { GoogleGenerativeAI } = require('@google/generative-ai');
const mongoose = require('mongoose');
const Test = require('../schemas/TestSchema');
const Notes = require('../schemas/NotesSchema');
const TestScore = require('../schemas/TestScoreSchema');
const pdfParse = require('pdf-parse');
const axios = require('axios');
const { processVideo } = require('../utils/videoModel');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

// Store chat sessions and history for each user
const userChats = new Map();
const userHistory = new Map();

const handleStartTest = (socket) => {
    console.log('a user connected');

    // Handle start_test event
    socket.on('start_test', async (data) => {
        const { test_id } = data;
        console.log('start_test event received:', test_id);
        try {
            // Fetch the test based on its ObjectId
            const test = await Test.findById(test_id).populate('context.lectureNotes');

            if (!test) {
                socket.emit('error', 'Test not found');
                console.log('Test not found');
                return;
            }

            let context = '';

            // Traverse the lectureNotes array and get the aiNotes
            for (const noteId of test.context.lectureNotes) {
                const note = await Notes.findById(noteId);
                if (note && note.aiNotes) {
                    context += note.aiNotes + ' ';
                }
            }

            // Traverse the externalDocuments array and extract text from PDFs
            for (const pdfUrl of test.context.externalDocuments) {
                const pdfBuffer = await fetchPdfFromFirebase(pdfUrl);
                const pdfText = await extractTextFromPdf(pdfBuffer);
                context += pdfText + ' ';
            }

            context += "\n This is the context. Please ask a single question based on this context. Choose the question randomly from anywhere in the notes. Once you receive a satisfactory answer, you can ask another question. Please note that your response should be a single line, for example: 'What is the capital of India?'";

            // Create a new chat session for the user based on the context
            const chat = model.startChat({
                history: [
                    {
                        role: "user",
                        parts: [{ text: "You will be provided with a set of notes on a particular topic. Imagine you are a subject matter expert conducting a viva examination with a student." }],
                    },
                    {
                        role: "model",
                        parts: [{ text: "Got it! Please share the notes or the topic, and I’ll frame viva questions based on them." }],
                    },
                    {
                        role: "model",
                        parts: [{ text: "Hello, lets start with your oral exam. Are you ready ?"}],
                    },
                    {
                        role: "user",
                        parts: [{ text: "Who are you ?"}],
                    },
                    {
                        role: "model",
                        parts: [{ text: "I am evaluator bot"}],
                    },

                    {
                        role: "model",
                        parts: [{ text: "I am evaluator bot"}],
                    },
                    {
                        role: "user",
                        parts: [{ text: "Can I take a break, I will elaborate later"}],
                    },
                    {
                        role: "model",
                        parts: [{ text: "No worries! Take your time."}],
                    },
                    {
                        role: "model",
                        parts: [{ text: "No worries! Take your time."}],
                    },
                    {
                        role: "model",
                        parts: [{ text: "Okay I am ready now."}],
                    },
                    {
                        role: "user",
                        parts: [{ text: "aaabbbccc"}],
                    },
                    {
                        role: "model",
                        parts: [{ text: "Please stay focused on the interview."}],
                    },
                    {
                        role: "user",
                        parts: [{ text: context }],
                    }
                ],
            });

            // Store the chat session and history for the user
            userChats.set(socket.id, chat);
            userHistory.set(socket.id, []);

            // Ask questions based on the context
            const result = await chat.sendMessage(context);
            const response = result.response.text();
            console.log("this is the response", response);

            // Send the response back to the client
            socket.emit('questions', response);

        } catch (error) {
            console.error('Error starting test:', error);
            socket.emit('error', 'Failed to start test');
        }
    });

    // Handle incoming messages from the user for continuous chat
    socket.on('message', async (data) => {
        const { message } = data;

        console.log('message received:', message);

        const prompt = `Conduct the oral exam strictly focused on the subject matter. Use the following guidelines to guide the conversation:

1. Topic Focus
Stay on Topic: Only entertain questions directly related to the exam topic.
Redirect Off-topic Questions: If the student asks unrelated or off-topic questions, gently redirect the discussion back to the subject at hand. For instance:
"Interesting thought, but let's stay focused on [current topic]."
"Let's keep our discussion on [current topic] for now."
2. Handling Incomplete or Vague Responses
Request Clarification: If the student responds with, “I know the answer,” without further detail, prompt them to explain. For example:
"Could you share your understanding of it?"
"Great! Please go ahead and explain your answer."
Guide Struggling Responses: If the student struggles, follow up with a simpler or guiding question to help them progress toward the answer.
3. Exploring Strong Responses
Deepen Understanding: If the student answers well, ask follow-up questions to explore the topic in depth. For example:

"Can you explain why [specific point] is important?"
"Are there exceptions to this rule?"
Introduce Related Aspects: Connect the answer to relevant topics or applications:

"How might this principle apply in a real-world scenario?"
4. Advanced Questioning for Thorough Responses
Challenge Further: For a comprehensive answer, encourage the student to consider alternative viewpoints or complex scenarios:

"What if we consider [alternative scenario]?"
"Can you think of a case where this approach might not work?"
Higher-Order Questioning: Prompt the student to analyze or synthesize by comparing approaches or creating solutions:

"How would you handle this differently if [hypothetical condition]?"
"What are the pros and cons of different approaches?"
5. Natural Conversation Flow
Use Conversational Cues: Add natural filler words like "Hmm," "I see," or "Interesting" to create a conversational flow. Use these to maintain the rhythm of the dialogue, especially during topic shifts or pauses.
Important: Remain strictly within the context of the exam. If the student tries to manipulate the conversation off-topic or avoid answering, kindly bring the discussion back on track. Avoid moving to the next question unless the student has fully addressed the current question or explicitly states they don't know the answer.`

        const newMessage = prompt + "\n" + message + "Please note that your response should be a single line for eg: 'What is the capital of India?'";

        // Retrieve the chat session and history for the user
        const chat = userChats.get(socket.id);
        const history = userHistory.get(socket.id);

        if (!chat) {
            console.error('Chat session not found for socket id:', socket.id);
            socket.emit('error', 'Chat session not found. Please start the test first.');
            return;
        }

        try {
            // Send the message to the chat session and get the response
            const result = await chat.sendMessage(newMessage);
            const response = result.response.text();
            console.log("this is the response", response);

            // Store the question and answer in the history
            history.push({ question: message, answer: response });
            userHistory.set(socket.id, history);

            // Send the response back to the client
            socket.emit('response', response);
        } catch (error) {
            console.error('Error during chat session:', error);
            socket.emit('error', 'Failed to process message');
        }
    });

    // Handle end_test event
    socket.on('end_test', async (data) => {
        const { test_id, student_id, videoUrl } = data;
        console.log('end_test event received');
        const currTest = await Test.findById(test_id);

        if (!currTest) {
            socket.emit('error', 'Test not found');
            console.log('Test not found');
            return;
        }

        console.log('Test found:', currTest);

        try {
            // Retrieve the chat session and history for the user
            const chat = userChats.get(socket.id);
            const history = userHistory.get(socket.id);

            if (!chat || !history) {
                socket.emit('error', 'No active test session found');
                console.log('No active test session found');
                return;
            }

            // Prepare the evaluation prompt with the history
            let evaluationPrompt = `Please evaluate the student's performance and calculate the marks out of ${currTest.maxMarks}, considering both the difficulty of the questions and the quality of the student's answers during the oral exam. Ensure that the student has answered at least 4 questions.

            Your response should include:

            1. **Feedback**: Provide constructive feedback on the student's overall performance. Highlight their strengths, such as their ability to answer complex questions or demonstrate a strong understanding of certain topics. Point out areas where improvement is needed, such as topics they struggled with, missed details, or unclear explanations. Include suggestions for areas they should focus on to improve in future assessments.

            2. **Summary**: Summarize the key points discussed during the oral exam. Mention the specific topics or questions that were asked, how the student responded, and whether they showed depth in their understanding or encountered difficulties. If there were any notable patterns in the student's responses (e.g., strong performance on certain topics but difficulty with others), include those details.

            3. **Marks**: Assign a score based on the number of questions answered. The score should be out of the adjusted marks, calculated based on the number of questions answered (e.g., if 3 questions answered, calculate score out of 3/4 of the total).

            The response must be in JSON format and structured as follows:

            {
                "feedback": "Feedback here",
                "summary": "Summary here",
                "marks": Test score in Number format here
            }

            Please do not include anything else except for the JSON output.`;

            evaluationPrompt += "Questions and Answers:\n";

            history.forEach((item, index) => {
                evaluationPrompt += `Q${index + 1}: ${item.question}\nA${index + 1}: ${item.answer}\n\n`;
            });

            evaluationPrompt += "If the student has answered fewer than 4 questions, the score should be calculated based on the number of questions answered. For example, if the student answers 3 questions, they will be evaluated out of 3/4 of thetotal score. Similarly, if only 2 questions are answered, the score will be out of 2/4 of the total marks."

            const result = await chat.sendMessage(evaluationPrompt);
            let responseText = result.response.text();
            console.log("Evaluation response:", responseText);

            // Clean the response text
            responseText = responseText.replace(/```json/g, '').replace(/```/g, '').trim();

            // Parse the response as JSON
            let evaluationResponse;
            try {
                evaluationResponse = JSON.parse(responseText);
            } catch (error) {
                console.error('Error parsing evaluation response:', error);
                socket.emit('error', 'Failed to parse evaluation response');
                return;
            }

            //Call the processVideo function to process the video
            const proctoringPrompt = `This is a video of a student attempting a test. Please evaluate the student's behavior during the test and check for any signs of cheating, using unfair means, or copying from external sources. 

            Your evaluation should consider the following behaviors:
            - The student looking away from the screen or engaging in suspicious movements, like frequently glancing at a mobile device or another screen.
            - The student using any unauthorized materials or sources (such as notes, books, or online resources).
            - The presence of any external assistance, such as a person helping the student during the test.
            - The student interacting with any external tools, software, or devices that are not permitted during the exam.
            - Any other behavior that could be considered as cheating or attempting to gain an unfair advantage.

            If any of the behaviors listed above are observed, mark the 'copied' field as 'true'. Otherwise, mark it as 'false'.

            Provide a short summary in the 'proctoringSummary' field. The summary should include the reasons for marking the student as 'copied' or 'not copied', citing specific behaviors or actions observed in the video. For example, you can mention any movements, external interactions, or any materials that were used.

            The response must be in JSON format and structured as follows:

            {
                "copied": true/false,
                "proctoringSummary": "Summary of the proctoring activity, detailing the reason for marking as copied or not copied."
            }

            Please be thorough and ensure the evaluation covers all possible signs of cheating or unfair behavior. If no clear indication of cheating is observed, mark the 'copied' field as 'false' and provide a clear summary of why the behavior was deemed acceptable during the test.

            Please do not include anything else except for the JSON output.`;

            let proctoringResponse = await processVideo(videoUrl, proctoringPrompt);

            //clean the protoring response text 
            proctoringResponse = proctoringResponse.replace(/```json/g, '').replace(/```/g, '').trim();

            try {
                proctoringResponse = JSON.parse(proctoringResponse)
            } catch (error) {
                console.error('Error parsing proctoring response:', error);
                socket.emit('error', 'Failed to parse proctoring response');
                return;
            }

            // Save the evaluation result to the database
            const testScore = new TestScore({
                test_id: test_id,
                student_id: student_id,
                score: evaluationResponse.marks,
                summary: evaluationResponse.summary,
                feedback: evaluationResponse.feedback,
                copied: proctoringResponse.copied,
                proctoringSummary: proctoringResponse.proctoringSummary
            });
            await testScore.save();

            // Send the evaluation response back to the client
            socket.emit('evaluation', evaluationResponse);

        } catch (error) {
            console.error('Error ending test:', error);
            socket.emit('error', 'Failed to end test');
        }
    });

    // Handle user disconnect
    socket.on('disconnect', () => {

        console.log('user disconnected');
        userChats.delete(socket.id);
        userHistory.delete(socket.id);
    });
};

const fetchPdfFromFirebase = async (pdfUrl) => {
    const response = await axios.get(pdfUrl, { responseType: 'arraybuffer' });
    return response.data;
};

const extractTextFromPdf = async (pdfBuffer) => {
    const data = await pdfParse(pdfBuffer);
    return data.text;
};

module.exports = { handleStartTest };