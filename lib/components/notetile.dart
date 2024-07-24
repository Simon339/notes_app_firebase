import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  NoteTile({
    super.key,
    required this.text, 
    this.onEditPressed, 
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Expanded(
        child: ListTile(
            title: Text(text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onEditPressed,
                  icon: const Icon(Icons.edit)),
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete_forever)),
              ],
            )),
      ),
    );
  }
}
//() => openNoteBox(docID: docID)
//() => firestoreService.deleteNote(docID)