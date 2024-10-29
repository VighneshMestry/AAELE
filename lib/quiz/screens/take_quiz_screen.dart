import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'package:socket_io_client/socket_io_client.dart' as IO;
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class TakeQuizScreen extends ConsumerStatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
  // late IO.Socket socket;
  List<ChatMessage> temp = [];
  List<String> messages = [];
  final test_id = "6719fb40f1230bb78e7c4740";
  ChatUser currentUser = ChatUser(id: "1", firstName: "Vighnesh");
  ChatUser geminiUser = ChatUser(
      id: "2",
      firstName: "Gemini",
      profileImage:
          "https://play-lh.googleusercontent.com/dT-r_1Z9hUcif7CDSD5zOdOt4KodaGdtkbGszT6WPTqKQ-WxWxOepO6VX-B3YL290ydD=w240-h480-rw");

  late final IO.Socket socket;

  void initializeSocketConnection() {
    HttpOverrides.global = MyHttpOverrides();
    socket = IO.io('wss://mood-lens-server.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    try {
      socket.connect();
    } catch (e) {
      log('Error connecting to server: $e');
    }
  }

  void setUpSocketListeners() {
    socket.onConnect((_) {
      print('Connected to the WebSocket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the WebSocket server');
    });

    socket.on('message', (data) {
      print('Received message: $data');
    });

    
  }

  // late final Socket socket;
  // var io = new Server();

  // void connectToServer() {
  //   socket = IO.io('wss://mood-lens-server.onrender.com', <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //     'reconnection': true,
  //     'reconnectionAttempts': 5,
  //     'reconnectionDelay': 2000,
  //   });

  //   socket.on('connect', (_) {
  //     log('Connected to server');
  //     // socket.emit('start_test', {'test_id': test_id}); // Ensure test_id is properly formatted
  //   });

  //   socket.on('questions', (question) {
  //     // setState(() {
  //     //   messages.add(question);
  //     //   temp.add(ChatMessage(
  //     //       user: geminiUser,
  //     //       createdAt: DateTime.now(),
  //     //       text: question.toString()));
  //     // });
  //     log('New Question: $question');

  //     // Emit acknowledgment after receiving the question
  //     // socket.emit('question_ack', {'acknowledgment': 'Question received'});
  //     // socket.emit('ready_for_next', {'ready': 'Ready for next question'});
  //   });

  //   socket.on('disconnect', (_) {
  //     log('Disconnected from server');
  //   });

  //   socket.on('connect_error', (error) {
  //     log('Error connecting to server: $error'); // Log the error for debugging
  //   });

  //   socket.on('response', (response) {
  //     log('New message: $response');
  //     // setState(() {
  //     //   messages.add(response.toString());
  //     //   temp.add(ChatMessage(
  //     //       user: geminiUser,
  //     //       createdAt: DateTime.now(),
  //     //       text: response.toString()));
  //     // });
  //   });

  //   // Manually call connect after setting up the socket
  //   try {
  //     socket.connect();
  //   } catch (e) {
  //     log('Error connecting to server: $e');
  //   }
  //   log(socket.connected ? "True" : "False");
  // }

  void sendMessage(ChatMessage message) {
    setState(() {
      messages.add(message.text);
      temp.add(ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: message.toString()));
    });
    socket.emit('message', message.text);
  }

  @override
  void initState() {
    super.initState();
    // connectToServer();
    initializeSocketConnection();
    setUpSocketListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DashChat(
      currentUser: currentUser,
      onSend: sendMessage,
      messages: temp,
      // typingUsers: [currentUser, geminiUser],
      inputOptions: const InputOptions(
          inputDecoration: InputDecoration(fillColor: Colors.yellow),
          textCapitalization: TextCapitalization.sentences),
    ));
  }
}
