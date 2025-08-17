import 'package:bloc/bloc.dart';
import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_event.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_state.dart';
import 'package:coffee_app_2/coffee_image_repo/rest_instance_call.dart';
import 'package:coffee_app_2/service_locator.dart';

class GenerateBloc extends Bloc<GenerateEvent, GenerateState> {
  GenerateBloc() : super(ImageLoading()) {
    on<LoadImage>(_fetchImage);
    on<AddFavoriteImage>(_addFavoriteImage);
  }

  RestApi api = getIt<RestApi>();
  FavoriteCoffeeImageRepo favoriteImageRepo = getIt<FavoriteCoffeeImageRepo>();

  Future<void> _fetchImage(
    LoadImage event,
    Emitter<GenerateState> emit,
  ) async {
    try {
      final image = await api.fetchImage();
      final imageUrl = image.file;

      emit(ImageLoaded(imageUrl, isFavorited: false));

      // add checking if it is favorites here before loading
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<void> _addFavoriteImage(
    AddFavoriteImage event,
    Emitter<GenerateState> emit,
  ) async {
    try {
      await favoriteImageRepo.addFavoriteImage(event.imageUrl);
      emit(ImageLoaded(event.imageUrl, isFavorited: true));
    } catch (e) {
      emit(ImageError('Failure to add image to favorite: $e'));
    }
  }
}