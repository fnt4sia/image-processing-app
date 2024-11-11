import 'dart:io';

import 'package:citra/controller/controller_home.dart';
import 'package:citra/model/model_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewHome extends StatelessWidget {
  const ViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerHome controller = Get.put(ControllerHome());

    return Scaffold(
      backgroundColor: const Color(0xFFF0DAD1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                const Text(
                  "Recent Edit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Wrap(
                    spacing: 16.0,
                    runSpacing: 12.0,
                    alignment: WrapAlignment.center,
                    children: [
                      ...controller.recentImages.value.map((image) {
                        return recentEditContainer(
                          () {
                            Get.toNamed('/edit', arguments: image);
                          },
                          image,
                        );
                      }),
                      InkWell(
                        onTap: () async {
                          await controller.pickImage();
                        },
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              "+",
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recentEditContainer(void Function() onTap, ModelImage image) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
