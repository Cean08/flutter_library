import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// MethodChannel 封装
class FlutterMethodChannel {
  final MethodChannel _channel;
  final dynamic _defaultValue;

  FlutterMethodChannel({
    required String name,
    dynamic defaultValue,
  })  : _channel = MethodChannel(name),
        _defaultValue = defaultValue;

  // 调用原生方法
  Future<T?> invokeMethod<T>({
    required String method,
    dynamic arguments,
    T? defaultValue,
  }) async {
    try {
      final result = await _channel.invokeMethod<T>(method, arguments);
      return result ?? defaultValue ?? _defaultValue as T?;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('MethodChannel error: ${e.message}');
      }
      return defaultValue ?? _defaultValue as T?;
    }
  }

  // 设置方法调用处理器
  void setMethodCallHandler({
    required Future<dynamic> Function(MethodCall call) handler,
  }) {
    _channel.setMethodCallHandler(handler);
  }

  // 获取原始 channel（用于特殊需求）
  MethodChannel get rawChannel => _channel;
}


/// EventChannel 封装
class FlutterEventChannel {
  final EventChannel _channel;
  final dynamic _defaultValue;

  FlutterEventChannel({
    required String name,
    dynamic defaultValue,
  })  : _channel = EventChannel(name),
        _defaultValue = defaultValue;

  // 接收广播流
  Stream<T> receiveBroadcastStream<T>([dynamic arguments]) {
    return _channel
        .receiveBroadcastStream(arguments)
        .handleError((error) {
      if (kDebugMode) {
        print('EventChannel error: $error');
      }
    })
        .map<T>((event) {
      try {
        return event as T;
      } catch (e) {
        return _defaultValue as T;
      }
    });
  }

  // 获取原始 channel（用于特殊需求）
  EventChannel get rawChannel => _channel;
}


/// BasicMessageChannel 封装
// 基础消息通道抽象类
abstract class BaseMessageChannel {
  String get name;
}

// 字符串消息通道 - 使用 StringCodec
class StringMessageChannel implements BaseMessageChannel {
  final BasicMessageChannel<String> _channel;
  final String? _defaultValue;

  StringMessageChannel({
    required String name,
    String? defaultValue,
  })  : _channel = BasicMessageChannel<String>(name, const StringCodec()),
        _defaultValue = defaultValue;

  @override
  String get name => _channel.name;

  Future<String?> send(String message) async {
    try {
      return await _channel.send(message);
    } on PlatformException catch (e) {
      print('StringMessageChannel error: ${e.message}');
      return _defaultValue;
    }
  }

  void setMessageHandler({
    required Future<String> Function(String? message) handler,
  }) {
    _channel.setMessageHandler((message) async {
      try {
        return await handler(message);
      } catch (e) {
        print('String message handler error: $e');
        return _defaultValue ?? 'Error processing message';
      }
    });
  }

  BasicMessageChannel<String> get rawChannel => _channel;
}

// 动态类型消息通道 - 使用 StandardMessageCodec
class DynamicMessageChannel implements BaseMessageChannel {
  final BasicMessageChannel<dynamic> _channel;
  final dynamic _defaultValue;

  DynamicMessageChannel({
    required String name,
    dynamic defaultValue,
  })  : _channel = BasicMessageChannel<dynamic>(name, const StandardMessageCodec()),
        _defaultValue = defaultValue;

  @override
  String get name => _channel.name;

  Future<dynamic> send(dynamic message) async {
    try {
      return await _channel.send(message);
    } on PlatformException catch (e) {
      print('DynamicMessageChannel error: ${e.message}');
      return _defaultValue;
    }
  }

  void setMessageHandler({
    required Future<dynamic> Function(dynamic message) handler,
  }) {
    _channel.setMessageHandler((message) async {
      try {
        return await handler(message);
      } catch (e) {
        print('Dynamic message handler error: $e');
        return _defaultValue;
      }
    });
  }

  BasicMessageChannel<dynamic> get rawChannel => _channel;
}

// Map 消息通道 - 包装 DynamicMessageChannel，提供类型安全
class MapMessageChannel implements BaseMessageChannel {
  final DynamicMessageChannel _channel;

  MapMessageChannel({
    required String name,
    Map<String, dynamic>? defaultValue,
  }) : _channel = DynamicMessageChannel(
    name: name,
    defaultValue: defaultValue ?? {'error': 'default'},
  );

  @override
  String get name => _channel.name;

  Future<Map<String, dynamic>?> send(Map<String, dynamic> message) async {
    final result = await _channel.send(message);
    return _convertToMap(result);
  }

  void setMessageHandler({
    required Future<Map<String, dynamic>> Function(Map<String, dynamic>? message) handler,
  }) {
    _channel.setMessageHandler(handler: (message) async {
      final mapMessage = _convertToMap(message);
      final result = await handler(mapMessage);
      return result;
    });
  }

  Map<String, dynamic>? _convertToMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  DynamicMessageChannel get rawChannel => _channel;
}

// JSON 字符串消息通道 - 包装 StringMessageChannel，明确处理 JSON
class JsonMessageChannel implements BaseMessageChannel {
  final StringMessageChannel _channel;

  JsonMessageChannel({
    required String name,
    String? defaultValue,
  }) : _channel = StringMessageChannel(
    name: name,
    defaultValue: defaultValue ?? '{"error": "default"}',
  );

  @override
  String get name => _channel.name;

  Future<String?> sendJson(String jsonString) async {
    return await _channel.send(jsonString);
  }

  void setMessageHandler({
    required Future<String> Function(String? jsonMessage) handler,
  }) {
    _channel.setMessageHandler(handler: handler);
  }

  StringMessageChannel get rawChannel => _channel;
}