import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/application.dart';

import 'library/log/log.dart';

void main() {
  // 配置日志
  Log.initialize(
    level: kDebugMode ? LogLevel.trace : LogLevel.warning,
    enableInProduction: false, // 生产环境关闭详细日志
  );
  runApp(Application());
}