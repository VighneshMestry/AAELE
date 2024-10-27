import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {

  // Gemini gemini = Gemini.instance;
  late final GenerativeModel _model;
  late final ChatSession _chat;
  ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
  ChatUser geminiUser = ChatUser(
      id: "2",
      firstName: "Gemini",
      profileImage:
          "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw");

final List<Map<String, String>> _chatHistory = [];
List<ChatMessage> messages = [];
  final List<({Image? image, String? text, bool fromUser})> _generatedContent = [];


  void sendMessage(ChatMessage chatMessage) async {
    await _sendChatMessage(chatMessage.text);
  }

// Append previous messages and bot responses to the context
  String _createChatContext(String newMessage) {
    StringBuffer context = StringBuffer();
    for (var message in _chatHistory) {
      context.write('${message['role']}: ${message['content']}\n');
    }
    context.write('user: $newMessage\n');
    return context.toString();
  }

  // Update _sendChatMessage to include the full context of previous chats
  Future<void> _sendChatMessage(String message) async {
    try {
      log("Reaches");
      // Add user's message to the chat history
      _chatHistory.add({'role': 'user', 'content': message});

      // Display user's message on the UI
      Markdown markdown = Markdown(data: message!);
      ChatMessage test = ChatMessage(user: currentUser, createdAt: DateTime.now(), text: markdown.data.replaceAll("*", ""));
      setState(() {
        messages = [test, ...messages];
      });
      _generatedContent.add((image: null, text: message, fromUser: true));

      // Generate the full chat context
      String fullContext = _createChatContext(message);

      // Send message with full context
      final response = await _chat.sendMessage(
        Content.text(fullContext), // Send the full conversation as the prompt
      );
      
      final text = response.text;

      // Add bot's response to the chat history
      _chatHistory.add({'role': 'bot', 'content': text ?? ''});

      // Display bot's response
      log(text ?? "");
      log("{{{{{{{{{{{}}}}}}}}}}}");
      Markdown markdown2 = Markdown(data: text!);
      ChatMessage test2 = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: markdown2.data.replaceAll("*", "") ?? '');
      setState(() {
        log(test2.text);
        messages = [test2, ...messages];
      });
      _generatedContent.add((image: null, text: text, fromUser: false));

    } catch (e) {}
  }







  // void sendMessage(ChatMessage chatMessage) {
  //   setState(() {
  //     messages = [chatMessage, ...messages];
  //   });

  //   try {
  //     String question = chatMessage.text;
  //     // gemini.chat([
  //     //   Content(parts: [Parts(text: "Tell me about computers")], role: 'model')
  //     // ]).then((value) { 
  //     //   ChatMessage? lastMessage = messages.firstOrNull;
  //     //   String response = value?.output ?? 'without output';
  //     //   response = response.replaceAll("*", "");

  //     //   if (lastMessage != null && lastMessage.user == geminiUser) {
  //     //     lastMessage = messages.removeAt(0);
  //     //     lastMessage.text += response;
  //     //     setState(() {
  //     //       messages = [lastMessage!, ...messages];
  //     //     });
  //     //   } else {
  //     //     // String response = event.content?.parts?.fold("", (previous, current) => "$previous$current") ?? "";
  //     //     ChatMessage message = ChatMessage(
  //     //         user: geminiUser, createdAt: DateTime.now(), text: response);
  //     //     setState(() {
  //     //       messages = [message, ...messages];
  //     //     });
  //     //   }
  //     // })
  //     //   .catchError((e) => log('chat', error: e));


  //     gemini.streamGenerateContent(question).listen((event) {
  //       ChatMessage? lastMessage = messages.firstOrNull;
  //       String response = event.content?.parts?.fold(
  //               "", (previous, current) => "$previous ${current.text}") ??
  //           "";
  //       response = response.replaceAll("*", "");
  //       if (lastMessage != null && lastMessage.user == geminiUser) {
  //         lastMessage = messages.removeAt(0);
  //         lastMessage.text += response;
  //         setState(() {
  //           messages = [lastMessage!, ...messages];
  //         });
  //       } else {
  //         // String response = event.content?.parts?.fold("", (previous, current) => "$previous$current") ?? "";
  //         ChatMessage message = ChatMessage(
  //             user: geminiUser, createdAt: DateTime.now(), text: response);
  //         setState(() {
  //           messages = [message, ...messages];
  //         });
  //       }
  //     }
  //     );
  //   } catch (e) {}
  // }

    void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "AIzaSyBuZr6PhkGpecYjISGJ3Q-Fce0oj5NppPA",
    );
    _chat = _model.startChat();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: messages,
      // typingUsers: [currentUser, geminiUser],
      inputOptions: const InputOptions(inputDecoration: InputDecoration(
        fillColor: Colors.yellow
      ), textCapitalization: TextCapitalization.sentences),
          )
    );
  }
}