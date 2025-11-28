import 'package:flutter/material.dart';
import 'package:flutter_library/pages/provider/getx_router.dart';
import 'package:get/get.dart';
import 'library/router/app_router.dart';
import 'library/ui/tabbar_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    // return RouteManager.initApp();
    AppRouter.init();
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // 主色调
        primaryColor: Colors.green,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
          ),
          bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}

/*
class Application extends StatelessWidget {
  Application({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    AppRouter.init();
    return GetMaterialApp(
      title: 'GetX 状态管理示例',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark: ThemeMode.light,
      home: TabBarPage(index: 0),
    );
  }
}

// 主题控制器
class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? ThemeData.dark(): ThemeData.light());
  }
}

 */
