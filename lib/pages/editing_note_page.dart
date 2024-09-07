import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:prosen_final/services/firestore.dart';

// ignore: must_be_immutable
class EditingNotePage extends StatefulWidget {
  String note;
  bool isNewNote;
  String noteID;

  EditingNotePage(
      {super.key,
      required this.note,
      required this.isNewNote,
      required this.noteID});

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  //firestore
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note);
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  //add a new note
  void addNewNote() {
    String text = _controller.document.toPlainText();
    firestoreService.addNote(text);
  }

  //Update existing note
  void updateNote() {
    String text = _controller.document.toPlainText();
    // print(text);

    firestoreService.updateNote(text, widget.noteID);
  }

  void deleteNote() {
    // print("Delete");
    firestoreService.deleteNote(widget.noteID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  _focusNode.unfocus();
                  //it's a new note
                  if (widget.isNewNote && !_controller.document.isEmpty()) {
                    addNewNote();
                  }

                  //existing note
                  else {
                    if (_controller.document.isEmpty()) {
                      deleteNote();
                    }
                    updateNote();
                  }
                  //popa window
                  Navigator.pop(context);
                },
                color: Colors.black),
          ),
          body: Column(
            children: [
              //toolbar
              Container(
                color: Colors.white,
                child: FlutterQuillLocalizationsWidget(
                  child: QuillToolbar.simple(
                    controller: _controller,
                    configurations: const QuillSimpleToolbarConfigurations(
                      showAlignmentButtons: false,
                      showBoldButton: false,
                      showCodeBlock: false,
                      showBackgroundColorButton: false,
                      showCenterAlignment: false,
                      showClearFormat: false,
                      showDirection: false,
                      showFontFamily: false,
                      showItalicButton: false,
                      showFontSize: false,
                      showDividers: false,
                      showHeaderStyle: false,
                      showIndent: false,
                      showInlineCode: false,
                      showJustifyAlignment: false,
                      showStrikeThrough: false,
                      showListCheck: false,
                      showUnderLineButton: false,
                      showSearchButton: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showListBullets: false,
                      showListNumbers: false,
                      //Te so dobre
                      showColorButton: false,
                      showLink: false,
                      showQuote: false,
                      showUndo: false,
                      showRedo: false,
                      showClipboardCopy: false,
                      showClipboardPaste: false,
                      showClipboardCut: false,
                      sharedConfigurations: QuillSharedConfigurations(
                        locale: Locale('sl'),
                      ),
                    ),
                  ),
                ),
              ),

              //editor
              Expanded(
                child: Container(
                  // color: Capurtino,
                  padding: const EdgeInsets.all(25),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    child: QuillEditor.basic(
                        controller: _controller,
                        configurations: const QuillEditorConfigurations(
                          sharedConfigurations: QuillSharedConfigurations(
                            locale: Locale('sl'),
                          ),
                          placeholder: "Naslov",
                        )),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
