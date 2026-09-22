import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/widgets/add_note.dart';

class AddNoteBottomSheet extends StatelessWidget {
  const AddNoteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<NotesCubit>()),
        BlocProvider(
          create: (_) => AddNoteCubit(context.read<NotesCubit>().notesBox),
        ),
      ],
      child: BlocListener<AddNoteCubit, AddNoteState>(
        listener: (listenerContext, state) {
          if (state is AddNoteFailure) {
            ScaffoldMessenger.of(listenerContext).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }

          if (state is AddNoteSuccess) {
            listenerContext.read<NotesCubit>().fetchAllNotes();
            Navigator.of(listenerContext, rootNavigator: true).pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const SingleChildScrollView(
            child: AddNote(),
          ),
        ),
      ),
    );
  }
}
