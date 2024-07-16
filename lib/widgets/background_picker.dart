import 'package:flutter/material.dart';

class BackgroundPicker extends StatelessWidget {
  final Function(Color) onBackgroundSelected;

   BackgroundPicker({required this.onBackgroundSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onBackgroundSelected(Colors.white),
          child: Container(color: Colors.white, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundSelected(Colors.yellow),
          child: Container(color: Colors.yellow, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundSelected(Colors.grey),
          child: Container(color: Colors.grey, width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundSelected(Colors.purple),
          child: Container(color: Colors.purple, width: 30, height: 30),
        ),
      ],
    );
  }
}
