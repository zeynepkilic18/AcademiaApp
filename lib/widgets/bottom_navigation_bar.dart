import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:schoolprogram/login.dart';
import 'package:schoolprogram/student.dart';
import 'package:schoolprogram/teacher.dart';
import 'package:get/get.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Login"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Teacher"),
            NavigationDestination(
                icon: Icon(Iconsax.personalcard), label: "Student"),
          ],
        ),
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Login(), // 0. index: Giriş sayfası
    const Teacher(), // 1. index: Hoca sayfası
    const Student(), // 2. index: Öğrenci sayfası
  ];
}
