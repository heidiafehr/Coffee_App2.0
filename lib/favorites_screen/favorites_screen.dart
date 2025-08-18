import 'package:coffee_app_2/favorites_screen/bloc/favorites_bloc.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_states.dart';
import 'package:coffee_app_2/favorites_screen/widgets/display_favorite_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: BlocBuilder<FavoritesBloc, FavoritesState>(builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator(),);
        } else if (state is FavoritesLoaded && state.favoriteImagePaths.isEmpty) {
          return Center(child: Text('No favorites please go back to generator page'));
        } else if (state is FavoritesLoaded && state.favoriteImagePaths.isNotEmpty) {
          return DisplayFavoriteImages(imagePaths: state.favoriteImagePaths);
        } else if (state is FavoritesError) {
          return Center(child: Text('Error: ${state.errorMessage}'),);
        } else {
          return const SizedBox.shrink();
        }
      },),
    );
  }
}