
import 'dart:ui';

import 'user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  // 单例模式
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user_info';

  String? _token;
  User? _user;

  // 获取 token
  String? get token => _token;

  // 获取用户信息
  User? get user => _user;

  // 判断是否登录
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  // 初始化 - 从本地存储加载数据
  Future<void> initialize() async {
    await _loadToken();
    await _loadUser();
  }

  // 从本地存储加载 token
  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
    } catch (e) {
      print('加载 token 失败: $e');
      _token = null;
    }
  }

  // 从本地存储加载用户信息
  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      if (userString != null && userString.isNotEmpty) {
        final userMap = json.decode(userString);
        _user = User.fromJson(userMap);
      }
    } catch (e) {
      print('加载用户信息失败: $e');
      _user = null;
    }
  }

  // 登录 - 保存 token 和用户信息
  Future<bool> login(String token, User user) async {
    try {
      _token = token;
      _user = user;

      final prefs = await SharedPreferences.getInstance();

      // 保存 token
      await prefs.setString(_tokenKey, token);

      // 保存用户信息
      final userJson = json.encode(user.toJson());
      await prefs.setString(_userKey, userJson);

      // 通知监听者
      _notifyListeners();

      return true;
    } catch (e) {
      print('登录信息保存失败: $e');
      return false;
    }
  }

  // 更新用户信息
  Future<bool> updateUser(User newUser) async {
    try {
      _user = newUser;

      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(newUser.toJson());
      await prefs.setString(_userKey, userJson);

      // 通知监听者
      _notifyListeners();

      return true;
    } catch (e) {
      print('用户信息更新失败: $e');
      return false;
    }
  }

  // 更新 token
  Future<bool> updateToken(String newToken) async {
    try {
      _token = newToken;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, newToken);

      // 通知监听者
      _notifyListeners();

      return true;
    } catch (e) {
      print('Token 更新失败: $e');
      return false;
    }
  }

  // 登出 - 清除所有信息
  Future<bool> logout() async {
    try {
      _token = null;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);

      // 通知监听者
      _notifyListeners();

      return true;
    } catch (e) {
      print('登出失败: $e');
      return false;
    }
  }

  // 清除所有数据（完全重置）
  Future<bool> clearAll() async {
    try {
      await logout();
      return true;
    } catch (e) {
      print('清除数据失败: $e');
      return false;
    }
  }

  // 监听器相关
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // 打印当前状态（调试用）
  void printCurrentState() {
    print('登录状态: $isLoggedIn');
    print('Token: ${_token ?? "null"}');
    print('用户信息: ${_user?.toString() ?? "null"}');
  }
}

// 使用示例
// WidgetsFlutterBinding.ensureInitialized();
// // mian中 初始化 UserManager
// await UserManager().initialize();

// final UserManager _userManager = UserManager();
// @override
// void initState() {
//   super.initState();
//   _userManager.addListener(_onUserStateChanged);
// }
//
// @override
// void dispose() {
//   _userManager.removeListener(_onUserStateChanged);
//   super.dispose();
// }
//
// void _onUserStateChanged() {
//   setState(() {});
// }