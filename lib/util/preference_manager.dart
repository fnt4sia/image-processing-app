import 'dart:convert';
import 'dart:io';
import 'package:citra/model/model_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String recentImageKey = 'recentImage';

  static Future<void> saveToLocalStorage(ModelImage newFile) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> recentImages = prefs.getStringList(recentImageKey) ?? [];

    recentImages.add(jsonEncode(newFile.jsonConverter()));
    await prefs.setStringList(recentImageKey, recentImages);
  }

  static Future<List<ModelImage>> getImageFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentImages = prefs.getStringList(recentImageKey) ?? [];

    List<ModelImage> validImages = [];
    List<String> updatedJsonList = [];

    for (String jsonStr in recentImages) {
      final ModelImage image = ModelImage.fromJson(jsonDecode(jsonStr));

      if (await File(image.path).exists()) {
        validImages.add(image);
        updatedJsonList.add(jsonStr);
      }
    }

    if (updatedJsonList.length != recentImages.length) {
      await prefs.setStringList(recentImageKey, updatedJsonList);
    }

    return validImages;
  }

  static Future<void> saveAllToLocalStorage({required List<ModelImage> listFiles}) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> recentImages = [];

    for (ModelImage image in listFiles) {
      recentImages.add(jsonEncode(image.jsonConverter()));
    }

    await prefs.setStringList(recentImageKey, recentImages);
  }
}
