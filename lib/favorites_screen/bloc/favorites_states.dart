abstract class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  FavoritesLoaded(this.favoriteImagePaths);

  final List<String> favoriteImagePaths;
}

class FavoritesError extends FavoritesState {
  FavoritesError(this.errorMessage);

  final String errorMessage;
}
