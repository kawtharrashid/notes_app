import 'package:flutter/material.dart';
import 'package:notesapp/constants.dart';
import 'package:notesapp/widgets/color_item.dart';

class ColorPickerList extends StatefulWidget {
  const ColorPickerList({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  State<ColorPickerList> createState() => _ColorPickerListState();
}

class _ColorPickerListState extends State<ColorPickerList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38 * 2,
      child: ListView.builder(
        itemCount: kColors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final color = kColors[index];
          final isActive = color.toARGB32() == widget.selectedColor.toARGB32();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => widget.onColorSelected(color),
              child: ColorItem(
                color: color,
                isActive: isActive,
              ),
            ),
          );
        },
      ),
    );
  }
}
