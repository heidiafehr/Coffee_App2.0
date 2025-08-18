import 'dart:io';

import 'package:coffee_app_2/favorites_screen/bloc/favorites_bloc.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayFavoriteImages extends StatelessWidget {
  const DisplayFavoriteImages({required this.imagePaths, super.key});

  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = context.read<FavoritesBloc>();

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        final imagePath = imagePaths[index];
        final file = File(imagePath);
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 1,
              child: ElevatedButton(
                onPressed: () async {
                  favoritesBloc.add(RemoveFavoritesImage(imagePath));
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: Icon(Icons.favorite),
              ),
            ),
          ],
        );
      },
    );
  }
}
