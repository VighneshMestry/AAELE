import 'dart:developer';

import 'package:aaele/Insights/controller/home_controller.dart';
import 'package:aaele/models/meeting_model.dart';
import 'package:aaele/widgets/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentNotesScreen extends ConsumerStatefulWidget {
  final MeetingModel meetingModel;
  final String notes;
  const DocumentNotesScreen({super.key, required this.meetingModel, required this.notes});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentNotesScreenState();
}

class _DocumentNotesScreenState extends ConsumerState<DocumentNotesScreen> {

  String notes = "";

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getNotesForMeeting(widget.meetingModel.meetId);
  }
  
  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(homeControllerProvider);
    return Scaffold(
      body: loading ? CircularProgressIndicator() : Column(
        children: [
          Text(widget.notes)
        ],
      ),
    );
  }
}