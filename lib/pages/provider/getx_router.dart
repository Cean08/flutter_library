// route_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_library/library/ui/tabbar_page.dart';
import 'package:flutter_library/pages/home/home_page.dart';
import 'package:flutter_library/pages/home/room_detail.dart';
import 'package:flutter_library/pages/login.dart';
import 'package:get/get.dart';

// 配置映射
abstract class GetxPath {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const  forgotPassword = '/forgot-password';
  static const about = '/about';
  static const privacyPolicy = '/privacy-policy';
  static const terms = '/terms';

  static const roomDetail = '/room_detail';
  static const provider = '/provider';
  static const repaint = '/repaint';
  static const screenutil = '/screenutil';
  static const  notFound = '/notfound';
}

/// 页面路由配置
/// 注释：定义所有页面的路由配置
final List<GetPage> _routes = [
  GetPage(
    name: GetxPath.home,
    page: () => TabBarPage(),
    transition: Transition.fade,
  ),
  GetPage(
    name: GetxPath.login,
    page: () => LoginPage(),
    transition: Transition.rightToLeft,
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: GetxPath.roomDetail,
    page: () => RoomDetail(roomId: "roomId"),
    transition: Transition.cupertino,
  ),
  GetPage(
    name: GetxPath.notFound,
    page: () => NotFoundPage(),
    transition: Transition.zoom,
  ),
  GetPage(
    name: GetxPath.about,
    page: () => GetxRouterDemo(),
    transition: Transition.upToDown,
  ),
];

/// 路由管理类 - 封装所有路由相关功能
/// ```
/// 方法	说明	使用场景
/// Get.to()          普通跳转	常规页面跳转
/// Get.toNamed()     命名路由跳转	推荐使用，便于维护
/// Get.off()         替换当前页面	登录后跳转主页
/// Get.offAll()      替换所有页面	退出登录，回到登录页
/// Get.back()        返回上一页	页面返回
/// Get.arguments     获取传递的参数	页面间数据传递
/// Get.parameters    获取路由参数	动态路由参数
/// Get.currentRoute  获取当前路由	路由监控
/// Get.previousRoute 获取之前路由	路由追踪
/// ```
class RouteManager {

  /// 路由观察器实例
  static final RouteObserver _routeObserver = RouteObserver();

  /// 获取路由观察器
  static List<GetObserver> get navigatorObservers => [_routeObserver];

  /// 初始化路由配置
  /// 注释：在 GetMaterialApp 中使用的配置
  static GetMaterialApp initApp() {
    return GetMaterialApp(
      title: 'App',
      initialRoute: GetxPath.home,
      getPages: _routes,
      navigatorObservers: navigatorObservers,
      unknownRoute: GetPage(
        name: GetxPath.notFound,
        page: () => NotFoundPage(),
      ),
      // 自定义404错误页面
      onUnknownRoute: (settings) {
        return GetPageRoute(
          settings: settings,
          page: () => NotFoundPage(),
        );
      },
    );
  }

  // ============ 路由跳转方法 ============

  /// 命名路由跳转
  /// 注释：跳转到新页面并添加到导航栈
  static Future<T?>? toNamed<T>(
      String routeName, {
        dynamic arguments,
        Map<String, String>? parameters,
        int? id,
        bool preventDuplicates = true,
      }) {
    _logRoute('跳转到: $routeName', arguments: arguments, parameters: parameters);
    return Get.toNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  /// 跳转并替换当前页面
  /// 注释：用新页面替换当前页面，当前页面从栈中移除
  static Future<T?>? offNamed<T>(
      String routeName, {
        dynamic arguments,
        Map<String, String>? parameters,
        int? id,
        bool preventDuplicates = true,
      }) {
    _logRoute('替换跳转到: $routeName', arguments: arguments, parameters: parameters);
    return Get.offNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters,
      id: id,
      preventDuplicates: preventDuplicates,
    );
  }

  /// 跳转并关闭之前所有页面
  /// 注释：清除导航栈中所有页面，新页面成为根页面
  static Future<T?>? offAllNamed<T>(
      String routeName, {
        dynamic arguments,
        Map<String, String>? parameters,
        int? id,
      }) {
    _logRoute('关闭所有跳转到: $routeName', arguments: arguments, parameters: parameters);
    return Get.offAllNamed<T>(
      routeName,
      arguments: arguments,
      parameters: parameters,
      id: id,
    );
  }

