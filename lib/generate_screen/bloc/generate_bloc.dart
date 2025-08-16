import 'package:bloc/bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_event.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_state.dart';
import 'package:coffee_app_2/random_image_repo/rest_instance_call.dart';

class GenerateBloc extends Bloc<GenerateEvent, GenerateState> {
  GenerateBloc() : super(ImageLoading()) {
    on<LoadImage>(_fetchImage);
  }

  RestApi api = RestApi();

  Future<void> _fetchImage(
    LoadImage event,
    Emitter<GenerateState> emit,
  ) async {
    try {
      final image = await api.fetchImage();
      final imageUrl = image.file;

      emit(ImageLoaded(imageUrl));

      // add checking if it is favorites here before loading
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }
}