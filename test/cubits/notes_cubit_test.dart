import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/models/note_model.dart';

void main() {
  late Directory tempDir;
  late Box<NoteModel> box;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('notes_cubit_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteModelAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<NoteModel>('notes_test_box');
    await box.clear();
  });

  tearDown(() async {
    await box.close();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  NoteModel buildNote({
    required String title,
    required String content,
  }) {
    return NoteModel(
      title: title,
      content: content,
      noteColor: 0xFFAC3931,
    );
  }

  group('fetchAllNotes', () {
    blocTest<NotesCubit, NotesState>(
      'emits [loading, success] with every note in the box',
      build: () => NotesCubit(box),
      act: (cubit) async {
        await box.add(buildNote(title: 'Groceries', content: 'Milk, eggs'));
        await box.add(buildNote(title: 'Workout', content: 'Leg day'));
        await cubit.fetchAllNotes();
      },
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>().having(
          (s) => s.notes.length,
          'notes.length',
          2,
        ),
      ],
    );

    blocTest<NotesCubit, NotesState>(
      'emits [loading, success([])] when the box is empty',
      build: () => NotesCubit(box),
      act: (cubit) => cubit.fetchAllNotes(),
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>().having((s) => s.notes, 'notes', isEmpty),
      ],
    );
  });

  group('search', () {
    blocTest<NotesCubit, NotesState>(
      'filters the already-loaded notes by title/content, case-insensitively',
      build: () => NotesCubit(box),
      act: (cubit) async {
        await box.add(buildNote(title: 'Groceries', content: 'Milk, eggs'));
        await box.add(buildNote(title: 'Workout plan', content: 'Leg day'));
        await cubit.fetchAllNotes();
        cubit.search('work');
      },
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>().having((s) => s.notes.length, 'notes.length', 2),
        isA<NotesSuccess>()
            .having((s) => s.notes.length, 'notes.length', 1)
            .having((s) => s.notes.first.title, 'title', 'Workout plan'),
      ],
    );

    blocTest<NotesCubit, NotesState>(
      'clearing the query (empty string) restores the full list',
      build: () => NotesCubit(box),
      act: (cubit) async {
        await box.add(buildNote(title: 'Groceries', content: 'Milk, eggs'));
        await cubit.fetchAllNotes();
        cubit.search('nothing matches this');
        cubit.search('');
      },
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>().having((s) => s.notes.length, 'notes.length', 1),
        isA<NotesSuccess>().having((s) => s.notes, 'notes', isEmpty),
        isA<NotesSuccess>().having((s) => s.notes.length, 'notes.length', 1),
      ],
    );
  });

  group('deleteNote', () {
    blocTest<NotesCubit, NotesState>(
      'removes the note from the box and re-emits the remaining list',
      build: () => NotesCubit(box),
      act: (cubit) async {
        final note = buildNote(title: 'Groceries', content: 'Milk, eggs');
        await box.add(note);
        await cubit.fetchAllNotes();
        await cubit.deleteNote(note);
      },
      expect: () => [
        isA<NotesLoading>(),
        isA<NotesSuccess>().having((s) => s.notes.length, 'notes.length', 1),
        isA<NotesLoading>(),
        isA<NotesSuccess>().having((s) => s.notes, 'notes', isEmpty),
      ],
      verify: (_) {
        expect(box.isEmpty, isTrue);
      },
    );
  });
}
