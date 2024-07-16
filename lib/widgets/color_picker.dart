import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Function(Color) onColorSelected;

  ColorPicker({required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onColorSelected(Colors.red),
          child: Container(color: Colors.red, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onColorSelected(Colors.green),
          child: Container(color: Colors.green, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onColorSelected(Colors.blue),
          child: Container(color: Colors.blue, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onColorSelected(Colors.brown),
          child: Container(color: Colors.brown, width: 30, height: 30),
        ),
      ],
    );
  }
}
