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

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizControllerProvider = StateNotifierProvider<QuizController, List<ChatMessage>>((ref) {
  return QuizController();
});

class QuizController extends StateNotifier<List<ChatMessage>> {
  QuizController() : super([]);

  void updateMessageList(List<ChatMessage> list) {
    state = list;
  }

  void addMessage(ChatMessage chatMessage) {
    state = [chatMessage, ...state];
  }

  void removeItem(ChatMessage item) {
    state = state.where((i) => i != item).toList();
  }
}