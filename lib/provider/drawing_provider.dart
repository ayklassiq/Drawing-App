import 'package:flutter/material.dart';

class DrawingProvider extends ChangeNotifier {
  List<Offset> _points = [];
  List<List<Offset>> _pointHistory = [];
  List<TextData> _texts = []; // Added to store text data
  Color _selectedColor = Colors.black;
  String _selectedFontFamily = 'Pacifico';
  Color _backgroundColor = Colors.white;// Add background color
  String? _backgroundImage; // Background image


  List<Offset> get points => _points;
  List<TextData> get texts => _texts; // Getter for texts
  Color get selectedColor => _selectedColor;
  String get selectedFontFamily => _selectedFontFamily;
  Color get backgroundColor => _backgroundColor; // Getter for background color
  String? get backgroundImage => _backgroundImage; // Getter for background image



  void addPoint(Offset point) {
    _points.add(point);
    notifyListeners();
  }

  void endDrawing() {
    _pointHistory.add(List<Offset>.from(_points));
    _points.add(Offset.zero);
    notifyListeners();
  }

  void clearPoints() {
    _points = [];
    _pointHistory = [];
    _texts = [];
    _backgroundImage = null;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    _backgroundImage = null; /// Set background color
    notifyListeners();
  }

  void undoLast() {
    if (_pointHistory.isNotEmpty) {
      _pointHistory.removeLast();
      _points = _pointHistory.isNotEmpty ? _pointHistory.last : [];
    } else {
      _points = [];
    }
    notifyListeners();
  }

  void updateColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void updateFontFamily(String fontFamily) {
    _selectedFontFamily = fontFamily;
    notifyListeners();
  }

  void addText(TextData textData) {
    _texts.add(textData);
    notifyListeners();
  }

  void setPoints(List<Offset> points) {
    _points = points;
    notifyListeners();
  }
  void setBackgroundImage(String imagePath) {
    _backgroundImage = imagePath; // Set background image
    notifyListeners();
  }

  void setTexts(List<TextData> texts) {
    _texts = texts;
    notifyListeners();
  }
}

class TextData {
  Offset position;
  String text;
  Color color;
  String fontFamily;

  TextData({
    required this.position,
    required this.text,
    required this.color,
    required this.fontFamily,
  });

  Map<String, dynamic> toJson() {
    return {
      'position': {'dx': position.dx, 'dy': position.dy},
      'text': text,
      'color': color.value,
      'fontFamily': fontFamily,
    };
  }

  static TextData fromJson(Map<String, dynamic> json) {
    return TextData(
      position: Offset(json['position']['dx'], json['position']['dy']),
      text: json['text'],
      color: Color(json['color']),
      fontFamily: json['fontFamily'],
    );
  }
}
