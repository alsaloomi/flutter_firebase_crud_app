import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // جلب مسار مجموعة الملاحظات من قاعدة البيانات
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // 1. إضافة ملاحظة (Create)
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // 2. قراءة الملاحظات (Read)
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  // 3. تحديث ملاحظة (Update)
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // 4. حذف ملاحظة (Delete)
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}