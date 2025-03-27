import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id(assignable: true)
  int id;  // ID deve essere definito
  String title;
  String text;

  Note({this.id = 0, required this.title, required this.text});
}
