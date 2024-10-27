import 'package:aaele/widgets/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentNotesScreen extends ConsumerStatefulWidget {
  const DocumentNotesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentNotesScreenState();
}

class _DocumentNotesScreenState extends ConsumerState<DocumentNotesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) => DocumentCard(),
          )
        ],
      ),
    );
  }
}