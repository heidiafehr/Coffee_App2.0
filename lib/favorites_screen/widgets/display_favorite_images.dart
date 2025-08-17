import 'dart:io';

import 'package:flutter/material.dart';

class DisplayFavoriteImages extends StatelessWidget {
  const DisplayFavoriteImages({required this.imagePaths, super.key});

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        final imagePath = imagePaths[index];
        final file = File(imagePath);

        return AspectRatio(aspectRatio: 1, child: Image.file(file),);
    },); 
  }
}