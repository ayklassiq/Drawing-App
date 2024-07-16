import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/drawing_provider.dart';

class DrawingCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        Provider.of<DrawingProvider>(context, listen: false)
            .addPoint(details.localPosition);
      },
      onPanEnd: (details) {
        Provider.of<DrawingProvider>(context, listen: false).endDrawing();
      },
      onDoubleTapDown: (details) async {
        String? text = await _showTextInputDialog(context);
        if (text != null) {
          var drawingProvider =
          Provider.of<DrawingProvider>(context, listen: false);
          drawingProvider.addText(TextData(
            position: details.localPosition,
            text: text,
            color: drawingProvider.selectedColor,
            fontFamily: drawingProvider.selectedFontFamily,
          ));
        }
      },
      child: Consumer<DrawingProvider>(
        builder: (context, drawingProvider, child) {
          return CustomPaint(
            painter: _DrawingPainter(
              drawingProvider.points,
              drawingProvider.texts,
              drawingProvider.selectedColor,
              drawingProvider.selectedFontFamily,
              drawingProvider.backgroundColor,
              drawingProvider.backgroundImage, // Pass background image
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter text'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Text"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final List<TextData> texts;
  final Color color;
  final String selectedFontFamily;
  final Color backgroundColor;
  final String? backgroundImage;

  _DrawingPainter(
      this.points,
      this.texts,
      this.color,
      this.selectedFontFamily,
      this.backgroundColor,
      this.backgroundImage,
      );

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundImage != null) {
      // Load and paint background image
      final image = AssetImage(backgroundImage!);
      final configuration = ImageConfiguration();
      image
          .resolve(configuration)
          .addListener(ImageStreamListener((ImageInfo info, bool synchronousCall) {
        canvas.drawImage(info.image, Offset.zero, Paint());
      }));
    } else {
      // Paint background color
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor,
      );
    }

    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    for (var textData in texts) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: textData.text,
          style: TextStyle(
            color: textData.color,
            fontFamily: textData.fontFamily,
            fontSize: 24,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, textData.position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
