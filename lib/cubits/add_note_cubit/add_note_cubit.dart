import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/models/note_model.dart';
part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit(this.notesBox) : super(AddNoteInitial());

  final Box<NoteModel> notesBox;
  Color color = const Color(0xffAC3931);

  Future<void> addNote(NoteModel note) async {
    note.noteColor = color.toARGB32();

    emit(AddNoteLoading());

    try {
      await notesBox.add(note);

      emit(AddNoteSuccess());
    } catch (error) {
      emit(AddNoteFailure(error.toString()));
    }
  }

  void changeColor(Color newColor) {
    color = newColor;
    emit(AddNoteColorChanged(newColor));
  }
}
