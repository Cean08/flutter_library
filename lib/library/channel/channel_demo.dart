import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'channel.dart';

class ChannelManager {
  // MethodChannel 实例
  static final platformChannel = FlutterMethodChannel(
    name: 'com.example/platform',
    defaultValue: 'unknown',
  );

  // EventChannel 实例
  static final batteryChannel = FlutterEventChannel(
    name: 'com.example/battery',
    defaultValue: 'unknown',
  );

  // BasicMessageChannel 实例 - 使用新的专门类
  static final stringChannel = StringMessageChannel(
    name: 'com.example/string',
    defaultValue: 'default_string',
  );

  static final dynamicChannel = DynamicMessageChannel(
    name: 'com.example/dynamic',
    defaultValue: 'default_dynamic',
  );

  static final mapChannel = MapMessageChannel(
    name: 'com.example/map',
    defaultValue: {'status': 'default'},
  );

  static final jsonChannel = JsonMessageChannel(
    name: 'com.example/json',
    defaultValue: '{"status": "default"}',
  );
}

// 使用示例
class ChannelDemo extends StatefulWidget {
  const ChannelDemo({super.key});

  @override
  State<ChannelDemo> createState() => _ChannelDemoState();
}

class _ChannelDemoState extends State<ChannelDemo> {
  String _platformVersion = 'Unknown';
  String _batteryLevel = 'Unknown';
  String _stringResponse = 'No response';
  String _dynamicResponse = 'No response';
  String _mapResponse = 'No response';
  String _jsonResponse = 'No response';

  StreamSubscription<String>? _batterySubscription;

  @override
  void initState() {
    super.initState();
    _setupChannels();
  }

  void _setupChannels() {
    // 设置 MethodChannel 处理器
    ChannelManager.platformChannel.setMethodCallHandler(handler: _handleMethodCall);

    // 设置消息处理器
    ChannelManager.stringChannel.setMessageHandler(handler: _handleStringMessage);
    ChannelManager.dynamicChannel.setMessageHandler(handler: _handleDynamicMessage);
    ChannelManager.mapChannel.setMessageHandler(handler: _handleMapMessage);
    ChannelManager.jsonChannel.setMessageHandler(handler: _handleJsonMessage);

    // 监听 EventChannel
    _batterySubscription = ChannelManager.batteryChannel
        .receiveBroadcastStream<String>()
        .listen(_handleBatteryEvent);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getDeviceInfo':
        return {
          'platform': 'Flutter',
          'version': '3.0.0',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method not implemented',
        );
    }
  }

  Future<String> _handleStringMessage(String? message) async {
    print('String message: $message');
    return 'Processed: $message';
  }

  Future<dynamic> _handleDynamicMessage(dynamic message) async {
    print('Dynamic message: $message (type: ${message.runtimeType})');
    return 'Dynamic response: $message';
  }

  Future<Map<String, dynamic>> _handleMapMessage(Map<String, dynamic>? message) async {
    print('Map message: $message');
    return {
      'response': 'Map processed',
      'original': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<String> _handleJsonMessage(String? message) async {
    print('JSON message: $message');
    try {
      // 这里可以解析 JSON
      return '{"status": "success", "received": $message}';
    } catch (e) {
      return '{"error": "JSON processing failed"}';
    }
  }

  void _handleBatteryEvent(String event) {
    setState(() {
      _batteryLevel = event;
    });
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channel Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Platform: $_platformVersion'),
            Text('Battery: $_batteryLevel'),
            Text('String: $_stringResponse'),
            Text('Dynamic: $_dynamicResponse'),
            Text('Map: $_mapResponse'),
            Text('JSON: $_jsonResponse'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _getPlatformVersion,
              child: const Text('获取平台版本'),
            ),

            ElevatedButton(
              onPressed: _sendStringMessage,
              child: const Text('发送字符串'),
            ),

            ElevatedButton(
              onPressed: _sendDynamicMessage,
              child: const Text('发送动态消息'),
            ),

            ElevatedButton(
              onPressed: _sendMapMessage,
              child: const Text('发送 Map'),
            ),

            ElevatedButton(
              onPressed: _sendJsonMessage,
              child: const Text('发送 JSON'),
            ),
          ],
        ),
      ),
    );
  }

  void _getPlatformVersion() async {
    final version = await ChannelManager.platformChannel.invokeMethod<String>(
      method: 'getPlatformVersion',
    );
    setState(() {
      _platformVersion = version ?? 'Unknown';
    });
  }

  void _sendStringMessage() async {
    final response = await ChannelManager.stringChannel.send('Hello String Channel');
    setState(() {
      _stringResponse = response ?? 'No response';
    });
  }

  void _sendDynamicMessage() async {
    final response = await ChannelManager.dynamicChannel.send('Hello Dynamic Channel');
    setState(() {
      _dynamicResponse = response?.toString() ?? 'No response';
    });
  }

  void _sendMapMessage() async {
    final response = await ChannelManager.mapChannel.send({
      'type': 'test',
      'data': {'value': 42, 'items': [1, 2, 3]},
    });
    setState(() {
      _mapResponse = response?.toString() ?? 'No response';
    });
  }

  void _sendJsonMessage() async {
    final response = await ChannelManager.jsonChannel.sendJson(
      '{"action": "test", "value": 123}',
    );
    setState(() {
      _jsonResponse = response ?? 'No response';
    });
  }
}