import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/views/edit_note_view.dart';
import 'package:notesapp/widgets/custom_delete_dialog.dart';
import 'package:notesapp/widgets/custom_icon.dart';

class CustomNoteItem extends StatelessWidget {
  const CustomNoteItem({
    super.key,
    required this.noteModel,
  });

  final NoteModel noteModel;

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(noteModel.noteColor);
    final date = DateFormat('dd/MM/yyyy HH:mm').format(noteModel.createdAt);

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditNoteView(note: noteModel),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: cardColor,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      noteModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  CustomIcon(
                    icon: Icons.delete,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => CustomDeleteDialog(
                          dialogContext: context, noteModel: noteModel),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                noteModel.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                date,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
