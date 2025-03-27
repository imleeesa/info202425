import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/objectbox_provider.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Notez')),
      body: objectBoxAsync.when(
        data: (objectBox) {
          final notes = objectBox.getNotes();
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteEditScreen(note: note),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          objectBox.deleteNote(note.id);
                          ref.invalidate(objectBoxProvider);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Errore: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteEditScreen()),
        ),
      ),
    );
  }
}
