import 'package:flutter/material.dart';
import 'package:notesapp/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.hint,
      this.maxLines,
      this.onSaved,
      this.onChanged,
      this.color,
      this.expands = false,
      this.initialValue});

  final String? hint;
  final int? maxLines;
  final Color? color;
  final bool expands;
  final void Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      onSaved: onSaved,
      expands: expands,
      // When a field expands to fill its parent, Flutter requires
      // maxLines to be null (they're mutually exclusive).
      maxLines: expands ? null : maxLines,
      minLines: expands ? null : 1,
      textAlignVertical: expands ? TextAlignVertical.top : null,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Field is required ';
        } else {
          return null;
        }
      },
      cursorColor: color ?? kPrimaryColor,
      decoration: InputDecoration(
        hintText: hint,
        border: buildBorder(color),
        enabledBorder: buildBorder(color),
        focusedBorder: buildBorder(color),
      ),
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
        borderSide: BorderSide(
          color: color ?? Colors.white,
        ));
  }
}
