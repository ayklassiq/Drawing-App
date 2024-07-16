
import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingModel {
  List<Offset> points;
  Color selectedColor;
  String selectedFontFamily;

  DrawingModel({
    required this.points,
    required this.selectedColor,
    required this.selectedFontFamily,
  });
}



// app_state.dart


class AppState extends ChangeNotifier {
  Color _backgroundColor = Colors.white;

  Color get backgroundColor => _backgroundColor;

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }
}
