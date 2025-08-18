import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_bloc.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_events.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late FavoriteCoffeeImageRepo favoriteCoffeeImageRepo;

  setUp(() {
    favoriteCoffeeImageRepo = MockFavoriteCoffeeImageRepo();

    GetIt.instance.registerSingleton<FavoriteCoffeeImageRepo>(
      favoriteCoffeeImageRepo,
    );
  });

  tearDown(() {
    GetIt.instance.unregister<FavoriteCoffeeImageRepo>();
  });

  group('Testing initial state', () {
    test('Initial state', () async {
      final bloc = FavoritesBloc();

      await pumpEventQueue();
      expect(bloc.state, isA<FavoritesLoading>());
    });
  });

  group('Load Favorites images', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'Successfully loaded favorites images',
      setUp: () {
        when(
          () => favoriteCoffeeImageRepo.fetchFavoritedImagePaths(),
        ).thenAnswer((_) => Future.value(['https://coffee.fake/test.jpg']));
      },
      build: FavoritesBloc.new,
      act: (bloc) {
        bloc.add(LoadFavoritesCatalog());
      },
      expect: () => [
        isA<FavoritesLoaded>().having(
          (state) => state.favoriteImagePaths,
          'Image paths are correct',
          ['https://coffee.fake/test.jpg'],
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'Failure loading favorites images',
      setUp: () {
        when(
          () => favoriteCoffeeImageRepo.fetchFavoritedImagePaths(),
        ).thenThrow(Error());
      },
      build: FavoritesBloc.new,
      act: (bloc) {
        bloc.add(LoadFavoritesCatalog());
      },
      expect: () => [isA<FavoritesError>()],
    );
  });

  group('Unfavoriting images', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'Successfully removed favorites image',
      setUp: () {
        when(
          () => favoriteCoffeeImageRepo.fetchFavoritedImagePaths(),
        ).thenAnswer((_) => Future.value(['test/directory/second_test.jpg']));
        when(
          () => favoriteCoffeeImageRepo.removeFavoriteImage(
            'test/directory/test.jpg',
          ),
        ).thenAnswer((_) => Future.value());
      },
      act: (bloc) {
        bloc.add(RemoveFavoritesImage('test/directory/test.jpg'));
      },
      build: FavoritesBloc.new,
      expect: () => {
        isA<FavoritesLoaded>().having(
          (state) => state.favoriteImagePaths,
          'Paths are correct',
          ['test/directory/second_test.jpg'],
        ),
      },
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'Failed state when removing image',
      setUp: () {
        when(
          () => favoriteCoffeeImageRepo.removeFavoriteImage(
            'test/directory/test.jpg',
          ),
        ).thenThrow(Error());
        when(
          () => favoriteCoffeeImageRepo.fetchFavoritedImageCatalog(),
        ).thenThrow(Error());
      },
      act: (bloc) {
        bloc.add(RemoveFavoritesImage('test/directory/test.jpg'));
      },
      build: FavoritesBloc.new,
      expect: () => [isA<FavoritesError>()],
    );
  });
}
