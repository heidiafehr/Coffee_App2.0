import 'package:bloc/bloc.dart';
import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_events.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_states.dart';
import 'package:coffee_app_2/coffee_image_repo/rest_instance_call.dart';
import 'package:coffee_app_2/service_locator.dart';

class GenerateBloc extends Bloc<GenerateEvent, GenerateState> {
  GenerateBloc() : super(ImageLoading()) {
    on<LoadImage>(_fetchImage);
    on<ToggleFavoritesItem>(_toggleFavoriteImage);
  }

  RestApi api = getIt<RestApi>();
  FavoriteCoffeeImageRepo favoriteImageRepo = getIt<FavoriteCoffeeImageRepo>();

  Future<void> _fetchImage(LoadImage event, Emitter<GenerateState> emit) async {
    try {
      const maxRetries = 5;
      var attempts = 0;

      final favoritesUrls = await favoriteImageRepo
          .fetchFavoritedImageCatalog();

      while (attempts < maxRetries) {
        final image = await api.fetchImage();
        final imageUrl = image.file;

        // check to see if the image is already favorited
        if (!favoritesUrls.contains(imageUrl)) {
          emit(ImageLoaded(imageUrl, isFavorited: false));
          return;
        }
        attempts++;
      }

      // If we didn’t find any new image after retries
      emit(ImageError("Couldn't find a new image after $maxRetries tries."));
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _toggleFavoriteImage(
    ToggleFavoritesItem event,
    Emitter<GenerateState> emit,
  ) async {
    try {
      if(event.isFavorited){
        await favoriteImageRepo.addFavoriteImage(event.imageUrl);
      } else {
        await favoriteImageRepo.removeFavoriteImage(event.imageUrl);
      }
      emit(ImageLoaded(event.imageUrl, isFavorited: event.isFavorited));
    } catch (e) {
      emit(ImageError('Failure to update images in favorite: $e'));
    }
  }
}
