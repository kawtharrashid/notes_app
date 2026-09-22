import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/notes_cubit/notes_cubit.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/widgets/color_picker_list.dart';
import 'package:notesapp/widgets/custom_app_bar.dart';
import 'package:notesapp/widgets/custom_text_field.dart';

class EditNoteViewBody extends StatefulWidget {
  const EditNoteViewBody({super.key, required this.note});

  final NoteModel note;

  @override
  State<EditNoteViewBody> createState() => _EditNoteViewBodyState();
}

class _EditNoteViewBodyState extends State<EditNoteViewBody> {
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 50),
          CustomAppBar(
            onPressed: () {
              widget.note.title = title ?? widget.note.title;
              widget.note.content = content ?? widget.note.content;
              widget.note.save();
              context.read<NotesCubit>().fetchAllNotes();
              Navigator.pop(context);
            },
            title: 'Edit Note',
            icon: Icons.check,
          ),
          const SizedBox(height: 50),
          CustomTextField(
            initialValue: widget.note.title,
            onChanged: (value) => title = value,
            color: Color(widget.note.noteColor),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomTextField(
              initialValue: widget.note.content,
              onChanged: (value) => content = value,
              maxLines: null,
              expands: true,
              color: Color(widget.note.noteColor),
            ),
          ),
          const SizedBox(height: 16),
          ColorPickerList(
            selectedColor: Color(widget.note.noteColor),
            onColorSelected: (color) {
              setState(() {
                widget.note.noteColor = color.toARGB32();
              });
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