  /// 跳转并关闭直到指定页面
  /// 注释：关闭页面直到找到指定路由，然后跳转到新页面
  static Future<T?>? offNamedUntil<T>(
      String routeName,
      String untilRouteName, {
        dynamic arguments,
        Map<String, String>? parameters,
        int? id,
      }) {
    _logRoute('跳转到 $routeName 直到 $untilRouteName',
        arguments: arguments, parameters: parameters);
    return Get.offNamedUntil<T>(
      routeName,
          (route) => route.settings.name == untilRouteName,
      arguments: arguments,
      parameters: parameters,
      id: id,
    );
  }

  /// 返回上一页
  /// 注释：返回上一页并可传递返回数据
  static void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    _logRoute('返回页面，结果: $result');
    Get.back<T>(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id,
    );
  }

  /// 返回直到指定页面
  /// 注释：连续返回直到找到指定路由
  static void until(String routeName) {
    _logRoute('返回到: $routeName');
    Get.until((route) => route.settings.name == routeName);
  }

  // ============ 路由信息获取 ============

  /// 获取当前路由名称
  static String? get currentRoute => Get.currentRoute;

  /// 获取之前路由名称
  static String? get previousRoute => Get.previousRoute;

  /// 获取路由参数
  static Map<String, String?> get parameters => Get.parameters;

  /// 获取传递的参数
  static dynamic get arguments => Get.arguments;

  /// 获取路由堆栈
  static String get routeTree {
    final route = Get.routing;
    return '当前路由: ${route.current}, 之前路由: ${route.previous}';
  }

  /// 检查路由是否存在
  static bool hasRoute(String routeName) {
    return _routes.any((page) => page.name == routeName);
  }

  /// 检查是否在目标页面
  static bool isCurrent(String routeName) {
    return Get.routing.current == routeName;
  }

  /// 检查是否能返回
  static bool get canPop {
    // 如果当前路由不是首页，通常可以返回
    return Get.currentRoute != GetxPath.home;
  }

  // ============ 路由工具方法 ============

  /// 构建带参数的动态路由
  /// 注释：为动态路由构建完整的路径
  static String buildRouteWithParams(
      String baseRoute, {
        Map<String, dynamic>? params,
      }) {
    var route = baseRoute;

    if (params != null) {
      params.forEach((key, value) {
        route = route.replaceFirst(':$key', value.toString());
      });
    }

    return route;
  }

  /// 显示对话框
  static Future<T?>? showDialog<T>({
    Widget? title,
    Widget? content,
    bool barrierDismissible = true,
    Color? barrierColor,
    RouteSettings? routeSettings,
  }) {
    return Get.dialog<T>(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                title,
                const SizedBox(height: 16),
              ],
              if (content != null) content,
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => back(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => back(result: true),
                    child: const Text('确认'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
    );
  }

  /// 显示底部弹窗
  static Future<T?>? bottomSheet<T>(
      Widget widget, {
        Color? backgroundColor,
        double? elevation,
        ShapeBorder? shape,
        Clip? clipBehavior,
        Color? barrierColor,
        bool ignoreSafeArea = false,
        bool isScrollControlled = false,
        bool useRootNavigator = false,
        bool isDismissible = true,
        bool enableDrag = true,
      }) {
    return Get.bottomSheet<T>(
      widget,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      ignoreSafeArea: ignoreSafeArea,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  // ============ 私有方法 ============

  /// 路由跳转日志
  static void _logRoute(
      String message, {
        dynamic arguments,
        Map<String, String>? parameters,
      }) {
    debugPrint('🚀 [RouteManager] $message'
        '${arguments != null ? ' | 参数: $arguments' : ''}'
        '${parameters != null ? ' | 路由参数: $parameters' : ''}');
  }
}


// ============ 中间件/路由守卫 ============

/// 认证中间件
/// 注释：在路由跳转前执行检查，常用于权限验证
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // 这里可以检查用户认证状态
    //TODO: 替换为实际的认证检查
    final isAuthenticated = true;

    // 需要认证的页面列表, 需要有登录态的页面
    final protectedRoutes = [
      GetxPath.roomDetail,
      GetxPath.home,
    ];

    if (protectedRoutes.contains(route) && !isAuthenticated) {
      debugPrint('🔐 [AuthMiddleware] 未认证，重定向到登录页');
      return RouteSettings(name: GetxPath.login);
    }

    // 如果已登录且访问登录页，重定向到首页
    if (route == GetxPath.login && isAuthenticated) {
      debugPrint('🔐 [AuthMiddleware] 已登录，重定向到首页');
      return RouteSettings(name: GetxPath.home);
    }
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('📄 [AuthMiddleware] 页面调用: ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  void onPageDispose() {
    debugPrint('🗑️ [AuthMiddleware] 页面已销毁');
    super.onPageDispose();
  }
}

/// 日志中间件
/// 注释：记录路由跳转日志
class LoggingMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('📋 [LoggingMiddleware] 跳转到: ${page?.name}');
    return super.onPageCalled(page);
  }
}

