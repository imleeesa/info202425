
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/objectbox_provider.dart';

class NoteEditScreen extends ConsumerWidget {
  final Note? note;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  NoteEditScreen({this.note}) {
    if (note != null) {
      titleController.text = note!.title;
      textController.text = note!.text;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return Scaffold(
      appBar: AppBar(title: Text(note == null ? 'Aggiungi Nota' : 'Modifica Nota')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Titolo')),
            TextField(controller: textController, decoration: InputDecoration(labelText: 'Testo')),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                objectBoxAsync.when(
                  data: (objectBox) {
                    final updatedNote = Note(
                      id: note?.id ?? 0,
                      title: titleController.text,
                      text: textController.text,
                    );
                    if (note == null) {
                      objectBox.addNote(updatedNote);
                    } else {
                      objectBox.updateNote(updatedNote);
                    }
                    ref.invalidate(objectBoxProvider);
                    Navigator.pop(context);
                  },
                  loading: () {},
                  error: (err, stack) => print(err),
                );
              },
              child: Text(note == null ? 'Salva' : 'Aggiorna'),
            ),
          ],
        ),
      ),
    );
  }
}