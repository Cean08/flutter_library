import 'package:flutter/material.dart';
import 'package:flutter_library/pages/provider/provider_demo.dart';
import 'package:go_router/go_router.dart';
import 'ui/tabbar_page.dart';
import '../pages/home/room_detail.dart';
import '../pages/login.dart';
import '../pages/register.dart';

// 配置映射
abstract class PagePath {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const roomDetail = '/room_detail';
  static const provider = '/provider';
}

// 定义路由表和extra参数
_routes() {
  return {
    PagePath.home: (context, state) => TabBarPage(index: 0),
    PagePath.login: (context, state) => LoginPage(),
    PagePath.register: (context, state) => RegisterPage(),
    PagePath.roomDetail: (context, state) => RoomDetail(roomId: state.extra),
    PagePath.provider: (context, state) => ProviderDemo(),
    // PagePath.webview: (context, state) => WebViewPage(
    //   url: state.extra,
    //   title: AppRouter.getParam(context, 'title'),
    // ),

    // PagePath.home: (context, state) => TabBarPage(index: AppRouter.getParam(context, 'index') ?? 0),

    // '/detail/:id': (context, state) => DetailPage(
    //   id: state.pathParameters['id']!,
    //   // 直接使用 extra 获取复杂对象
    //   product: state.extra is Product ? state.extra as Product : null,
    // ),

    // '/profile': (context, state) => ProfilePage(user: state.extra as User?),
  };
}

// 路由工具类封装
class AppRouter {
  static late GoRouter _router;
  static final Map<String, Widget Function(BuildContext, GoRouterState)>
  _routeMap = {};

  // 初始化路由
  static void init({
    Widget Function(BuildContext, GoRouterState)? errorPage,
    String? Function(BuildContext, GoRouterState)? redirect,
  }) {
    _routeMap.addAll(_routes());

    _router = GoRouter(
      initialLocation: PagePath.home,
      routes: [
        for (final route in _routeMap.entries)
          GoRoute(path: route.key, builder: route.value),
      ],
      errorBuilder:
          errorPage ?? (context, state) => DefaultPage404(state: state),
      redirect: redirect,
    );
  }

  // 获取全局路由实例
  static GoRouter get router => _router;

  // 导航方法, 使用 extra 参数传递复杂对象
  static void go(String path, {Map<String, dynamic>? params, Object? extra}) {
    _navigate(path, params: params, extra: extra, isPush: false);
  }

  static Future<T?> push<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? extra,
  }) {
    return _navigate(path, params: params, extra: extra, isPush: true)
        as Future<T?>;
  }

  // 替换当前路由
  static Future<T?> pushReplacement<T>(
    String path, {
    Map<String, dynamic>? params,
    Object? extra,
  }) {
    return _navigate(path, params: params, extra: extra, isReplace: true)
        as Future<T?>;
  }

  static dynamic _navigate(
    String path, {
    Map<String, dynamic>? params,
    Object? extra,
    bool isPush = false,
    bool isReplace = false,
  }) {
    // 检测路径是否在map中，输出日志
    if (!_routeMap.containsKey(path)) {
      _logError('Route "$path" not registered');
      // 继续执行，让go_router map 路径去判断
      // return isPush ? Future.value(null) : null;
    }

    final uri = Uri(path: path, queryParameters: _convertParams(params));
    final location = uri.toString();

    if (isPush) {
      return _router.push(location, extra: extra);
    } else if (isReplace) {
      return _router.pushReplacement(location, extra: extra);
    } else {
      _router.go(location, extra: extra);
      return null;
    }
  }

  // 带结果返回的 pop 方法
  static void pop<T>([T? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    } else {
      _logError('can not pop');
    }
  }

  // 回到根页面
  static void popToRoot({int index = 0}) {
    go(PagePath.home, params: {"index": index});
  }

  // 参数转换
  static Map<String, String>? _convertParams(Map<String, dynamic>? params) {
    return params?.map((key, value) => MapEntry(key, value.toString()));
  }

  // 错误处理
  static void _logError(String message) {
    debugPrint('Router Error: $message');
    // 可以添加全局错误通知
  }

  // 获取参数：优先使用 extra，其次是路径/查询参数
  static Map<String, dynamic> getParams(BuildContext context) {
    final state = GoRouterState.of(context);
    final Map<String, dynamic> result = {};

    // 1. 添加路径参数
    result.addAll(state.pathParameters);

    // 2. 添加查询参数
    result.addAll(state.uri.queryParameters);

    // 3. 添加 extra 中的参数（如果 extra 是 Map）
    if (state.extra is Map<String, dynamic>) {
      result.addAll(state.extra as Map<String, dynamic>);
    }

    return result;
  }

  // 获取特定参数（类型安全）
  static T? getParam<T>(BuildContext context, String key, {T? defaultValue}) {
    final params = getParams(context);
    final value = params[key];
    if (value == null) return defaultValue;

    // 如果已经是目标类型，直接返回
    if (value is T) {
      return value;
    }

    // 需要转换类型
    return _parseValue<T>(value.toString(), defaultValue: defaultValue);
  }

  // 类型安全的值解析
  static T? _parseValue<T>(String value, {T? defaultValue}) {
    try {
      if (T == int) {
        return int.parse(value) as T;
      } else if (T == double) {
        return double.parse(value) as T;
      } else if (T == bool) {
        return (value.toLowerCase() == 'true') as T;
      } else if (T == String) {
        return value as T;
      }
    } catch (e) {
      debugPrint('Param parse error: $e');
    }
    return defaultValue;
  }

  // 直接获取 extra 对象
  static T? getExtra<T>(BuildContext context) {
    final state = GoRouterState.of(context);
    if (state.extra is T) {
      return state.extra as T;
    }
    return null;
  }
}

class DefaultPage404 extends StatelessWidget {
  final GoRouterState state;

  const DefaultPage404({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.lightBlue, title: Text("404")),
      body: Center(child: Text('Route not found: ${state.matchedLocation}')),
    );
  }
}

// 初始化路由和配置路由
// Widget build(BuildContext context) {
//     AppRouter.init();
//     return MaterialApp.router(
//       routerConfig: AppRouter.router,
//     );
//   }

// 传递参数
// PagePath.roomDetail: (context, state) => RoomDetail(roomId: state.extra),
// PagePath.webview: (context, state) => WebViewPage(
//   url: state.extra,
//   title: AppRouter.getParam(context, 'title'),
// ),

// PagePath.home: (context, state) => TabBarPage(index: AppRouter.getParam(context, 'index') ?? 0),

// '/detail/:id': (context, state) => DetailPage(
//   id: state.pathParameters['id']!,
//   // 直接使用 extra 获取复杂对象
//   product: state.extra is Product ? state.extra as Product : null,
// ),

// '/profile': (context, state) => ProfilePage(user: state.extra as User?),

// 获取参数
// final userId = AppRouter.getParam<String>(context, 'id');
// final isAdmin = AppRouter.getParam<bool>(context, 'isAdmin', defaultValue: false);
// final userExtra = AppRouter.getExtra<User>(context);

/* 直接通过 state 获取 extra
   GoRouterState.of(context).extra;
   映射页面直接获取 HomeDetailPage(state.extra),
 */

/* pop回传参数
 final result = await AppRouter.push(PagePath.detail)
 AppRouter.pop(result);
 */
