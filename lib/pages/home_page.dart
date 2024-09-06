// ignore_for_file: prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "package:prosen_final/pages/editing_note_page.dart";
import "package:prosen_final/services/firestore.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  //Text Controller
  final TextEditingController textController = TextEditingController();

  //final == global
  //Ime userja
  // List<String> users = ["Patrik", "Karmen", "Anton", "Zvonka"];
  final String user = "Patrik";

  // Create a new note
  void createNewNote() {
    //blank note

    //go to editing
    goToNotePage(true, "", "noteID");
  }

  void goToNotePage(bool isNewNote, String note, String noteID) {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => EditingNotePage(
            note: note,
            isNewNote: isNewNote,
            noteID: noteID,
          ),
        ));
  }

  void deleteNote(String docID) {
    firestoreService.deleteNote(docID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewNote,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          const Padding(
            padding: EdgeInsets.only(left: 25.0, top: 45, bottom: 10),
            child: Row(
              children: [
                Text(
                  "Zapiski",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //notes

          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getNotesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data!.docs.length > 0) {
                      List notesList = snapshot.data!.docs;

                      return Expanded(
                        child: SingleChildScrollView(
                          child: CupertinoListSection.insetGrouped(
                            children: List.generate(
                              notesList.length,
                              (index) => Dismissible(
                                key: Key(notesList[index]
                                    .id
                                    .toString()), // Ensure unique keys
                                onDismissed: (direction) {
                                  // Remove the note from the list when dismissed
                                  firestoreService
                                      .deleteNote(notesList[index].id);
                                },
                                background: Container(
                                  color: const Color.fromARGB(255, 212, 212,
                                      217), // Background color when swiping
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                ),
                                child: CupertinoListTile(
                                  title: Text(
                                    _getText(notesList[index]),
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  onTap: () => goToNotePage(
                                      false,
                                      _getText(notesList[index]),
                                      notesList[index].id),
                                  padding: const EdgeInsets.only(
                                      top: 17, bottom: 17, left: 15, right: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: Text(
                          "Nothing here..",
                          style: TextStyle(color: Colors.grey),
                        )),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  String _getText(DocumentSnapshot document) {
    // String docID = document.id;

    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    String noteText = data["note"];
    // noteText = _decryptText(noteText);

    return noteText;
  }

  // String _getUser(DocumentSnapshot document) {
  //   // String docID = document.id;

  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //   String user = data["user"];
  //   // noteText = _decryptText(noteText);

  //   return user;
  // }
}
