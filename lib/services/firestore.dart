import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  //Create note
  Future<void> addNote(String note) async {
    DocumentReference docRef =
        notes.doc(); // Create a reference to a new document
    String id = docRef.id; // Get the auto-generated ID
    await docRef.set({
      "note": note,
      "timestamp": Timestamp.now(),
      "id": id, // Assign the ID to the document
    });
  }

  //READ NOTE
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = //na vrhu so najstarejša
        notes.orderBy("timestamp", descending: true).snapshots();

    return notesStream;
  }

  //update note
  Future<void> updateNote(text, id) {
    return notes.doc(id).update({"note": text});
  }

  //delete note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
