import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app_firebase/components/notetile.dart';
import 'package:notes_app_firebase/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Write your Notes',
          style: GoogleFonts.notoSans()
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Type here....")
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              else {
                firestoreService.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
              },
              child: Text(
                "Add",
                style: GoogleFonts.rubik()
            )
          ),
          const SizedBox(width: 45),
          ElevatedButton(
              onPressed: () {
                textController.clear();
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.rubik()
              )
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Center(
          child: Text(
          "Notes",
          style: GoogleFonts.notoSans(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.grey[200]
          )
        )),
      ),
      floatingActionButton: FloatingActionButton(
         backgroundColor: const Color(0xFFCA7B80),
            shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)
            ),
        onPressed: openNoteBox,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
          weight: 40,
        ),
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
                  String noteText = data['note']; //noteText
                  return NoteTile(
                    text: noteText,
                    onEditPressed: () => openNoteBox(docID: docID),
                    onDeletePressed: () => firestoreService.deleteNote(docID),
                  );
                },
              );
            } 
            else {
              return Center(
                child: Text(
                  "No Notes As Yet....",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              );
            }
          }),
    );
  }
}
