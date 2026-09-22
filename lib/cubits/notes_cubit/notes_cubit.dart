import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/models/note_model.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this.notesBox) : super(NotesInitial());

  final Box<NoteModel> notesBox;
  List<NoteModel> _allNotes = const [];
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  Future<void> fetchAllNotes() async {
    try {
      emit(NotesLoading());
      _allNotes = notesBox.values.toList();
      emit(NotesSuccess(_applySearch(_allNotes)));
    } catch (error) {
      emit(NotesFailure(error.toString()));
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    try {
      await note.delete();
      await fetchAllNotes();
    } catch (error) {
      emit(NotesFailure(error.toString()));
    }
  }

  void search(String query) {
    _searchQuery = query;
    emit(NotesSuccess(_applySearch(_allNotes)));
  }

  List<NoteModel> _applySearch(List<NoteModel> source) {
    if (_searchQuery.trim().isEmpty) return source;

    final query = _searchQuery.trim().toLowerCase();

    return source
        .where(
          (note) =>
              note.title.toLowerCase().contains(query) ||
              note.content.toLowerCase().contains(query),
        )
        .toList();
  }
}
