import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    final ImagePicker picker = ImagePicker();
    // Pick multiple images
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        images.add(File(file.path));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
