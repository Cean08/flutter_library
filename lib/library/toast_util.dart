import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtil {
  static ToastFuture? _loadingFuture;

  /// 显示加载中 Toast (带转圈动画)
  static void showLoading([String? text]) {
    dismissAll(); // 清除其他 Toast

    _loadingFuture = showToastWidget(
      Container(
        color: Colors.transparent,
        constraints: BoxConstraints.expand(), // 充满屏幕
        child: Align(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                if (text != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      handleTouch: true, // 拦截事件
      position: ToastPosition.center,
      duration: const Duration(seconds: 30), // 长时显示
      dismissOtherToast: true,
    );
  }

  /// 隐藏加载中 Toast
  static void dismissLoading() {
    _loadingFuture?.dismiss();
    _loadingFuture = null;
  }

  /// 成功提示 (绿色文字)
  static void success(String msg) {
    _showToast(msg, Colors.green, Icons.check_circle);
  }

  /// 失败提示 (红色文字)
  static void error(String msg) {
    _showToast(msg, Colors.red, Icons.error);
  }

  /// 警告提示 (黄色文字)
  static void warning(String msg) {
    _showToast(msg, Colors.yellow, Icons.warning);
  }

  /// 普通提示 (白色文字)
  static void info(String msg) {
    _showToast(msg, Colors.white, Icons.info);
  }

  /// 核心Toast方法 - 统一背景色，区分文字颜色
  static void _showToast(String msg, Color textColor, IconData icon) {
    // 先关闭可能存在的加载中Toast
    dismissLoading();

    showToastWidget(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              msg,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 2),
      dismissOtherToast: true,
    );
  }

  /// 关闭所有 Toast
  static void dismissAll() {
    dismissLoading();
    dismissAllToast(); // oktoast提供的方法
  }
}

/*
// main.dart 初始化
void main() {
  runApp(
    OKToast(
      child: MyApp(),
      textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
      backgroundColor: Colors.black54,
      position: ToastPosition.center,
      duration: Duration.zero, // 设置为0，因为我们在ToastUtil中控制时长
    ),
  );
}
 */
