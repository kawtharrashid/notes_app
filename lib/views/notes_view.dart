import 'package:flutter/material.dart';
import 'package:notesapp/widgets/add_note_bottom_sheet.dart';
import 'package:notesapp/widgets/custom_notes_body.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => const AddNoteBottomSheet(),
          );
        },
        backgroundColor: const Color(0xff00BCD4),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: CustomNotesBody(),
      ),
    );
  }
}
