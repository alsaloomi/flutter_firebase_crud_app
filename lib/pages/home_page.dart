import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // استدعاء ملف الخدمات
  final FirestoreService firestoreService = FirestoreService();
  
  // متحكم النص للـ TextField
  final TextEditingController textController = TextEditingController();

  // دالة لفتح نافذة الإضافة/التعديل
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'اكتب ملاحظتك هنا...'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                // إضافة ملاحظة جديدة
                firestoreService.addNote(textController.text);
              } else {
                // تحديث ملاحظة موجودة
                firestoreService.updateNote(docID, textController.text);
              }
              // تنظيف الحقل وإغلاق النافذة
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes App")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر التعديل
                      IconButton(
                        onPressed: () {
                          textController.text = noteText;
                          openNoteBox(docID: docID);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      // زر الحذف
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(docID),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("لا توجد ملاحظات..."));
          }
        },
      ),
    );
  }
}