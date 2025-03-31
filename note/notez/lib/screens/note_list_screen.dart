import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/objectbox_provider.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends ConsumerStatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends ConsumerState<NoteListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notez'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: NoteSearchDelegate(ref),
              );
              if (result != null) {
                setState(() {
                  searchQuery = result;
                });
              }
            },
          )
        ],
      ),
      body: objectBoxAsync.when(
        data: (objectBox) {
          final notes = objectBox.getNotes().where((note) {
            return note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                note.getTagList().any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
          }).toList();

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 4,
                child: ListTile(
                  title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(note.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      if (note.id != null) {
                        objectBox.deleteNote(note.id!); // Ensure `id` is non-null
                        ref.invalidate(objectBoxProvider);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NoteEditScreen(note: note)),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Errore nel caricamento delle note: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditScreen())),
      ),
    );
  }
}class NoteSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;
  NoteSearchDelegate(this.ref);

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon (e.g., back button) in the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search delegate
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions (e.g., clear button) in the search bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
          showSuggestions(context); // Refresh suggestions
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final objectBoxAsync = ref.watch(objectBoxProvider);

    return objectBoxAsync.when(
      data: (objectBox) {
        final notes = objectBox.getNotes().where((note) {
          return note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.getTagList().any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        }).toList();

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.text, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () {
                close(context, query); // Return the search query
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditScreen(note: note)));
              },
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Errore nel caricamento: $error'),
      ),
    );
  }
}