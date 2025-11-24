import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 日志级别
enum LogLevel {
  trace(0),
  debug(1),
  info(2),
  warning(3),
  error(4),
  fatal(5),
  off(6);

  const LogLevel(this.value);
  final int value;
}

/// 全局日志工具类
class Log {
  static late Logger _logger;
  static late LogLevel _currentLevel;
  static bool _isInitialized = false;

  // 定义自己的颜色和表情映射
  static final Map<Level, AnsiColor> _levelColors = {
    Level.trace: AnsiColor.fg(90), // 灰色
    Level.debug: AnsiColor.fg(34), // 蓝色
    Level.info: AnsiColor.fg(32),  // 绿色
    Level.warning: AnsiColor.fg(33), // 黄色
    Level.error: AnsiColor.fg(31), // 红色
    Level.fatal: AnsiColor.fg(35), // 紫色
  };

  static final Map<Level, String> _levelEmojis = {
    Level.trace: '🔍',
    Level.debug: '🐛',
    Level.info: '💚',
    Level.warning: '⚠️',
    Level.error: '❌',
    Level.fatal: '💀',
  };

  /// 初始化日志配置
  static void initialize({
    LogLevel level = LogLevel.debug,
    bool enableInProduction = false,
  }) {
    if (_isInitialized) return;

    _currentLevel = level;

    if (kReleaseMode && !enableInProduction) {
      _currentLevel = LogLevel.warning;
    }

    _logger = Logger(
      filter: _CustomLogFilter(),
      printer: _CustomLogPrinter(
        showTime: kDebugMode,
        showEmojis: kDebugMode,
        colors: kDebugMode,
        methodCount: kDebugMode ? 2 : 0,
        errorMethodCount: kDebugMode ? 8 : 0,
      ),
      output: _CustomLogOutput(),
    );

    _isInitialized = true;

    i('Logger initialized', tag: 'Logger');
    i('Environment: ${kReleaseMode ? 'Production' : 'Debug'}', tag: 'Logger');
    i('Log Level: ${_currentLevel.name}', tag: 'Logger');
  }

  /// 设置日志级别
  static void setLevel(LogLevel level) {
    _currentLevel = level;
    i('Log level changed to: ${level.name}', tag: 'Logger');
  }

