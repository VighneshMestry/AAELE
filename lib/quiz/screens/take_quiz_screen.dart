import 'dart:developer';

import 'package:aaele/quiz/controller/quiz_controller.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TakeQuizScreen extends ConsumerStatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
  List<ChatMessage> messages = [];
  final test_id = "6719fb40f1230bb78e7c4740";
  ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
  ChatUser geminiUser = ChatUser(
      id: "2",
      firstName: "Gemini",
      profileImage:
          "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw");

  late final IO.Socket socket;

  void initializeSocketConnection() {
    try {
      socket = IO.io('wss://mood-lens-server.onrender.com', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
    } catch (e) {
      log('Error connecting to server: $e');
    }
  }

  void setUpSocketListeners() {
    socket.onConnect((_) {
      log('Connected to the WebSocket server');
      log("emitting start_test");
      socket.emit("start_test", {"test_id": test_id});
    });

    socket.onDisconnect((_) {
      log('Disconnected from the WebSocket server');
    });

    socket.on("response", (response) {
      ChatMessage responseMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response.toString());
      messages = [responseMessage, ...messages];
    });

    socket.on("questions", (question) {
      ChatMessage responseMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: question.toString());
      messages = [responseMessage, ...messages];
    });

    socket.on('message', (data) {
      log('Received message: $data');
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.close();
    super.dispose();
  }

  void sendMessage(ChatMessage message) {
    messages.add(ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: message.toString()));
    socket.emit('message', message.text);
  }

  @override
  void initState() {
    super.initState();
    initializeSocketConnection();
    setUpSocketListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: messages,
      // typingUsers: [currentUser, geminiUser],
      inputOptions: const InputOptions(
          inputDecoration: InputDecoration(fillColor: Colors.yellow),
          textCapitalization: TextCapitalization.sentences),
    ));
  }
}
