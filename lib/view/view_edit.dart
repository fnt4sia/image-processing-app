import 'package:citra/controller/controller_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class ViewEdit extends StatelessWidget {
  const ViewEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerEdit controller = Get.put(ControllerEdit());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.goBackHome();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          controller.resetFilters();
                        },
                        child: const Icon(
                          Icons.restart_alt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "ea",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          controller.toggleVisibility();
                        },
                        onLongPressUp: () {
                          controller.toggleVisibility();
                        },
                        child: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          controller.saveImage();
                        },
                        child: const Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () {
                    if (controller.editedImage.value != null) {
                      final imageBytes = img.encodeJpg(
                          controller.isVisiblePrevious.value
                              ? controller.originalImage.value!
                              : controller.editedImage.value!);
                      return Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Image Loaded",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Obx(
              () => controller.currentType.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      width: double.infinity,
                      height: 175,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.currentType.value == "Rotasi"
                              ? Column(
                                  children: [
                                    Slider(
                                      value: controller.rotationAngle.value,
                                      min: 0,
                                      max: 360,
                                      divisions: 360,
                                      label:
                                          '${controller.rotationAngle.value.round()}°',
                                      onChanged: (double value) {
                                        controller.rotationAngle.value = value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applyRotation();
                                          },
                                          child: const Text("Apply Rotation"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Grayscale"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.applyGrayscale();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller.isGrayScale.value
                                              ? Colors.blue
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Turn On Grayscale",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.removeGrayscale();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !controller.isGrayScale.value
                                              ? Colors.blue
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Turn Off Grayscale",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Brightness"
                              ? Column(
                                  children: [
                                    Slider(
                                      value:
                                          controller.brightnessAdjustment.value,
                                      min: -1.0,
                                      max: 1.0,
                                      divisions: 200,
                                      onChanged: (double value) {
                                        controller.brightnessAdjustment.value =
                                            value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.adjustBrightness();
                                          },
                                          child: const Text("Apply Brightness"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "RGB"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.setRgb("RED");
                                          },
                                          child: customButton(
                                            "RED",
                                            isActive:
                                                controller.currentRgb.value ==
                                                    "RED",
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        InkWell(
                                          onTap: () {
                                            controller.setRgb("GREEN");
                                          },
                                          child: customButton(
                                            "GREEN",
                                            isActive:
                                                controller.currentRgb.value ==
                                                    "GREEN",
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        InkWell(
                                          onTap: () {
                                            controller.setRgb("BLUE");
                                          },
                                          child: customButton(
                                            "BLUE",
                                            isActive:
                                                controller.currentRgb.value ==
                                                    "BLUE",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value:
                                          controller.currentRgb.value == "RED"
                                              ? controller.redValue.value
                                              : controller.currentRgb.value ==
                                                      "GREEN"
                                                  ? controller.greenValue.value
                                                  : controller.blueValue.value,
                                      min: 0,
                                      max: 255,
                                      divisions: 255,
                                      onChanged: (double value) {
                                        if (controller.currentRgb.value ==
                                            "RED") {
                                          controller.redValue.value = value;
                                        } else if (controller
                                                .currentRgb.value ==
                                            "GREEN") {
                                          controller.greenValue.value = value;
                                        } else if (controller
                                                .currentRgb.value ==
                                            "BLUE") {
                                          controller.blueValue.value = value;
                                        }
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applyRgb();
                                          },
                                          child: const Text("Apply RGB"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Sepia"
                              ? Column(
                                  children: [
                                    Slider(
                                      value: controller.sepiaValue.value,
                                      min: 0,
                                      max: 2,
                                      divisions: 2,
                                      onChanged: (double value) {
                                        controller.sepiaValue.value = value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applySepia();
                                          },
                                          child: const Text("Apply Sepia"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Saturation"
                              ? Column(
                                  children: [
                                    Slider(
                                      value: controller.saturationValue.value,
                                      min: 0,
                                      max: 2,
                                      divisions: 2,
                                      onChanged: (double value) {
                                        controller.saturationValue.value =
                                            value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applySaturation();
                                          },
                                          child: const Text("Apply Saturation"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Crop"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.setSelectedCropPreset(
                                                "Square");
                                            controller.applyCrop();
                                          },
                                          child: smallCustomButton(
                                            "Square",
                                            isActive: controller
                                                    .selectedCropPreset.value ==
                                                "Square",
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () {
                                            controller.setSelectedCropPreset(
                                                "Portrait");
                                            controller.applyCrop();
                                          },
                                          child: smallCustomButton(
                                            "Portrait",
                                            isActive: controller
                                                    .selectedCropPreset.value ==
                                                "Portrait",
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () {
                                            controller.setSelectedCropPreset(
                                                "Landscape");
                                            controller.applyCrop();
                                          },
                                          child: smallCustomButton(
                                            "Landscape",
                                            isActive: controller
                                                    .selectedCropPreset.value ==
                                                "Landscape",
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .setSelectedCropPreset("Story");
                                            controller.applyCrop();
                                          },
                                          child: smallCustomButton(
                                            "Story",
                                            isActive: controller
                                                    .selectedCropPreset.value ==
                                                "Story",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.removeCrop();
                                      },
                                      child: const Text("Remove Crop"),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Resize"
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .setSelectedSizePreset("1 : 1");
                                            controller.applyResize();
                                          },
                                          child: customButton(
                                            "1 : 1",
                                            isActive: controller
                                                    .selectedSizePreset.value ==
                                                "1 : 1",
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .setSelectedSizePreset("4 : 5");
                                            controller.applyResize();
                                          },
                                          child: customButton(
                                            "4 : 5",
                                            isActive: controller
                                                    .selectedSizePreset.value ==
                                                "4 : 5",
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        InkWell(
                                          onTap: () {
                                            controller.setSelectedSizePreset(
                                                "9 : 16");
                                            controller.applyResize();
                                          },
                                          child: customButton(
                                            "9 : 16",
                                            isActive: controller
                                                    .selectedSizePreset.value ==
                                                "9 : 16",
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        InkWell(
                                          onTap: () {
                                            controller
                                                .setSelectedSizePreset("3 : 1");
                                            controller.applyResize();
                                          },
                                          child: customButton(
                                            "3 : 1",
                                            isActive: controller
                                                    .selectedSizePreset.value ==
                                                "3 : 1",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.removeResize();
                                      },
                                      child: const Text("Remove Resize"),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Vignette"
                              ? Column(
                                  children: [
                                    Slider(
                                      value: controller.vignetteValue.value,
                                      min: 0,
                                      max: 3,
                                      divisions: 100,
                                      onChanged: (double value) {
                                        controller.vignetteValue.value = value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applyVignette();
                                          },
                                          child: const Text("Apply Vignette"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Gamma"
                              ? Column(
                                  children: [
                                    Slider(
                                      value: controller.gammaValue.value,
                                      min: 0,
                                      max: 2,
                                      divisions: 100,
                                      onChanged: (double value) {
                                        controller.gammaValue.value = value;
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.applyGamma();
                                          },
                                          child: const Text("Apply Gamma"),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          controller.currentType.value == "Invert"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.applyInvert();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller.isInverted.value
                                              ? Colors.blue
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Turn On Invert",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.removeInvert();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !controller.isInverted.value
                                              ? Colors.blue
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "Turn Off Inverted",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
            ),
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.setEditType("Crop");
                      },
                      child: editCategory("Crop", "crop.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Resize");
                      },
                      child: editCategory("Resize", "resize.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Rotasi");
                      },
                      child: editCategory("Rotasi", "rotation.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Grayscale");
                      },
                      child: editCategory("Grayscale", "grayscale.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Brightness");
                      },
                      child: editCategory("Brightness", "brightness.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("RGB");
                      },
                      child: editCategory("RGB", "rgb.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Sepia");
                      },
                      child: editCategory("Sepia", "sepia.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Invert");
                      },
                      child: editCategory("Invert", "invert.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Vignette");
                      },
                      child: editCategory("Vignette", "vignette.png"),
                    ),
                    InkWell(
                      onTap: () {
                        controller.setEditType("Gamma");
                      },
                      child: editCategory("Gamma", "gamma.png"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editCategory(String title, String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          "assets/$image",
          width: 30,
          height: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget customButton(String title, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget smallCustomButton(String title, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
