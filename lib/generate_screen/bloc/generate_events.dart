abstract class GenerateEvent {}

class LoadImage extends GenerateEvent {}

class ToggleFavoritesItem extends GenerateEvent {
  ToggleFavoritesItem(this.imageUrl, {required this.isFavorited});

  final String imageUrl;
  final bool isFavorited;
}