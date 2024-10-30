// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final quizControllerProvider = StateNotifierProvider<QuizController, List<String>>((ref) {
//   return QuizController();
// });

// class QuizController extends StateNotifier<List<String>> {
//   QuizController() : super([]);

//   void updateMessageList(List<String> list) {
//     state = list;
//   }

//   void addItem(String item) {
//     state = [item, ...state];
//   }

//   void removeItem(String item) {
//     state = state.where((i) => i != item).toList();
//   }
// }