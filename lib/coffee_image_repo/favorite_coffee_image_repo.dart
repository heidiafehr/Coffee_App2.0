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

  Future<void> removeFavoriteImage(String imageIdentifier) async {
    final prefs = getIt<SharedPreferences>();

    final favoriteImageCatalog = await fetchFavoritedImageCatalog();
    final favoriteImagePaths = await fetchFavoritedImagePaths();

    // get just the filename
    final fileName = imageIdentifier.split('/').last;

    // find matching url and path
    final matchingUrl = favoriteImageCatalog.firstWhere(
      (url) => url.endsWith(fileName),
      orElse: () => '',
    );
    final matchingPath = favoriteImagePaths.firstWhere(
      (path) => path.endsWith(fileName),
      orElse: () => '',
    );

    if (matchingUrl.isNotEmpty && matchingPath.isNotEmpty) {
      try {
        // remove from prefs lists
        favoriteImageCatalog.remove(matchingUrl);
        favoriteImagePaths.remove(matchingPath);

        await prefs.setStringList('favoriteImageUrls', favoriteImageCatalog);
        await prefs.setStringList('favoriteImagePaths', favoriteImagePaths);

        final file = File(matchingPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        throw Exception('Failed to remove image to favorites: $e');
      }
    } else {
      throw Exception('File does not exist, cannot delete');
    }
  }
}
