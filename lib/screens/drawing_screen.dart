import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/drawing_provider.dart';
import '../services/storage _service.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/option_drawer.dart';

class DrawingScreen extends StatelessWidget {
  final StorageService storageService = StorageService();

  Future<void> saveDrawing(BuildContext context) async {
    String? filename = await _showFilenameDialog(context);
    if (filename != null) {
      var drawingProvider =
          Provider.of<DrawingProvider>(context, listen: false);
      await storageService.saveDrawing(
        filename,
        drawingProvider.points,
        drawingProvider.texts,
        drawingProvider.selectedColor,
        drawingProvider.backgroundColor, // Save background color
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Drawing saved!')));
    }
  }

  Future<void> loadDrawing(BuildContext context) async {
    List<String> drawings = await storageService.listDrawings();
    String? selectedDrawing =
        await _showDrawingSelectionDialog(context, drawings);
    if (selectedDrawing != null) {
      Map<String, dynamic> drawingData =
          await storageService.loadDrawing(selectedDrawing);
      if (drawingData.isNotEmpty) {
        var drawingProvider =
            Provider.of<DrawingProvider>(context, listen: false);
        drawingProvider.clearPoints();
        drawingProvider.setPoints((drawingData['points'] as List)
            .map((e) => Offset(e['dx'], e['dy']))
            .toList());
        drawingProvider.setTexts((drawingData['texts'] as List)
            .map((e) => TextData.fromJson(e))
            .toList());
        drawingProvider.updateColor(Color(drawingData['color']));
        drawingProvider.setBackgroundColor(
            Color(drawingData['backgroundColor'])); // Load background color
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Drawing loaded!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load drawing.')));
      }
    }
  }

  Future<String?> _showFilenameDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Enter filename',
            style: TextStyle(
              fontFamily: 'Pacifico',
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Filename",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showDrawingSelectionDialog(
      BuildContext context, List<String> drawings) async {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Drawing',
            style: TextStyle(
              fontFamily: 'Pacifico',
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: drawings.map((filename) {
                return GestureDetector(
                  child: Text(filename),
                  onTap: () {
                    Navigator.of(context).pop(filename);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drawing App',
          style: TextStyle(
            fontFamily: 'Lobster',
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.blueAccent, weight: 900),
            onPressed: () => saveDrawing(context),
          ),
          IconButton(
            icon:
                const Icon(Icons.folder_open, color: Colors.brown, weight: 900),
            onPressed: () => loadDrawing(context),
          ),
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
              weight: 900,
            ),
            onPressed: () {
              Provider.of<DrawingProvider>(context, listen: false)
                  .clearPoints();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.undo,
              color: Colors.purple,
              weight: 900,
            ),
            onPressed: () {
              Provider.of<DrawingProvider>(context, listen: false).undoLast();
            },
          ),
        ],
      ),
      drawer: OptionsDrawer(
        onColorSelected: (color) {
          Provider.of<DrawingProvider>(context, listen: false)
              .updateColor(color);
        },
        onBackgroundSelected: (color) {
          Provider.of<DrawingProvider>(context, listen: false)
              .setBackgroundColor(color);
        },
        onFontSelected: (fontFamily) {
          Provider.of<DrawingProvider>(context, listen: false)
              .updateFontFamily(fontFamily);
        },onBackgroundImageSelected: (imagePath) {
        Provider.of<DrawingProvider>(context, listen: false).setBackgroundImage(imagePath);
      },
      ),
      body: Consumer<DrawingProvider>(
        builder: (context, drawingProvider, child) {
          return Container(
            color: drawingProvider
                .backgroundColor, // Use background color from provider
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Landscape mode
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DrawingCanvas(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: OptionsDrawer(
                            onColorSelected: (color) {
                              Provider.of<DrawingProvider>(context,
                                      listen: false)
                                  .updateColor(color);
                            },
                            onBackgroundSelected: (color) {
                              Provider.of<DrawingProvider>(context,
                                      listen: false)
                                  .setBackgroundColor(color);
                            },
                            onFontSelected: (fontFamily) {
                              Provider.of<DrawingProvider>(context,
                                      listen: false)
                                  .updateFontFamily(fontFamily);
                            },onBackgroundImageSelected: (imagePath) {
                            Provider.of<DrawingProvider>(context, listen: false).setBackgroundImage(imagePath);
                          },
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Portrait mode (or smaller screens)
                  return DrawingCanvas();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/drawing_provider.dart';
// import '../services/storage _service.dart';
// import '../widgets/drawing_canvas.dart';
// import '../widgets/option_drawer.dart';
//
// class DrawingScreen extends StatefulWidget {
//   @override
//   _DrawingScreenState createState() => _DrawingScreenState();
// }
//
// class _DrawingScreenState extends State<DrawingScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final StorageService storageService = StorageService();
//
//   Future<void> saveDrawing() async {
//     String? filename = await _showFilenameDialog();
//     if (filename != null) {
//       var drawingProvider =
//       Provider.of<DrawingProvider>(context, listen: false);
//       await storageService.saveDrawing(
//         filename,
//         drawingProvider.points,
//         drawingProvider.texts,
//         drawingProvider.selectedColor,
//         drawingProvider.backgroundColor, // Save background color
//       );
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Drawing saved!')));
//     }
//   }
//
//   Future<void> loadDrawing() async {
//     List<String> drawings = await storageService.listDrawings();
//     String? selectedDrawing =
//     await _showDrawingSelectionDialog(drawings);
//     if (selectedDrawing != null) {
//       Map<String, dynamic> drawingData =
//       await storageService.loadDrawing(selectedDrawing);
//       if (drawingData.isNotEmpty) {
//         var drawingProvider =
//         Provider.of<DrawingProvider>(context, listen: false);
//         drawingProvider.clearPoints();
//         drawingProvider.setPoints((drawingData['points'] as List)
//             .map((e) => Offset(e['dx'], e['dy']))
//             .toList());
//         drawingProvider.setTexts((drawingData['texts'] as List)
//             .map((e) => TextData.fromJson(e))
//             .toList());
//         drawingProvider.updateColor(Color(drawingData['color']));
//         drawingProvider.setBackgroundColor(
//             Color(drawingData['backgroundColor'])); // Load background color
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text('Drawing loaded!')));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to load drawing.')));
//       }
//     }
//   }
//
//   Future<String?> _showFilenameDialog() async {
//     TextEditingController controller = TextEditingController();
//     return showDialog<String?>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Enter filename',
//             style: TextStyle(
//               fontFamily: 'Pacifico',
//               color: Colors.black,
//               fontSize: 16,
//             ),
//           ),
//           content: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: "Filename",
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'CANCEL',
//                 style: TextStyle(
//                   fontFamily: 'Pacifico',
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(null);
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 'OK',
//                 style: TextStyle(
//                   fontFamily: 'Pacifico',
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(controller.text);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<String?> _showDrawingSelectionDialog(
//       List<String> drawings) async {
//     return showDialog<String?>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Select Drawing',
//             style: TextStyle(
//               fontFamily: 'Pacifico',
//               color: Colors.black,
//               fontSize: 16,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: drawings.map((filename) {
//                 return GestureDetector(
//                   child: Text(filename),
//                   onTap: () {
//                     Navigator.of(context).pop(filename);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'CANCEL',
//                 style: TextStyle(
//                   fontFamily: 'Pacifico',
//                   color: Colors.black,
//                   fontSize: 16,
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(null);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: const Text(
//           'Drawing App',
//           style: TextStyle(
//             fontFamily: 'Lobster',
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//             fontSize: 26,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save, color: Colors.blueAccent, weight: 900),
//             onPressed: saveDrawing,
//           ),
//           IconButton(
//             icon: const Icon(Icons.folder_open, color: Colors.brown, weight: 900),
//             onPressed: loadDrawing,
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.clear,
//               color: Colors.red,
//               weight: 900,
//             ),
//             onPressed: () {
//               Provider.of<DrawingProvider>(context, listen: false).clearPoints();
//             },
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.undo,
//               color: Colors.purple,
//               weight: 900,
//             ),
//             onPressed: () {
//               Provider.of<DrawingProvider>(context, listen: false).undoLast();
//             },
//           ),
//         ],
//       ),
//       drawer: OptionsDrawer(
//         onColorSelected: (color) {
//           Provider.of<DrawingProvider>(context, listen: false).updateColor(color);
//         },
//         onBackgroundSelected: (color) {
//           Provider.of<DrawingProvider>(context, listen: false).setBackgroundColor(color);
//         },
//         onFontSelected: (fontFamily) {
//           Provider.of<DrawingProvider>(context, listen: false).updateFontFamily(fontFamily);
//         },onBackgroundImageSelected: (imagePath) {
//         Provider.of<DrawingProvider>(context, listen: false).setBackgroundImage(imagePath);
//       },
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth > 600) {
//             // Landscape mode
//             return Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Consumer<DrawingProvider>(
//                     builder: (context, drawingProvider, child) {
//                       return Container(
//                         color: drawingProvider.backgroundColor,
//                         child: DrawingCanvas(
//
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     color: Colors.grey[200],
//                     child: OptionsDrawer(
//                       onColorSelected: (color) {
//                         Provider.of<DrawingProvider>(context, listen: false).updateColor(color);
//                       },
//                       onBackgroundSelected: (color) {
//                         Provider.of<DrawingProvider>(context, listen: false).setBackgroundColor(color);
//                       },
//                       onFontSelected: (fontFamily) {
//                         Provider.of<DrawingProvider>(context, listen: false)
//                             .updateFontFamily(fontFamily);
//                       },onBackgroundImageSelected: (imagePath) {
//                       Provider.of<DrawingProvider>(context, listen: false).setBackgroundImage(imagePath);
//                     },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // Portrait mode (or smaller screens)
//             return Consumer<DrawingProvider>(
//               builder: (context, drawingProvider, child) {
//                 return Container(
//                   color: drawingProvider.backgroundColor,
//                   child: DrawingCanvas(
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
