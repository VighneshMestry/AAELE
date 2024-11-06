// import 'dart:developer';

// import 'package:aaele/quiz/controller/quiz_controller.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class TakeQuizScreen extends ConsumerStatefulWidget {
//   const TakeQuizScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _TakeQuizScreenState();
// }

// class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
//   final test_id = "6719fb40f1230bb78e7c4740";
// ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
// ChatUser geminiUser = ChatUser(
//     id: "2",
//     firstName: "Gemini",
//     profileImage:
//         "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw");

//   late final IO.Socket socket;
//   final url = "ws://192.168.0.105:5000";
//   // final wsUrl = 'wss://mood-lens-server.onrender.com';
//   void initializeSocketConnection() {
//     try {
//       socket = IO.io(url, <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': false,
//       });
//       socket.connect();
//     } catch (e) {
//       log('Error connecting to server: $e');
//     }
//   }

//   void setUpSocketListeners() {
//     socket.onConnect((_) {
//       log('Connected to the WebSocket server');
//       log("emitting start_test");
//       socket.emit("start_test", {"test_id": test_id});
//     });

//     socket.onDisconnect((_) {
//       log('Disconnected from the WebSocket server');
//     });

//     socket.on("response", (response) {
//       log("Response ${response.toString()}");
//       ChatMessage responseMessage = ChatMessage(
//           user: geminiUser,
//           createdAt: DateTime.now(),
//           text: response.toString());
//       _addMessage(responseMessage);
//     });

//     socket.on("questions", (question) {
//       log("Question: ${question.toString()}");
//       ChatMessage responseMessage = ChatMessage(
//           user: geminiUser,
//           createdAt: DateTime.now(),
//           text: question.toString());
//       _addMessage(responseMessage);
//     });

//     socket.on('message', (data) {
//       // _loadingState(false);
//       log('Received message: $data');
//     });

//     socket.on("error", (data) {
//       // _loadingState(false);
//       log("Error ${data.toString()}");
//     });
//   }

//   void _addMessage(ChatMessage chatMessage) {
//     ref.read(quizControllerProvider.notifier).addMessage(chatMessage);
//   }

//   @override
//   void dispose() {
//     socket.disconnect();
//     socket.close();
//     super.dispose();
//   }

//   void sendMessage(ChatMessage message) {
//     _addMessage(message);
//     socket.emit('message', message.text);
//   }

//   @override
//   void initState() {
//     super.initState();
//     initializeSocketConnection();
//     setUpSocketListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messages = ref.watch(quizControllerProvider);
//     // final loading = ref.watch(quizControllerProvider).loading;
// return Scaffold(
//     body: DashChat(
//   currentUser: currentUser,
//   onSend: sendMessage,
//   messages: messages,
//   // typingUsers: [currentUser, geminiUser],
//   inputOptions: const InputOptions(
//       inputDecoration: InputDecoration(fillColor: Colors.yellow),
//       textCapitalization: TextCapitalization.sentences),
// ));
//     // return Scaffold(
//     //   body: Column(
//     //     children: [
//     //       ListView.builder(
//     //         itemCount: messages.length,
//     //         itemBuilder: (context, index) {
//     //           return Column(
//     //             children: [
//     //               Text("Message $index"),
//     //               Text("User ${messages[index].user.firstName}"),
//     //               Text("Message ${messages[index].text}")
//     //             ],
//     //           );
//     //         },
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }

import 'package:aaele/quiz/controller/quiz_controller.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TakeQuizScreen extends ConsumerStatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
  // final String serverUrl = 'ws://192.168.0.105:5000';
  // final test_id = "6719fb40f1230bb78e7c4740";
  // late io.Socket socket;
  // TextEditingController messageController = TextEditingController();
  // List<ChatMessage> messages = [];
  // ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
  // ChatUser geminiUser = ChatUser(
  //     id: "2",
  //     firstName: "Gemini",
  //     profileImage:
  //         "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw");

  // @override
  // void initState() {
  //   super.initState();

  //   // Initialize and connect to the socket server.
  //   socket = io.io(serverUrl, <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });

  //   socket.connect();

  //   // Event listeners.
  //   socket.onConnect((_) {
  //     log('Connected to the socket server');
  //     log("start_test emitting");
  //     socket.emit("start_test", {"test_id" : test_id});
  //   });

  //   socket.onDisconnect((_) {
  //     log('Disconnected from the socket server');
  //   });

  //   socket.on("response", (response) {
  //     log("Response ${response.toString()}");
  //     ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: response.toString());
  //     setState(() {
  //       messages = [message, ...messages];
  //     });
  //   });

  //   socket.on("questions", (data) {
  //     log("Questions: ${data.toString()}");
  //     ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: data.toString());
  //     setState(() {
  //       messages = [message, ...messages];
  //     });
  //   });
  // }

  // // Function to send a message to the server.
  // void sendMessage(ChatMessage message) {
  //   socket.emit('message', message.text);
  //   setState(() {
  //     messages = [message, ...messages];
  //   });

  // }

  // @override
  // void dispose() {
  //   socket.disconnect();
  //   socket.dispose();
  //   super.dispose();
  // }

  String text =
      "Computers are electronic devices that process data and execute instructions to perform tasks. They consist of hardware, like the CPU and memory, and software, including operating systems and applications. Computers are used in countless fields, from personal tasks to complex scientific calculations.";

  

  @override
  Widget build(BuildContext context) {
    ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
    final messages = ref.watch(quizControllerProvider);
    final quizController = ref.watch(quizControllerProvider.notifier);
    final currentVoice = quizController.currentVoice;
    final voices = quizController.voices;
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(8.0),
            child: DropdownButton<Map>(
              value: voices.contains(currentVoice)
                  ? currentVoice
                  : null, 
              items: voices.map((voice) {
                return DropdownMenuItem<Map>(
                  value: voice, // Ensure this is a Map
                  child: Text(voice["name"]),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  quizController.setVoice(value);
                }
              },
              hint: Text('Select Voice'), // Optional hint
            ),
          ),
          Expanded(
            child: DashChat(
              currentUser: currentUser,
              onSend: quizController.sendMessage,
              messages: messages,
              // typingUsers: [currentUser, geminiUser],
              inputOptions: const InputOptions(
                inputDecoration: InputDecoration(fillColor: Colors.yellow),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
