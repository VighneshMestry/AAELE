import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentCard extends ConsumerStatefulWidget {
  const DocumentCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentCardState();
}

class _DocumentCardState extends ConsumerState<DocumentCard> {

  @override
  Widget build(BuildContext context) {
    TextEditingController assignmentTitle = TextEditingController();
    TextEditingController assignmentDescription = TextEditingController();
    TextEditingController tags = TextEditingController();
    return Container(
      height: 290,
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
      // height: 150,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
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
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Enter Details'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: assignmentTitle,
                                        decoration: const InputDecoration(
                                            labelText: 'Assignment Name'),
                                      ),
                                      TextField(
                                        controller: assignmentDescription,
                                        decoration: const InputDecoration(
                                            labelText: 'Assignent Description'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Perform submission actions here
                                        String assignmentTitleText = "Title";
                                            // (assignmentTitle.text.length == 0)
                                            //     ? widget
                                            //         .document.assignmentTitle
                                            //     : assignmentTitle.text.trim();
                                        String assignmentDescriptionText = "Description";
                                            // (assignmentDescription
                                            //             .text.length ==
                                            //         0)
                                            //     ? widget.document
                                            //         .assigmentDescription
                                            //     : assignmentDescription.text
                                            //         .trim();
                                        // Doc newDoc = widget.document.copyWith(
                                        //     assignmentTitle:
                                        //         assignmentTitleText,
                                        //     assigmentDescription:
                                        //         assignmentDescriptionText);
                                        // updateNameDescriptionTags(ref, newDoc);

                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Submit'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Title",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      Offset offset = details.globalPosition;
                      showMenu(
                          context: context,
                          color: Colors.white,
                          position: RelativeRect.fromLTRB(
                              offset.dx, offset.dy + 20, 10, 0),
                          items: [
                            PopupMenuItem(
                              onTap: () {
                                // uploadToMySpace();
                              },
                              value: 1,
                              child: const Row(
                                children: [
                                  Icon(Icons.upload),
                                  SizedBox(width: 5),
                                  Text("Upload to My Space"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                // share();
                              },
                              value: 2,
                              child: const Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(width: 5),
                                  Text("Share"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                // (ref.read(userProvider)!.uid !=
                                //         widget.document.userId)
                                //     ? const SizedBox()
                                //     : showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return AlertDialog(
                                //             title: const Text(
                                //                 'Delete Confirmation'),
                                //             content: const Text(
                                //                 'Are you sure you want to delete this item?'),
                                //             actions: <Widget>[
                                //               TextButton(
                                //                 onPressed: () {
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 child: const Text('Cancel'),
                                //               ),
                                //               TextButton(
                                //                 onPressed: () {
                                //                   deleteDocument();
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 child: const Text('Delete'),
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       );
                              },
                              value: 3,
                              // child: (ref.read(userProvider)!.uid !=
                              //         widget.document.userId)
                              //     ? const Row(
                              //         children: [
                              //           Icon(Icons.delete, color: Colors.grey),
                              //           SizedBox(width: 5),
                              //           Text("Delete",
                              //               style:
                              //                   TextStyle(color: Colors.grey)),
                              //         ],
                              //       )
                                  child: const Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 5),
                                        Text("Delete"),
                                      ],
                                    ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              value: 4,
                              child: const Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 5),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                          ]);
                    },
                    child: const Icon(Icons.more_vert_outlined),
                  ),
                ),
                // Text("Hello"),
              ],
            ),
            const SizedBox(height: 15),
            // widget.document.assigmentDescription.isEmpty
            //     ? Column(
            //         children: [
            //           Row(
            //             children: [
            //               GestureDetector(
            //                 onTap: () async {
            //                   await checkFileExist();
            //                   fileExists ? openfile() : startDownload();
            //                   if (downloading) {
            //                     // ignore: use_build_context_synchronously
            //                     showDialog(
            //                         barrierDismissible: true,
            //                         context: context,
            //                         builder: (context) {
            //                           print(
            //                               "Downloading dialog______________________________________________________");
            //                           return AlertDialog(
            //                             content: Stack(
            //                               alignment: Alignment.center,
            //                               children: [
            //                                 CircularProgressIndicator(
            //                                   value: progress,
            //                                   strokeWidth: 3,
            //                                   backgroundColor: Colors.grey,
            //                                   valueColor:
            //                                       const AlwaysStoppedAnimation<
            //                                           Color>(Colors.blue),
            //                                 ),
            //                                 Text(
            //                                   (progress * 100)
            //                                       .toStringAsFixed(2),
            //                                   style:
            //                                       const TextStyle(fontSize: 12),
            //                                 )
            //                               ],
            //                             ),
            //                           );
            //                         });
            //                   }
            //                 },
            //                 child: Container(
            //                   padding: const EdgeInsets.only(
            //                       left: 15, right: 8, top: 8, bottom: 8),
            //                   height: 40,
            //                   width: 250,
            //                   decoration: BoxDecoration(
            //                       border:
            //                           Border.all(color: Colors.grey.shade400),
            //                       borderRadius: BorderRadius.circular(30)),
            //                   child: Row(
            //                     children: [
            //                       // (widget.document.type == "pdf")
            //                       //     ? Icon(Icons.note,
            //                       //         color: Colors.red.shade700)
            //                       //     : ((widget.document.type == "docx")
            //                       //         ? Icon(Icons.note,
            //                       //             color: Colors.blue.shade700)
            //                       //         : Icon(Icons.note,
            //                       //             color: Colors.orange.shade700)),
            //                       if (widget.document.type == "pdf?")
            //                         Icon(Icons.note,
            //                             color: Colors.red.shade700),
            //                       if (widget.document.type == "docx")
            //                         Icon(Icons.note,
            //                             color: Colors.blue.shade700),
            //                       if (widget.document.type == "xlsx")
            //                         Icon(Icons.note,
            //                             color: Colors.green.shade700),
            //                       if (widget.document.type == "pptx")
            //                         Icon(Icons.note,
            //                             color: Colors.orange.shade700),
            //                       if (widget.document.type == "img")
            //                         Icon(Icons.image),
            //                       const SizedBox(width: 10),
            //                       Text((widget.document.fileName.length > 23)
            //                           ? widget.document.fileName
            //                               .substring(0, 23)
            //                           : widget.document.fileName),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(width: 5),
            //               Container(
            //                 padding: const EdgeInsets.all(4.0),
            //                 height: 40,
            //                 width: 99,
            //                 child: ElevatedButton(
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: Colors.white,
            //                     elevation: 3,
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(30)),
            //                   ),
            //                   onPressed: () {
            //                     askAI();
            //                   },
            //                   child: ClipRRect(
            //                     borderRadius: BorderRadius.circular(30),
            //                     child: const Text(
            //                       "Ask AI",
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.black),
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //           const SizedBox(height: 10),
            //           widget.document.aiFileExists
            //               ? Row(
            //                   children: [
            //                     GestureDetector(
            //                       onTap: () async {
            //                         await aiCheckFileExist();
            //                         aiFileExists
            //                             ? aiOpenfile()
            //                             : aiStartDownload();
            //                       },
            //                       child: Container(
            //                         padding: const EdgeInsets.only(
            //                             left: 15, right: 8, top: 8, bottom: 8),
            //                         height: 40,
            //                         width: 250,
            //                         decoration: BoxDecoration(
            //                             border: Border.all(
            //                                 color: Colors.grey.shade400),
            //                             borderRadius:
            //                                 BorderRadius.circular(30)),
            //                         child: Row(
            //                           children: [
            //                             Icon(Icons.note,
            //                                 color: Colors.red.shade700),
            //                             const SizedBox(width: 10),
            //                             Text(
            //                                 (aiDocument.fileName.length == 0)
            //                                     ? ""
            //                                     : (aiDocument.fileName.length > 23) ? aiDocument.fileName.substring(0,23) : aiDocument.fileName,
            //                                 overflow: TextOverflow.ellipsis),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                     const SizedBox(width: 5),
            //                     Container(
            //                       padding: const EdgeInsets.all(4.0),
            //                       height: 40,
            //                       width: 99,
            //                       child: ElevatedButton(
            //                         autofocus: true,
            //                         style: ElevatedButton.styleFrom(
            //                           backgroundColor: Colors.white,
            //                           shape: RoundedRectangleBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(30)),
            //                           elevation: 3,
            //                         ),
            //                         onPressed: () {},
            //                         child: ClipRRect(
            //                           borderRadius: BorderRadius.circular(30),
            //                           child: Icon(Icons.mic_none_rounded),
            //                         ),
            //                       ),
            //                     )
            //                   ],
            //                 )
            //               : const SizedBox(height: 40),
            //         ],
            //       )
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        child: Text(
                          "Description",
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // await checkFileExist();
                              // fileExists ? openfile() : startDownload();
                              // if (downloading) {
                              //   // ignore: use_build_context_synchronously
                              //   showDialog(
                              //       barrierDismissible: true,
                              //       context: context,
                              //       builder: (context) {
                              //         print(
                              //             "Downloading dialog______________________________________________________");
                              //         return AlertDialog(
                              //           content: Stack(
                              //             alignment: Alignment.center,
                              //             children: [
                              //               CircularProgressIndicator(
                              //                 value: progress,
                              //                 strokeWidth: 3,
                              //                 backgroundColor: Colors.grey,
                              //                 valueColor:
                              //                     const AlwaysStoppedAnimation<
                              //                         Color>(Colors.blue),
                              //               ),
                              //               Text(
                              //                 (progress * 100)
                              //                     .toStringAsFixed(2),
                              //                 style:
                              //                     const TextStyle(fontSize: 12),
                              //               )
                              //             ],
                              //           ),
                              //         );
                              //       });
                              // }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 8, top: 8, bottom: 8),
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                    Icon(Icons.note,
                                        color: Colors.red.shade700),
                                  // if (widget.document.type == "pdf?")
                                  // if (widget.document.type == "docx")
                                  //   Icon(Icons.note,
                                  //       color: Colors.blue.shade700),
                                  // if (widget.document.type == "xlsx")
                                  //   Icon(Icons.note,
                                  //       color: Colors.green.shade700),
                                  // if (widget.document.type == "pptx")
                                  //   Icon(Icons.note,
                                  //       color: Colors.orange.shade700),
                                  // if (widget.document.type == "img")
                                  //   const Icon(Icons.image),
                                  // const SizedBox(width: 10),
                                  // Text((widget.document.fileName.length > 23)
                                  //     ? widget.document.fileName
                                  //         .substring(0, 23)
                                  //     : widget.document.fileName),
                                  Text("Filename")
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            height: 40,
                            width: 99,
                            child: ElevatedButton(
                              autofocus: true,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 3,
                              ),
                              onPressed: () {
                                // askAI();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: const Text(
                                  "Ask AI",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // widget.document.aiFileExists //Ternary
                          Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // await aiCheckFileExist();
                                    // aiFileExists
                                    //     ? aiOpenfile()
                                    //     : aiStartDownload();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 8, bottom: 8),
                                    height: 40,
                                    width: 250,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.note,
                                            color: Colors.red.shade700),
                                        const SizedBox(width: 10),
                                        Text( "Ai Document",
                                            // (aiDocument.fileName.length == 0)
                                            //     ? ""
                                            //     : (aiDocument.fileName.length > 23) ? aiDocument.fileName.substring(0,23) : aiDocument.fileName,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  height: 40,
                                  width: 99,
                                  child: ElevatedButton(
                                    autofocus: true,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 3,
                                    ),
                                    onPressed: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Icon(Icons.mic_none_rounded),
                                    ),
                                  ),
                                )
                              ],
                            )
                          // : const SizedBox(height: 40),
                    ],
                  ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
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
                  IconButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Enter Tags'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: tags,
                                  decoration: const InputDecoration(
                                      labelText: 'Enter new tag'),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  // String tagsText = tags.text;
                                  // widget.document.tags.add(tagsText);
                                  // List<String> newDocTags =
                                  //     widget.document.tags;
                                  // Doc newDoc = widget.document
                                  //     .copyWith(tags: newDocTags);
                                  // updateNameDescriptionTags(ref, newDoc);

                                  // Navigator.of(context)
                                  //     .pop(); // Close the dialog
                                },
                                child: const Text('Submit'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}