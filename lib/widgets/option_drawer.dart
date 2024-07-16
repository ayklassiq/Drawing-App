import 'package:flutter/material.dart';
import 'color_picker.dart';
import 'background_picker.dart';
import 'background_image_picker.dart';

class OptionsDrawer extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Function(Color) onBackgroundSelected;
  final Function(String) onFontSelected;
  final Function(String) onBackgroundImageSelected; // Added this callback for background image selection

  OptionsDrawer({
    required this.onColorSelected,
    required this.onBackgroundSelected,
    required this.onFontSelected,
    required this.onBackgroundImageSelected, // Add this parameter to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Select Drawing Color',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Select Drawing Color',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    content: ColorPicker(
                      onColorSelected: (color) {
                        onColorSelected(color);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              'Select Background Color',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Select Background Color',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    content: BackgroundPicker(
                      onBackgroundSelected: (color) {
                        onBackgroundSelected(color);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              'Select Background Image',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Select Background Image',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    content: BackgroundImagePicker(
                      onBackgroundImageSelected: (imagePath) {
                        onBackgroundImageSelected(imagePath);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              'Select Font',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Select Font',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text(
                            'Dancing Script',
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            onFontSelected('DancingScript');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'Pacifico',
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            onFontSelected('Pacifico');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'Lobster',
                            style: TextStyle(
                              fontFamily: 'Pacifico',
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            onFontSelected('Lobster');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
