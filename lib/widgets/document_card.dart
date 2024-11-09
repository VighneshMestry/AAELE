import 'package:aaele/quiz/screens/take_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentCard extends ConsumerStatefulWidget {
  final String testTitle;
  final String scheduledOn;
  final String endsOn;
  final String totalPoints;
  final bool live;
  const DocumentCard(
      {super.key,
      required this.testTitle,
      required this.scheduledOn,
      required this.endsOn,
      required this.totalPoints,
      required this.live});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentCardState();
}

class _DocumentCardState extends ConsumerState<DocumentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 268,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.testTitle,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Posted on 26 Sep at 08:30pm",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert_outlined),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.hourglass_bottom_outlined),
                Text(
                  widget.live ? "Scheduled on: " : "Test Start: ",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.scheduledOn,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.hourglass_empty_outlined),
                Text(
                  widget.live ? "Ends on: " : "Test End: ",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.endsOn,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(height: widget.live ? 10 : 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("assets/bullseye.png", width: 20, height: 20),
                    const SizedBox(width: 4),
                    const Text(
                      "Points: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.totalPoints,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                widget.live ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TakeQuizScreen()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Take Test",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ) : const SizedBox(height: 36)
              ],
            ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  const Text("Tags: "),
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // itemCount: widget.document.tags.length,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 10,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: Text(
                            // widget.document.tags[index],
                            "Tag$index",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(Icons.add, color: Colors.grey.shade600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
