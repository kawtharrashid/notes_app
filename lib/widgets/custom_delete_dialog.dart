import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/models/note_model.dart';

class CustomDeleteDialog extends StatelessWidget {
  const CustomDeleteDialog(
      {super.key, required this.dialogContext, required this.noteModel});
  final BuildContext dialogContext;
  final NoteModel noteModel;
  // NoteModel get noteModel => null;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete note'),
      content: const Text('Are you sure you want to delete this note?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<NotesCubit>(context).deleteNote(noteModel);
            Navigator.of(dialogContext).pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
