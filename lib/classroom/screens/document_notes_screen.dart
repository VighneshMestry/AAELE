import 'dart:developer';

import 'package:aaele/Insights/controller/home_controller.dart';
import 'package:aaele/models/meeting_model.dart';
import 'package:aaele/widgets/document_card.dart';
import 'package:aaele/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class DocumentNotesScreen extends ConsumerStatefulWidget {
  final MeetingModel meetingModel;
  final String notes;
  const DocumentNotesScreen(
      {super.key, required this.meetingModel, required this.notes});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DocumentNotesScreenState();
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
    final notes = ref.watch(getNotesForMeeting(widget.meetingModel.meetId));
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              NotesBy(),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ));
  }

  Widget NotesBy() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: 20),
                  const Text("Notes By: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Text(widget.meetingModel.hostName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                ],
              ),
              ElevatedButton(onPressed: (){
                

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar('On Snap!', 'Feature Coming soon! :)', ContentType.help));
              }, child: const Text("Message"))
            ],
          ),
        ),
      ],
    );
  }
}

// notes.when(
//   data: (notes) => Center(
//     child: Text(notes), // Display the notes if data is available
//   ),
//   loading: () => const Center(
//     child: CircularProgressIndicator(), // Show loading spinner
//   ),
//   error: (error, stackTrace) => Center(
//     child: Text('Error: $error'), // Display error message if something goes wrong
//   ),
// ),`
