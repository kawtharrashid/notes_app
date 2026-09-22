import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  int noteColor;

  NoteModel({
    required this.title,
    required this.content,
    DateTime? createdAt,
    required this.noteColor,
  }) : createdAt = createdAt ?? DateTime.now();
}