
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import '../objectbox.g.dart';
import '../models/note.dart';

final objectBoxProvider = FutureProvider<ObjectBox>((ref) async {
  return await ObjectBox.create();
});

class ObjectBox {
  late final Store store;
  late final Box<Note> noteBox;

  static ObjectBox? _instance;

  ObjectBox._create(this.store) {
    noteBox = Box<Note>(store);
  }

  static Future<ObjectBox> create() async {
    if (_instance == null) {
      final store = await openStore();
      _instance = ObjectBox._create(store);
    }
    return _instance!;
  }

  void addNote(Note note) => noteBox.put(note);
  List<Note> getNotes() => noteBox.getAll();
  void deleteNote(int id) => noteBox.remove(id);
  void updateNote(Note note) => noteBox.put(note);
}
