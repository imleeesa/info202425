import 'package:objectbox/objectbox.dart';

/// Represents a note entity stored in the database.
@Entity()
class Note {
  /// The unique identifier for the note.
  @Id(assignable: true)
  int? id;

  /// The title of the note.
  String title;

  /// The main text content of the note.
  String text;

  /// Tags associated with the note, stored as a comma-separated string.
  @Index() // Adding an index for better query performance.
  String tags;

  /// Constructor for the Note class.
  Note({
    this.id,
    required this.title,
    required this.text,
    this.tags = "",
  });

  /// Returns a list of tags by splitting the comma-separated string.
  List<String> getTagList() => tags.isNotEmpty ? tags.split(",") : [];

  /// Sets the tags from a list of strings by joining them with commas.
  void setTagList(List<String> tagList) => tags = tagList.join(",");
}