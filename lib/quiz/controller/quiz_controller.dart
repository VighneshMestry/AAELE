// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';

// // Define a StateNotifier to manage the list of messages
// class QuizController extends StateNotifier<List<ChatMessage>> {
//   QuizController() : super([]);

//   // Add a new message to the list
//   void addMessage(ChatMessage message) {
//     state = [message, ...state];
//   }

//   // Replace the entire message list (if needed for updates)
//   void updateMessages(List<ChatMessage> messages) {
//     state = messages;
//   }
// }

// // Provider for ChatController
// final quizControllerProvider = StateNotifierProvider<QuizController, List<ChatMessage>>((ref) {
//   return QuizController();
// });

import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final quizControllerProvider = StateNotifierProvider.autoDispose<QuizController, List<ChatMessage>>((ref) {
  return QuizController();
});

class QuizController extends StateNotifier<List<ChatMessage>> {
  QuizController() : super([]) {
    _initSocket();
  }

  final String serverUrl = 'ws://192.168.0.105:5000';
  final String testId = "6719fb40f1230bb78e7c4740";
  late io.Socket socket;

  final ChatUser geminiUser = ChatUser(
    id: "2",
    firstName: "Gemini",
    profileImage: "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw",
  );

  void _initSocket() {
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      log('Connected to the socket server');
      socket.emit("start_test", {"test_id": testId});
    });

    socket.onDisconnect((_) => log('Disconnected from the socket server'));

    socket.on("response", (response) {
      _addMessage(response.toString());
    });

    socket.on("questions", (data) {
      _addMessage(data.toString());
    });
  }

  void _addMessage(String text) {
    final message = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text: text,
    );
    state = [message, ...state];
  }

  void sendMessage(ChatMessage message) {
    socket.emit('message', message.text);
    state = [message, ...state];
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

}