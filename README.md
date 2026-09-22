# Notes App

![CI](https://github.com/kawtharrashid/note_sapp/actions/workflows/ci.yml/badge.svg)

A lightweight Flutter notes app with local, offline-first persistence via Hive, and Cubit-based state management. Notes have a title, content, a creation timestamp, and a user-selected color.

Features
- Create, edit, and delete notes (Hive local storage — no backend/network required)
- Color-tagged notes via a shared color picker (`ColorPickerList`), used consistently in both the add and edit flows
- Live local search — filters already-loaded notes by title/content as you type, with a search toggle in the app bar
- Delete confirmation dialog before removing a note
- Clean Cubit separation: `NotesCubit` (list/search/delete) vs `AddNoteCubit` (scoped to the add-note bottom sheet)

Architecture overview
- `cubits/notes_cubit`: owns the full notes list, search filtering, and delete logic. The UI only ever reads from `NotesState` (`NotesSuccess.notes`) — there is no separate mutable list exposed for the UI to read directly. The Hive `Box<NoteModel>` is injected via the constructor rather than looked up globally (`Hive.box(...)`), which is what makes it possible to unit-test this Cubit against a real, temporary Hive box instead of the app's actual on-device data.
- `cubits/add_note_cubit`: scoped per add-note bottom sheet via `BlocProvider`, tracks the in-progress color selection and the save operation's loading/error state. Same constructor-injected `Box<NoteModel>` as `NotesCubit`.
- `models/note_model.dart`: the Hive-persisted model. `noteColorValue` is stored as a plain `int` (the color's ARGB32 value) rather than a `Color` object, since Hive doesn't natively support Flutter's `Color` type without a custom `TypeAdapter`.
- `widgets/`: shared, reusable UI pieces (`CustomButton`, `CustomTextField`, `CustomAppBar`, `ColorPickerList`, `CustomNoteItem`).

Getting started

Prerequisites
- Flutter SDK (stable) installed and on your PATH

Local setup
1. Clone the repository:

	git clone https://github.com/kawtharrashid/notes_app
	cd notesapp

2. Install dependencies:

```bash
flutter pub get
```

3. Generate the Hive adapter (required after any change to `NoteModel`):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

Testing
- Unit tests cover `NotesCubit` (fetch/search/delete) and `AddNoteCubit` (color selection, saving), using `bloc_test` against a real, temporary Hive box (via `Hive.init()` on a `Directory.systemTemp` path) rather than the on-device Hive instance — so tests are fast, isolated, and don't touch real app data.

```bash
flutter test
```

Continuous Integration
- Every push and pull request to `main` runs `flutter analyze` and `flutter test` via GitHub Actions (`.github/workflows/ci.yml`), so a failing test or new analyzer warning is caught before merging.

Development notes
- If you add or change a `@HiveField` in `NoteModel`, always re-run `build_runner` — the generated `note_model.g.dart` must match the model exactly or Hive will throw at runtime.
- Colors are stored as `int` (ARGB32), not `Color`. When adding a new Hive field of a non-primitive type, either convert it to a primitive at the model boundary (as done here) or write and register a proper `TypeAdapter` for it — otherwise Hive will throw `HiveError: Cannot write, unknown type` the first time you try to save.
- Search (`NotesCubit.search`) filters the already-loaded, in-memory list — it does not re-query Hive, so it's instant.
