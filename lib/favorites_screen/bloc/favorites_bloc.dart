import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_events.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_states.dart';
import 'package:coffee_app_2/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading()) {
    on<LoadFavoritesCatalog>(_fetchFavorites);
    on<RemoveFavoritesImage>(_removeFavoritesImage);
  }

  final favoritesImageRepo = getIt<FavoriteCoffeeImageRepo>();

  Future<void> _fetchFavorites(
    LoadFavoritesCatalog event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favoritesPaths = await favoritesImageRepo
          .fetchFavoritedImagePaths();
      emit(FavoritesLoaded(favoritesPaths));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _removeFavoritesImage(
    RemoveFavoritesImage event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoritesImageRepo.removeFavoriteImage(event.imagePath);
      final favoritesPaths = await favoritesImageRepo
          .fetchFavoritedImagePaths();
      emit(FavoritesLoaded(favoritesPaths));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
