//
import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  Color _backgroundColor = Colors.white;

  Color get backgroundColor => _backgroundColor;

  void updateBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }
}