  /// 跟踪日志
  static void t(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.trace, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// 调试日志
  static void d(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// 信息日志
  static void i(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.info, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// 警告日志
  static void w(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// 错误日志
  static void e(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// 致命错误日志
  static void f(dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log(Level.fatal, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// JSON 格式美化输出
  static void json(String jsonString, {String? tag}) {
    if (!_shouldLog(Level.trace)) return;

    try {
      final prettyJson = _formatJson(jsonString);
      _log(Level.trace, 'JSON:\n$prettyJson', tag: tag ?? 'JSON');
    } catch (err) {
      e('Invalid JSON format', tag: tag ?? 'JSON', error: err);
    }
  }

  /// 网络请求日志
  static void network(String url, {String method = 'GET', dynamic data, int? statusCode, String? tag}) {
    if (!_shouldLog(Level.info)) return;

    final message = StringBuffer();
    message.write('$method $url');
    if (statusCode != null) {
      message.write(' → $statusCode');
    }
    if (data != null) {
      message.write('\nData: $data');
    }

    _log(Level.info, message.toString(), tag: tag ?? 'NETWORK');
  }

  /// 性能日志
  static void performance(String operation, Duration duration, {String? tag}) {
    if (!_shouldLog(Level.debug)) return;

    final message = '$operation took ${duration.inMilliseconds}ms';
    if (duration.inMilliseconds > 1000) {
      w(message, tag: tag ?? 'PERFORMANCE');
    } else {
      i(message, tag: tag ?? 'PERFORMANCE');
    }
  }

  /// 记录方法进入和退出
  static T trackMethod<T>(String methodName, T Function() function, {String? tag}) {
    if (!_shouldLog(Level.trace)) return function();

    final stopwatch = Stopwatch()..start();
    t('→ $methodName started', tag: tag ?? 'METHOD');

    try {
      final result = function();
      t('← $methodName completed in ${stopwatch.elapsedMilliseconds}ms',
          tag: tag ?? 'METHOD');
      return result;
    } catch (err, stackTrace) {
      e('← $methodName failed after ${stopwatch.elapsedMilliseconds}ms',
          tag: tag ?? 'METHOD', error: err, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 异步方法跟踪
  static Future<T> trackAsyncMethod<T>(String methodName, Future<T> Function() function, {String? tag}) async {
    if (!_shouldLog(Level.trace)) return function();

    final stopwatch = Stopwatch()..start();
    t('→ $methodName started', tag: tag ?? 'ASYNC_METHOD');

    try {
      final result = await function();
      t('← $methodName completed in ${stopwatch.elapsedMilliseconds}ms',
          tag: tag ?? 'ASYNC_METHOD');
      return result;
    } catch (err, stackTrace) {
      e('← $methodName failed after ${stopwatch.elapsedMilliseconds}ms',
          tag: tag ?? 'ASYNC_METHOD', error: err, stackTrace: stackTrace);
      rethrow;
    }
  }

  // 私有方法
  static void _log(Level level, dynamic message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (!_isInitialized) {
      initialize();
    }

    if (!_shouldLog(level)) return;

    final logMessage = tag != null ? '[$tag] $message' : message.toString();

    _logger.log(level, logMessage, error: error, stackTrace: stackTrace);
  }

  static bool _shouldLog(Level level) {
    if (_currentLevel == LogLevel.off) return false;

    final levelValue = level.index;
    final currentLevelValue = _currentLevel.value;
    return levelValue >= currentLevelValue;
  }

  static String _formatJson(String jsonString) {
    const indent = '  ';
    var output = StringBuffer();
    var level = 0;
    var inString = false;

    for (var i = 0; i < jsonString.length; i++) {
      var char = jsonString[i];

      if (char == '"' && (i == 0 || jsonString[i - 1] != '\\')) {
        inString = !inString;
      }

      if (!inString) {
        switch (char) {
          case '{':
          case '[':
            output.write(char);
            output.write('\n');
            level++;
            output.write(indent * level);
            break;
          case '}':
          case ']':
            output.write('\n');
            level--;
            output.write(indent * level);
            output.write(char);
            break;
          case ',':
            output.write(char);
            output.write('\n');
            output.write(indent * level);
            break;
          case ':':
            output.write(': ');
            break;
          default:
            output.write(char);
        }
      } else {
        output.write(char);
      }
    }

    return output.toString();
  }
}

/// 自定义日志过滤器
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

/// 自定义日志打印机
class _CustomLogPrinter extends LogPrinter {
  final bool showTime;
  final bool showEmojis;
  final bool colors;
  final int methodCount;
  final int errorMethodCount;

  _CustomLogPrinter({
    this.showTime = false,
    this.showEmojis = true,
    this.colors = true,
    this.methodCount = 0,
    this.errorMethodCount = 0,
  });

  @override
  List<String> log(LogEvent event) {
    final color = Log._levelColors[event.level];
    final emoji = Log._levelEmojis[event.level];

    final timeStr = showTime ? '[${DateTime.now().toIso8601String()}] ' : '';
    final emojiStr = showEmojis ? '$emoji ' : '';

    var message = '$timeStr$emojiStr${event.level.name.toUpperCase()}: ${event.message}';

    if (event.error != null) {
      message += '\nError: ${event.error}';
    }

    if (event.stackTrace != null) {
      message += '\nStackTrace: ${event.stackTrace}';
    }

    if (colors && color != null) {
      return [color(message)];
    } else {
      return [message];
    }
  }
}

/// 自定义日志输出
class _CustomLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(print);
  }
}