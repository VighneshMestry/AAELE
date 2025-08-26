const fs = require('fs');
const https = require('https');
const { GoogleAIFileManager } = require('@google/generative-ai/server');
const { GoogleGenerativeAI } = require("@google/generative-ai");

const fileManager = new GoogleAIFileManager(process.env.GEMINI_API_KEY);

const downloadVideo = (url, path) => {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(path);
        https.get(url, (response) => {
            response.pipe(file);
            file.on('finish', () => {
                file.close(resolve); // close() is async, call resolve after close completes.
            });
        }).on('error', (err) => {
            fs.unlink(path); // Delete the file async if there's an error
            reject(err.message);
        });
    });
};


const deleteVideoFile = (path) => {
    return new Promise((resolve, reject) => {
        fs.unlink(path, (err) => {
            if (err) {
                console.error('Failed to delete the local video file:', err.message);
                reject(err);
            } else {
                console.log(`Deleted local video file: ${path}`);
                resolve();
            }
        });
    });
};

const processVideo = async (videoUrl, prompt) => {
    const localVideoFile = "video_480.webm"; // Path to save the downloaded video

    try {
        // Download the video
        console.log("Downloading video from URL...");
        await downloadVideo(videoUrl, localVideoFile);
        console.log(`Video downloaded and saved as ${localVideoFile}`);


        // Upload the video to the model
        console.log("Uploading video...");
        const uploadResponse = await fileManager.uploadFile(localVideoFile, {
            mimeType: "video/webm",
            displayName: "Lecture Video",
        });
        console.log(`Uploaded file ${uploadResponse.file.displayName} as: ${uploadResponse.file.uri}`);


        // Verify the file upload state
        let file = await fileManager.getFile(uploadResponse.file.name);
        while (file.state === "PROCESSING") {
            process.stdout.write(".");
            await new Promise((resolve) => setTimeout(resolve, 10000)); // Wait for 10 seconds
            file = await fileManager.getFile(uploadResponse.file.name);
        }

        if (file.state === "FAILED") {
            throw new Error("Video processing failed.");
        }

        console.log(`File ${file.displayName} is ready for inference as ${file.uri}`);

        // let prompt = "This is a video of a live lecture. Please create detailed notes for the students to study this lecture. Make sure to include all the formulas and everything.";
        // if (notes && notes.trim() !== "") {
        //     prompt = `This is a video of a live lecture. These are the existing notes: ${notes}. Please create new notes which will include the existing notes as well as the new notes.`;
        // } else {
        //     console.log("Notes string is empty.");

        // }

        // Initialize GoogleGenerativeAI with your API_KEY
        const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
        const model = genAI.getGenerativeModel({
            model: "gemini-1.5-pro",
        });

        // Make the LLM request
        console.log("Making LLM inference request...");
        const result = await model.generateContent([
            {
                fileData: {
                    mimeType: uploadResponse.file.mimeType,
                    fileUri: uploadResponse.file.uri,
                },
            },
            { text: prompt },
        ]);

        // Print the response
        console.log("Video model says: ", result.response.text());

        //Return the response
        return result.response.text();
    } catch (error) {
        console.error("Error:", error);
    } finally {
        // Delete the local video file
        await deleteVideoFile(localVideoFile);
    }
};

module.exports = { processVideo };