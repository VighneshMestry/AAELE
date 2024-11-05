import 'package:aaele/classroom/screens/chatbot.dart';
import 'package:aaele/classroom/screens/new_chat_bot.dart';
import 'package:aaele/quiz/screens/take_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LecturesDisplayScreen extends ConsumerStatefulWidget {
  const LecturesDisplayScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LecturesDisplayScreenState();
}

class _LecturesDisplayScreenState extends ConsumerState<LecturesDisplayScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatbotScreen()));
            }, child: Text("Chatbot")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DemoChatbot()));
            }, child: Text("New Chatbot")),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TakeQuizScreen()));
            }, child: Text("Take Quiz")),
          ],
        )
      ),
    );
  }
}