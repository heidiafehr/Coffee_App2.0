import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_2/coffee_image_repo/coffee_image_class.dart';
import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/coffee_image_repo/rest_instance_call.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_events.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late MockRestApi api;
  late MockFavoriteCoffeeImageRepo favoriteImageRepo;

  setUp(() {
    api = MockRestApi();
    favoriteImageRepo = MockFavoriteCoffeeImageRepo();

    GetIt.instance
      ..registerSingleton<RestApi>(api)
      ..registerSingleton<FavoriteCoffeeImageRepo>(favoriteImageRepo);
  });

  tearDown(() {
    GetIt.instance
      ..unregister<RestApi>()
      ..unregister<FavoriteCoffeeImageRepo>();
  });

  group('Generate Bloc Test init', () {
    test('Initial State is loading', () async {
      final generateBloc = GenerateBloc();

      await pumpEventQueue();
      expect(generateBloc.state, isA<ImageLoading>());
    });
  });

  group('Load Coffee Image states', () {
    blocTest<GenerateBloc, GenerateState>(
      'if image is not in favorites, show that image',
      setUp: () {
        when(() => api.fetchImage()).thenAnswer(
          (_) =>
              Future.value(CoffeeImage(file: 'https://coffee.fake/test.jpg')),
        );
        when(
          () => favoriteImageRepo.fetchFavoritedImageCatalog(),
        ).thenAnswer((_) => Future.value([]));
      },
      act: (bloc) {
        bloc.add(LoadImage());
      },
      build: GenerateBloc.new,
      expect: () => [
        isA<ImageLoaded>().having(
          (state) => state.imageUrl,
          'image url should be coffee image url',
          'https://coffee.fake/test.jpg',
        ),
      ],
    );

    blocTest<GenerateBloc, GenerateState>(
      'if image api fails, show error state',
      setUp: () {
        when(() => api.fetchImage()).thenThrow(Error());
        when(
          () => favoriteImageRepo.fetchFavoritedImageCatalog(),
        ).thenThrow(Error());
      },
      act: (bloc) {
        bloc.add(LoadImage());
      },
      build: GenerateBloc.new,
      expect: () => [isA<ImageError>()],
    );
  });

  group('Image favorites is updated', () {
    blocTest<GenerateBloc, GenerateState>(
      'Adds image to favorites',
      setUp: () {
        when(
          () => favoriteImageRepo.addFavoriteImage(
            'https://coffee.fake/test.jpg',
          ),
        ).thenAnswer((_) => Future.value());
      },
      act: (bloc) {
        bloc.add(
          ToggleFavoritesItem(
            'https://coffee.fake/test.jpg',
            isFavorited: true,
          ),
        );
      },
      verify: (_) {
        verify(
          () => favoriteImageRepo.addFavoriteImage(
            'https://coffee.fake/test.jpg',
          ),
        ).called(1);
      },
      build: GenerateBloc.new,
      expect: () => [isA<ImageLoaded>()],
    );

    blocTest<GenerateBloc, GenerateState>(
      'Removes from favorites',
      setUp: () {
        when(
          () => favoriteImageRepo.removeFavoriteImage(
            'https://coffee.fake/test.jpg',
          ),
        ).thenAnswer((_) => Future.value());
      },
      act: (bloc) {
        bloc.add(
          ToggleFavoritesItem(
            'https://coffee.fake/test.jpg',
            isFavorited: false,
          ),
        );
      },
      verify: (_) {
        verify(
          () => favoriteImageRepo.removeFavoriteImage(
            'https://coffee.fake/test.jpg',
          ),
        ).called(1);
      },
      build: GenerateBloc.new,
      expect: () => [isA<ImageLoaded>()],
    );

    blocTest<GenerateBloc, GenerateState>(
      'Emits error state when API fails',
      setUp: () {
        when(
          () => favoriteImageRepo.addFavoriteImage(
            'https://coffee.fake/test.jpg',
          ),
        ).thenThrow(Error());
      },
      act: (bloc) {
        bloc.add(
          ToggleFavoritesItem(
            'https://coffee.fake/test.jpg',
            isFavorited: true,
          ),
        );
      },
      build: GenerateBloc.new,
      expect: () => [isA<ImageError>()],
    );
  });
}
