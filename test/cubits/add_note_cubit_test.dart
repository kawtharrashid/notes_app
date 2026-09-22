import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notesapp/models/note_model.dart';

void main() {
  late Directory tempDir;
  late Box<NoteModel> box;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('add_note_cubit_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(NoteModelAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<NoteModel>('add_note_test_box');
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

  group('changeColor', () {
    blocTest<AddNoteCubit, AddNoteState>(
      'updates color and emits AddNoteColorChanged with the new color',
      build: () => AddNoteCubit(box),
      act: (cubit) => cubit.changeColor(Colors.blue),
      expect: () => [
        isA<AddNoteColorChanged>().having(
          (s) => s.color,
          'color',
          Colors.blue,
        ),
      ],
      verify: (cubit) {
        expect(cubit.color, Colors.blue);
      },
    );
  });

  group('addNote', () {
    blocTest<AddNoteCubit, AddNoteState>(
      'stamps the currently-selected color onto the note and saves it',
      build: () => AddNoteCubit(box),
      act: (cubit) {
        cubit.changeColor(Colors.blue);
        return cubit.addNote(
          NoteModel(
            title: 'Groceries',
            content: 'Milk, eggs',
            noteColor: Colors.red.toARGB32(),
          ),
        );
      },
      expect: () => [
        isA<AddNoteColorChanged>(),
        isA<AddNoteLoading>(),
        isA<AddNoteSuccess>(),
      ],
      verify: (_) {
        expect(box.length, 1);
        expect(box.values.first.title, 'Groceries');
        expect(box.values.first.noteColor, Colors.blue.toARGB32());
      },
    );

    blocTest<AddNoteCubit, AddNoteState>(
      'emits AddNoteFailure without throwing when the box is already closed',
      build: () => AddNoteCubit(box),
      act: (cubit) async {
        await box.close();
        await cubit.addNote(
          NoteModel(
            title: 'Groceries',
            content: 'Milk, eggs',
            noteColor: Colors.red.toARGB32(),
          ),
        );
      },
      expect: () => [
        isA<AddNoteLoading>(),
        isA<AddNoteFailure>(),
      ],
    );
  });
}
