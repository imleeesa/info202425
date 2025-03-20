import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import '../models/note.dart';
import '../objectbox.g.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  final store = Store(getObjectBoxModel());
  return ObjectBox(store);
});

class ObjectBox {
  late final Store store;
  late final Box<Note> noteBox;

  ObjectBox(this.store) {
    noteBox = store.box<Note>();
  }

  void addNote(Note note) => noteBox.put(note);
  void deleteNote(int id) => noteBox.remove(id);
  List<Note> getNotes() => noteBox.getAll();
}
