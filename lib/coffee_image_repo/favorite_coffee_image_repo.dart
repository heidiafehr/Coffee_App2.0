import 'dart:io';

import 'package:coffee_app_2/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCoffeeImageRepo {
  Future<List<String>> fetchFavoritedImageCatalog() async {
    final prefs = getIt<SharedPreferences>();

    try {
      final favoriteImageCatalog = prefs.getStringList('favoriteImageUrls');

      if (favoriteImageCatalog != null && favoriteImageCatalog.isNotEmpty) {
        return favoriteImageCatalog;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to retrieve favorite image catalog');
    }
  }

  Future<List<String>> fetchFavoritedImagePaths() async {
    final prefs = getIt<SharedPreferences>();

    try {
      final favoriteImagePaths = prefs.getStringList('favoriteImagePaths');
      if (favoriteImagePaths != null && favoriteImagePaths.isNotEmpty) {
        return favoriteImagePaths;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to retrieve favorite image catalog');
    }
  }

  Future<void> addFavoriteImage(String imageUrl) async {
    // retrieve shared preferences
    final prefs = getIt<SharedPreferences>();
    final favoriteImageCatalog = await fetchFavoritedImageCatalog();

    try {
      if (!favoriteImageCatalog.contains(imageUrl)) {
        // add image url to shared preferences
        favoriteImageCatalog.add(imageUrl);
        await prefs.setStringList('favoriteImageUrls', favoriteImageCatalog);

        // fetch image bytes
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode != 200) {
          throw Exception('Failed to download image');
        }

        final bytes = response.bodyBytes;
        // retrieve local documents dir
        final dir = await getApplicationDocumentsDirectory();

        // generate filename
        final fileName = imageUrl.split('/').last;
        final file = File('${dir.path}/$fileName');

        // save image bytes to file
        await file.writeAsBytes(bytes);

        // save paths in saved preferences
        final localPaths = await fetchFavoritedImagePaths();
        localPaths.add(file.path);
        await prefs.setStringList('favoriteImagePaths', localPaths);
      }
    } catch (e) {
      throw Exception('Failed to add image to favorites: $e');
    }
  }

  Future<void> removeFavoriteImage(String imageUrl) async {
    final prefs = getIt<SharedPreferences>();

    final favoriteImageCatalog = await fetchFavoritedImageCatalog();
    final favoriteImagePaths = await fetchFavoritedImagePaths();

    // retrieve local documents dir
    final dir = await getApplicationDocumentsDirectory();

    // generate filename
    final fileName = imageUrl.split('/').last;
    final filePath = '${dir.path}/$fileName';

    try {
      if (favoriteImagePaths.contains(filePath) &&
          favoriteImageCatalog.contains(imageUrl)) {
        favoriteImageCatalog.remove(imageUrl);
        favoriteImagePaths.remove(filePath);

        // update saved prefs
        await prefs.setStringList('favoriteImageUrls', favoriteImageCatalog);
        await prefs.setStringList('favoriteImagePaths', favoriteImagePaths);

        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } else {
        throw Exception('File does not exist, cannot delete');
      }
    } catch (e) {
      throw Exception('Failed to remove image to favorites: $e');
    }
  }
}
