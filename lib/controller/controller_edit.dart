import 'dart:io';
import 'package:citra/controller/controller_home.dart';
import 'package:citra/model/model_image.dart';
import 'package:citra/util/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ControllerEdit extends GetxController {
  final RxBool isVisiblePrevious = false.obs;
  final RxString currentType = ''.obs;
  final RxList<String> activeFilters = <String>[].obs;
  Rx<img.Image?> editedImage = Rx<img.Image?>(null);
  Rx<img.Image?> originalImage = Rx<img.Image?>(null);
  final RxBool isGrayScale = false.obs;
  final RxDouble rotationAngle = 0.0.obs;
  final RxDouble brightnessAdjustment = 0.0.obs;

  final RxString currentRgb = "RED".obs;
  final RxDouble redValue = 128.0.obs;
  final RxDouble greenValue = 128.0.obs;
  final RxDouble blueValue = 128.0.obs;

  final RxDouble sepiaValue = 0.0.obs;

  final RxDouble saturationValue = 1.0.obs;

  final RxString selectedSizePreset = "".obs;
  final RxString selectedCropPreset = "".obs;

  late String imagePath;
  ModelImage? imageModel;

  static const Map<String, Map<String, int>> resizePresets = {
    '1 : 1': {'width': 1080, 'height': 1080},
    '4 : 5': {'width': 1080, 'height': 1350},
    '9 : 16': {'width': 1080, 'height': 1920},
    '3 : 1': {'width': 1500, 'height': 500},
  };

  static const Map<String, double> cropPresets = {
    'Square': 1,
    'Portrait': 0.8,
    'Landscape': 1.91,
    'Story': 0.5625,
  };

  void setSelectedSizePreset(String sizePreset) {
    selectedSizePreset.value = sizePreset;
  }

  void setSelectedCropPreset(String cropPreset) {
    selectedCropPreset.value = cropPreset;
  }

  void setRgb(String rgb) {
    currentRgb.value = rgb;
  }

  void setEditType(String type) {
    currentType.value = type;
  }

  void goBackHome() {
    Get.delete<ControllerHome>();
    Get.offAllNamed('/home');
  }

  void toggleVisibility() {
    isVisiblePrevious.value = !isVisiblePrevious.value;
  }

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is String) {
      imagePath = arguments;
      loadImage(imagePath);
    } else if (arguments is ModelImage) {
      imageModel = arguments;
      imagePath = arguments.path;
      applySavedFilters();
      loadImage(imageModel!.path);
    }
  }

  void loadImage(String path) {
    final bytes = File(path).readAsBytesSync();
    originalImage.value = img.decodeImage(bytes);
    editedImage.value = img.decodeImage(bytes);
  }

  void applySavedFilters() {
    if (imageModel != null) {
      activeFilters.value = imageModel!.activeFilters;
      isGrayScale.value = imageModel!.grayScale;
      rotationAngle.value = imageModel!.rotation;
      brightnessAdjustment.value = imageModel!.brightness;
      redValue.value = imageModel!.red;
      greenValue.value = imageModel!.green;
      blueValue.value = imageModel!.blue;
      sepiaValue.value = imageModel!.sepia;
      saturationValue.value = imageModel!.saturation;
      selectedSizePreset.value = imageModel!.size;
      selectedCropPreset.value = imageModel!.crop;
    }
  }

  void applyRotation() {
    rotationAngle.value = rotationAngle.value;
    if (!activeFilters.contains('rotate')) {
      activeFilters.add('rotate');
    }
    applyFilters();
  }

  void applyGrayscale() {
    if (!isGrayScale.value) {
      isGrayScale.value = true;
      if (!activeFilters.contains('grayscale')) {
        activeFilters.add('grayscale');
      }
      applyFilters();
    }
  }

  void removeGrayscale() {
    if (isGrayScale.value) {
      isGrayScale.value = false;
      activeFilters.remove('grayscale');
      applyFilters();
    }
  }

  void adjustBrightness() {
    if (!activeFilters.contains('brightness')) {
      activeFilters.add('brightness');
    }
    applyFilters();
  }

  void applyRgb() {
    if (!activeFilters.contains('rgb')) {
      activeFilters.add('rgb');
    }
    applyFilters();
  }

  void applySepia() {
    if (!activeFilters.contains('sepia')) {
      activeFilters.add('sepia');
    }
    applyFilters();
  }

  void applySaturation() {
    if (!activeFilters.contains('saturation')) {
      activeFilters.add('saturation');
    }
    applyFilters();
  }

  void applyResize() {
    if (selectedSizePreset.isNotEmpty) {
      if (!activeFilters.contains('resize')) {
        activeFilters.add('resize');
      }
      applyFilters();
    }
  }

  void applyCrop() {
    if (selectedCropPreset.isNotEmpty) {
      if (!activeFilters.contains('crop')) {
        activeFilters.add('crop');
      }
      applyFilters();
    }
  }

  void applyFilters() {
    if (originalImage.value != null) {
      img.Image tempImage = img.copyCrop(
        originalImage.value!,
        x: 0,
        y: 0,
        width: originalImage.value!.width,
        height: originalImage.value!.height,
      );
      for (String filter in activeFilters) {
        switch (filter) {
          case 'grayscale':
            tempImage = img.grayscale(tempImage);
            break;
          case 'rotate':
            tempImage = img.copyRotate(tempImage, angle: rotationAngle.value);
            break;
          case 'brightness':
            tempImage = img.adjustColor(tempImage,
                brightness: 1.0 + brightnessAdjustment.value);
            break;
          case 'rgb':
            tempImage = adjustRGB(tempImage);
            break;
          case 'sepia':
            tempImage = img.sepia(tempImage, amount: sepiaValue.value.toInt());
            break;
          case 'saturation':
            tempImage =
                img.adjustColor(tempImage, saturation: saturationValue.value);
            break;
          case 'resize':
            tempImage = resizeImage(tempImage);
            break;
          case 'crop':
            tempImage = cropImage(tempImage);
            break;
        }
      }
      editedImage.value = tempImage;
      update();
    }
  }

  void resetFilters() {
    if (imageModel == null) {
      activeFilters.clear();
      isGrayScale.value = false;
      rotationAngle.value = 0.0;
      brightnessAdjustment.value = 0.0;
      redValue.value = 128.0;
      greenValue.value = 128.0;
      blueValue.value = 128.0;
      sepiaValue.value = 0.0;
      saturationValue.value = 1.0;
      selectedSizePreset.value = "";
      selectedCropPreset.value = "";
    } else {
      applySavedFilters();
    }

    applyFilters();
  }

  img.Image adjustRGB(img.Image src) {
    final pixels = src.getBytes();
    const bytesPerPixel = 3;
    final width = src.width;
    final height = src.height;

    final redAdjustment = (redValue.value - 128) / 2;
    final greenAdjustment = (greenValue.value - 128) / 2;
    final blueAdjustment = (blueValue.value - 128) / 2;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x) * bytesPerPixel;

        if (index + 3 >= pixels.length) continue;

        pixels[index] = (pixels[index] + redAdjustment).clamp(0, 255).toInt();
        pixels[index + 1] =
            (pixels[index + 1] + greenAdjustment).clamp(0, 255).toInt();
        pixels[index + 2] =
            (pixels[index + 2] + blueAdjustment).clamp(0, 255).toInt();
      }
    }
    return src;
  }

  img.Image resizeImage(img.Image src) {
    final preset = resizePresets[selectedSizePreset.value];
    return img.copyResize(
      src,
      width: preset!['width'],
      height: preset['height'],
      maintainAspect: true,
    );
  }

  img.Image cropImage(img.Image src) {
    final ratio = cropPresets[selectedCropPreset.value]!;
    final currentRatio = src.width / src.height;

    int cropWidth = src.width;
    int cropHeight = src.height;

    if (currentRatio > ratio) {
      cropWidth = (src.height * ratio).round();
    } else {
      cropHeight = (src.width / ratio).round();
    }

    final x = ((src.width - cropWidth) / 2).round();
    final y = ((src.height - cropHeight) / 2).round();

    return img.copyCrop(
      src,
      x: x,
      y: y,
      width: cropWidth,
      height: cropHeight,
    );
  }

  Future<void> saveImage() async {
    if (editedImage.value == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/edited_image_$timestamp.jpg';

      final bytes = img.encodeJpg(editedImage.value!);
      await File(filePath).writeAsBytes(bytes);

      await Gal.putImage(filePath);

      await PreferenceManager.saveToLocalStorage(
        ModelImage(
          path: filePath,
          brightness: brightnessAdjustment.value,
          red: redValue.value,
          green: greenValue.value,
          blue: blueValue.value,
          activeFilters: activeFilters,
          grayScale: isGrayScale.value,
          rotation: rotationAngle.value,
          sepia: sepiaValue.value,
          saturation: saturationValue.value,
          size: selectedSizePreset.value,
          crop: selectedCropPreset.value,
        ),
      );

      Get.delete<ControllerHome>();
      Get.offAllNamed('/home');
      Get.snackbar(
        'Success',
        'Image saved to gallery',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white.withAlpha(128),
      );
    }
  }
}
