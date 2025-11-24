import 'package:flutter/material.dart';

class GlobalRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _logRoute(Route<dynamic> route, String action) {
    if (route is PageRoute) {
      final pageName = route.settings.name ?? route.runtimeType.toString();

      // 获取页面类型
      final pageType = _getPageType(route);

      // 获取文件路径（通过堆栈跟踪）
      final filePath = _extractFilePath(StackTrace.current, pageType);

      print('🔄 $action Page: $pageName');
      print('📝 Page Type: $pageType');
      print('📁 File Path: $filePath');
      print('⏰ Time: ${DateTime.now()}');
      print('---');
    }
  }

  String _getPageType(PageRoute route) {
    try {
      // 尝试从路由的builder中获取页面类型
      if (route is MaterialPageRoute) {
        // 对于MaterialPageRoute，我们可以通过一些技巧获取页面类型
        final routeString = route.toString();
        final match = RegExp(r'<([^>]+)>').firstMatch(routeString);
        if (match != null) {
          return match.group(1)!;
        }
      }

      // 对于其他类型的路由，返回运行时类型
      return route.runtimeType.toString();
    } catch (e) {
      return 'Unknown';
    }
  }

  String _extractFilePath(StackTrace stackTrace, String pageType) {
    try {
      final lines = stackTrace.toString().split('\n');

      // 查找包含页面类型的堆栈行
      for (final line in lines) {
        if (line.contains('.dart') &&
            !line.contains('package:flutter') &&
            !line.contains('route_observer.dart')) {

          // 提取文件路径
          final pathMatch = RegExp(r'package:[^:]+\.dart').firstMatch(line);
          if (pathMatch != null) {
            return pathMatch.group(0)!;
          }

          // 或者提取文件路径的其他格式
          final fileMatch = RegExp(r'[^/]+\.[dart]+').firstMatch(line);
          if (fileMatch != null) {
            return fileMatch.group(0)!;
          }
        }
      }

      return 'Unknown';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute(route, 'PUSH');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRoute(route, 'POP');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logRoute(newRoute, 'REPLACE');
    }
  }
}