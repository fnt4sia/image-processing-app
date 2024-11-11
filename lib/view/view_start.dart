import 'package:citra/controller/controller_start.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerStart controller = Get.put(ControllerStart());

    return Scaffold(
      backgroundColor: const Color(0xFFF0DAD1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  const Text(
                    'Apa Gitu Namanya',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'An Image Processing\nApplication',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      controller.goToHome();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 99, 183, 175),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Let's Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 99, 183, 175),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Fitra Ramadhan S 123220127 \n Rafli Kavarera Iskandar 123210131',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
