abstract class GenerateEvent {}

class LoadImage extends GenerateEvent {}

class AddFavoriteImage extends GenerateEvent {
  AddFavoriteImage(this.imageUrl);

  final String imageUrl;
}