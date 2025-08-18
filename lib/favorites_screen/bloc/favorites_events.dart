abstract class FavoritesEvent {}

class LoadFavoritesCatalog extends FavoritesEvent {}

class RemoveFavoritesImage extends FavoritesEvent {
  RemoveFavoritesImage(this.imagePath);

  final String imagePath;
}