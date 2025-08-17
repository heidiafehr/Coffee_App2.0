import 'package:coffee_app_2/coffee_image_repo/favorite_coffee_image_repo.dart';
import 'package:coffee_app_2/coffee_image_repo/rest_instance_call.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt
    ..registerSingleton<FavoriteCoffeeImageRepo>(FavoriteCoffeeImageRepo())
    ..registerSingleton<RestApi>(RestApi())
    ..registerSingletonAsync(SharedPreferences.getInstance);
}
