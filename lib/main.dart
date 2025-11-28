import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/application.dart';
import 'package:flutter_library/pages/user_manager.dart';

import 'library/log/log.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 UserManager
  await UserManager().initialize();
  // 配置日志
  Log.initialize(
    level: kDebugMode ? LogLevel.trace : LogLevel.warning,
    enableInProduction: false, // 生产环境关闭详细日志
  );
  runApp(Application());
}