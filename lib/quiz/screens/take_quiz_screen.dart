import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TakeQuizScreen extends ConsumerStatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
  late IO.Socket socket;
  List messages = [];

  void connectToServer() {
    socket = IO.io('http://your_server_ip:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      log('Connected to server');
    });

    // socket.on('message', (data) {
    //   log('New message: $data');
    //   // Handle new message (update UI, etc.)
    // });

    socket.on('disconnect', (_) {
      log('Disconnected from server');
    });

    socket.on('message', (data) {
      setState(() {
        log('New message: $data');
        messages.add(data);
      });
    });
  }

  void sendMessage(String message) {
    socket.emit('message', message);
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
