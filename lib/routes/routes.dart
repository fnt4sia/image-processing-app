import 'package:citra/view/view_edit.dart';
import 'package:citra/view/view_home.dart';
import 'package:citra/view/view_start.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const ViewStart(),
    ),
    GetPage(
      name: '/home',
      page: () => const ViewHome(),
    ),
    GetPage(
      name: '/edit',
      page: () => const ViewEdit(),
    ),
  ];
}
