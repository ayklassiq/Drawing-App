import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/drawing_provider.dart';

class StorageService {
  Future<void> saveDrawing(String filename, List<Offset> points, List<TextData> texts, Color color, Color backgroundColor, {String? backgroundImage}) async {
    final prefs = await SharedPreferences.getInstance();
    final pointsData = points.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    final textsData = texts.map((e) => e.toJson()).toList();
    final drawingData = {
      'points': pointsData,
      'texts': textsData,
      'color': color.value,
      'backgroundColor': backgroundColor.value,
      'backgroundImage': backgroundImage, // Add background image
    };
    prefs.setString(filename, json.encode(drawingData));
  }

  Future<Map<String, dynamic>> loadDrawing(String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final drawingData = prefs.getString(filename);
    if (drawingData != null) {
      return json.decode(drawingData);
    }
    return {};
  }

  Future<List<String>> listDrawings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }
}
