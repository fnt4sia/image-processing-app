import 'dart:io';
import 'package:citra/model/model_image.dart';
import 'package:citra/util/preference_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class ControllerHome extends GetxController {
  Rx<File?> imageFile = Rx<File?>(null);
  Rx<List<ModelImage>> recentImages = Rx<List<ModelImage>>([]);

  @override
  void onInit() {
    super.onInit();
    PreferenceManager.getImageFromLocalStorage().then((value) {
      recentImages.value = value;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      Get.toNamed('/edit', arguments: pickedFile.path);
    } else {
      Get.snackbar("No Image Selected", "Please select an image to proceed.");
    }
  }

  void goToEdit() {
    Get.toNamed('/edit');
  }
}
