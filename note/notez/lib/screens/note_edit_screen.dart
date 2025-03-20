import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/objectbox_provider.dart';

class NoteEditScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectBox = ref.watch(objectBoxProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Aggiungi Nota')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titolo'),
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Testo'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final note = Note(
                  title: titleController.text,
                  text: textController.text,
                );
                objectBox.addNote(note);
                ref.invalidate(objectBoxProvider);
                Navigator.pop(context);
              },
              child: Text('Salva'),
            )
          ],
        ),
      ),
    );
  }
}