// ============ 路由观察器 ============

/// 路由观察器
/// 注释：监听路由变化，用于埋点、日志等
class RouteObserver extends GetObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('➡️ [RouteObserver] 路由跳转: ${route.settings.name}');
    // 这里可以添加路由跳转统计
    _trackPageView(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('⬅️ [RouteObserver] 路由返回: ${route.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint('🔄 [RouteObserver] 路由替换: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('❌ [RouteObserver] 路由移除: ${route.settings.name}');
    super.didRemove(route, previousRoute);
  }

  /// 页面访问统计
  void _trackPageView(String? routeName) {
    if (routeName != null) {
      // 这里可以集成统计分析SDK
      // Analytics.trackPageView(routeName);
    }
  }
}

// 404page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('页面未找到')),
      body: Center(
        child: Column(
          children: [
            Text('404 - 页面不存在'),
            ElevatedButton(
              onPressed: () => RouteManager.offAllNamed(GetxPath.home),
              child: Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}



// ============ 页面组件定义 ============


/// 示例页面组件
class GetxRouterDemo extends StatelessWidget {
  const GetxRouterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Getx 路由示例')),
      body: Center(
        child: Column(
          children: [
            // 使用封装的路由方法
            ElevatedButton(
              onPressed: () => RouteManager.toNamed(GetxPath.roomDetail),
              child: Text('跳转到详情页'),
            ),
            ElevatedButton(
              onPressed: () => RouteManager.toNamed(
                GetxPath.terms,
                arguments: {'from': 'home'},
              ),
              child: Text('跳转到个人资料'),
            ),
            ElevatedButton(
              onPressed: () => RouteManager.toNamed(
                RouteManager.buildRouteWithParams(
                  GetxPath.roomDetail,
                  params: {'id': '123'},
                ),
              ),
              child: Text('跳转到用户详情'),
            ),
            ElevatedButton(
              onPressed: () => RouteManager.offAllNamed(GetxPath.login),
              child: Text('退出登录'),
            ),
          ],
        ),
      ),
    );
  }
}


// ============ 使用示例 ============

/// 应用入口
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return RouteManager.initApp();
//   }
// }

/// 使用示例
class RouteUsageExample extends StatelessWidget {
  const RouteUsageExample({super.key});

  void demonstrateRoutes() {
    // 1. 普通跳转
    RouteManager.toNamed(GetxPath.roomDetail);

    // 2. 带参数跳转
    RouteManager.toNamed(
      GetxPath.roomDetail,
      arguments: {'id': 123, 'title': '商品详情'},
    );

    // 3. 动态路由跳转
    RouteManager.toNamed(
      RouteManager.buildRouteWithParams(
        GetxPath.roomDetail!,
        params: {'id': '456'},
      ),
    );

    // 4. 替换当前页面
    RouteManager.offNamed(GetxPath.home);

    // 5. 关闭所有页面跳转
    RouteManager.offAllNamed(GetxPath.login);

    // 6. 返回并传递结果
    RouteManager.back(result: {'success': true});

    // 7. 获取路由信息
    debugPrint('当前路由: ${RouteManager.currentRoute}');
    debugPrint('路由参数: ${RouteManager.parameters}');

    // 8. 检查路由
    if (RouteManager.hasRoute(GetxPath.roomDetail)) {
      debugPrint('路由存在');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 示例组件
  }
}