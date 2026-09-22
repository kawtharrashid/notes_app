import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/widgets/custom_note_item.dart';

class NotesListView extends StatelessWidget {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        List<NoteModel> notes = [];

        if (state is NotesSuccess) {
          notes = state.notes;
        }

        if (notes.isEmpty) {
          final isSearching =
              context.read<NotesCubit>().searchQuery.trim().isNotEmpty;
          return Center(
            child: Text(
              isSearching ? 'No notes found' : 'No notes added yet',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomNoteItem(noteModel: notes[index]),
            );
          },
        );
      },
    );
  }
}
