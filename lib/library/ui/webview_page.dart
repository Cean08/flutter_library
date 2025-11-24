import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
 
  /// 网络 URL 地址
  final String? url;

  /// 本地 HTML 文件路径
  final String? localHtmlPath;

  /// 拦截 URL 跳转
  final bool Function(String url)? shouldOverrideUrlLoading;

  /// 接收来自 Web 的消息
  final void Function(JsMessage message)? onJsMessageReceived;

  /// WebView 创建完成回调
  final void Function(WebViewController controller)? onWebViewCreated;

  /// 页面加载进度回调
  final void Function(int progress)? onProgress;

  /// 页面加载完成回调
  final void Function()? onPageFinished;

  const WebViewPage({
    super.key,
    this.title = "",
    this.url,
    this.localHtmlPath,
    this.shouldOverrideUrlLoading,
    this.onJsMessageReceived,
    this.onWebViewCreated,
    this.onProgress,
    this.onPageFinished,
  }) : assert(url != null || localHtmlPath != null, '必须提供 url 或 localHtmlPath');

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class JsMessage {
  final String channel;
  final dynamic data;

  JsMessage(this.channel, this.data);
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(_createNavigationDelegate())
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: _handleJsMessage,
      )
      ..setOnConsoleMessage((consoleMessage) {
        debugPrint('WebView Console: ${consoleMessage.message}');
      });

    if (widget.onWebViewCreated != null) {
      widget.onWebViewCreated!(_controller);
    }

    if (widget.url != null) {
      _controller.loadRequest(Uri.parse(widget.url!));
    } else if (widget.localHtmlPath != null) {
      _loadLocalHtml();
    }
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
      onProgress: (progress) {
        setState(() => _progress = progress);
        widget.onProgress?.call(progress);
      },
      onPageFinished: (url) {
        widget.onPageFinished?.call();
      },
      onNavigationRequest: (request) {
        if (widget.shouldOverrideUrlLoading != null &&
            widget.shouldOverrideUrlLoading!(request.url)) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }

  void _handleJsMessage(JavaScriptMessage message) {
    try {
      final json = jsonDecode(message.message);
      final channel = json['channel'] as String?;
      final data = json['data'];

      if (channel != null && widget.onJsMessageReceived != null) {
        debugPrint('JS交互: $channel 参数: $data');
        widget.onJsMessageReceived!(JsMessage(channel, data));
      }
    } catch (e) {
      debugPrint('JS消息解析失败: ${e.toString()}');
    }
  }

  Future<void> _loadLocalHtml() async {
    try {
      final html = await DefaultAssetBundle.of(
        context,
      ).loadString(widget.localHtmlPath!);
      _controller.loadHtmlString(html);
    } catch (e) {
      debugPrint('加载本地HTML失败: $e');
    }
  }

  /// 向 Web 页面发送消息
  Future<void> postMessage(String channel, dynamic data) async {
    final script =
        '''
      if (window.flutterMessageHandler) {
        window.flutterMessageHandler('$channel', ${jsonEncode(data)});
      }
    ''';
    await _controller.runJavaScript(script);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_progress < 100)
              LinearProgressIndicator(
                value: _progress / 100,
                backgroundColor: Colors.grey[200],
                minHeight: 3,
              ),
          ],
        ),
      ),
    );
  }
}

/*
WebViewPage(
  url: 'https://example.com',
  onPageFinished: () => print('页面加载完成'),
)

WebViewPage(
  url: 'https://example.com',
  shouldOverrideUrlLoading: (url) {
    if (url.contains('blocked.com')) {
      print('拦截跳转到: $url');
      return true; // 阻止跳转
    }
    return false; // 允许跳转
  },
)


//加载本地 HTML（需在 pubspec.yaml 声明资源）
flutter:
  assets:
    - assets/local_page.html

WebViewPage(
  localHtmlPath: 'assets/local_page.html',
)



#与 Web 页面交互
Flutter → Web：调用 postMessage 方法

// 1.获取控制器
late WebViewController _webController;

WebViewPage(
  onWebViewCreated: (controller) => _webController = controller,
)

// 2.发送消息到 Web 页面
ElevatedButton(
  onPressed: () {
    final state = _webController.state as _CustomWebViewState;
    state.postMessage('updateColor', {'color': '#FF0000'});
  },
  child: Text('发送消息到Web'),
)



#Web → Flutter：通过 FlutterBridge 通道
<script>
// 发送消息到 Flutter
function sendToFlutter() {
  // 新版使用方式相同
  FlutterBridge.postMessage(JSON.stringify({
    channel: 'userAction',
    data: { type: 'login', user: 'john@example.com' }
  }));
}

// 接收 Flutter 消息
window.flutterMessageHandler = (channel, data) => {
  console.log(`收到Flutter消息 [${channel}]:`, data);
  if (channel === 'updateTheme') {
    document.body.style.backgroundColor = data.color;
  }
};
</script>

<button onclick="sendToFlutter()">与Flutter交互</button>
 */
