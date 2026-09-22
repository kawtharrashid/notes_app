import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/widgets/color_picker_list.dart';
import 'package:notesapp/widgets/custom_button.dart';
import 'package:notesapp/widgets/custom_text_field.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _title;
  String? _content;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          const SizedBox(height: 32),
          CustomTextField(
            hint: 'Title',
            onSaved: (value) => _title = value,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: 'Content',
            maxLines: 5,
            onSaved: (value) => _content = value,
          ),
          const SizedBox(height: 32),
          BlocBuilder<AddNoteCubit, AddNoteState>(
            buildWhen: (previous, current) =>
                current is AddNoteColorChanged || previous is AddNoteInitial,
            builder: (context, state) {
              return ColorPickerList(
                selectedColor:
                    Color(context.read<AddNoteCubit>().color.toARGB32()), //here
                onColorSelected: (color) =>
                    context.read<AddNoteCubit>().changeColor(color), //here
              );
            },
          ),
          const SizedBox(height: 32),
          BlocBuilder<AddNoteCubit, AddNoteState>(
            builder: (context, state) {
              final isLoading = state is AddNoteLoading;

              return CustomButton(
                isLoading: isLoading,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();

                    final noteModel = NoteModel(
                      title: _title ?? '',
                      content: _content ?? '',
                      noteColor:
                          context.read<AddNoteCubit>().color.toARGB32(), //here
                    );

                    context.read<AddNoteCubit>().addNote(noteModel);
                    return;
                  }

                  setState(() {
                    _autovalidateMode = AutovalidateMode.always;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
