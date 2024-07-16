import 'package:flutter/material.dart';

class BackgroundImagePicker extends StatelessWidget {
  final Function(String) onBackgroundImageSelected;

  BackgroundImagePicker({ required this.onBackgroundImageSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onBackgroundImageSelected('assets/images/cake.jpg'),
          child: Image.asset('assets/images/cake.jpg', width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundImageSelected('assets/images/paint.jpg'),
          child: Image.asset('assets/images/paint.jpg', width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundImageSelected('assets/images/sun.jpg'),
          child: Image.asset('assets/images/sun.jpg', width: 30, height: 30),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => onBackgroundImageSelected('assets/images/reflect.jpg'),
          child: Image.asset('assets/images/reflect.jpg', width: 30, height: 30),
        ),
      ],
    );
  }
}
