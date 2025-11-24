import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据持久化抽象接口
abstract class IStorage {
  // 基础数据类型存储
  Future<bool> setInt(String key, int value);
  Future<bool> setDouble(String key, double value);
  Future<bool> setBool(String key, bool value);
  Future<bool> setString(String key, String value);
  Future<bool> setStringList(String key, List<String> value);

  // 对象存储
  Future<bool> setObject<T>(String key, T value, {required T Function(Map<String, dynamic>) fromJson});
  Future<bool> setObjectList<T>(String key, List<T> value, {required T Function(Map<String, dynamic>) fromJson});

  // 基础数据读取
  int? getInt(String key);
  double? getDouble(String key);
  bool? getBool(String key);
  String? getString(String key);
  List<String>? getStringList(String key);

  // 对象读取
  T? getObject<T>(String key, {required T Function(Map<String, dynamic>) fromJson});
  List<T>? getObjectList<T>(String key, {required T Function(Map<String, dynamic>) fromJson});

  // 通用操作
  Future<bool> remove(String key);
  Future<bool> clear();

  // 检查是否存在
  bool containsKey(String key);
}

/// 使用SharedPreferences的具体实现
class LocalStorage implements IStorage {
  static SharedPreferences? _prefs;

  LocalStorage._();

  static Future<LocalStorage> create() async {
    _prefs ??= await SharedPreferences.getInstance();
    return LocalStorage._();
  }

  // 基础类型存储方法
  @override
  Future<bool> setInt(String key, int value) => _prefs!.setInt(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _prefs!.setDouble(key, value);

  @override
  Future<bool> setBool(String key, bool value) => _prefs!.setBool(key, value);

  @override
  Future<bool> setString(String key, String value) => _prefs!.setString(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) => _prefs!.setStringList(key, value);

  // 对象存储方法
  @override
  Future<bool> setObject<T>(String key, T value, {required T Function(Map<String, dynamic>) fromJson}) {
    final jsonString = jsonEncode(value);
    return setString(key, jsonString);
  }

  @override
  Future<bool> setObjectList<T>(String key, List<T> value, {required T Function(Map<String, dynamic>) fromJson}) {
    final jsonList = value.map((e) => jsonEncode(e)).toList();
    return setStringList(key, jsonList);
  }

  // 基础类型读取方法
  @override
  int? getInt(String key) => _prefs!.getInt(key);

  @override
  double? getDouble(String key) => _prefs!.getDouble(key);

  @override
  bool? getBool(String key) => _prefs!.getBool(key);

  @override
  String? getString(String key) => _prefs!.getString(key);

  @override
  List<String>? getStringList(String key) => _prefs!.getStringList(key);

  // 对象读取方法
  @override
  T? getObject<T>(String key, {required T Function(Map<String, dynamic>) fromJson}) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJson(jsonMap);
  }

  @override
  List<T>? getObjectList<T>(String key, {required T Function(Map<String, dynamic>) fromJson}) {
    final jsonList = getStringList(key);
    if (jsonList == null) return null;

    return jsonList.map((jsonStr) {
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return fromJson(jsonMap);
    }).toList();
  }

  // 通用方法
  @override
  Future<bool> remove(String key) => _prefs!.remove(key);

  @override
  Future<bool> clear() => _prefs!.clear();

  @override
  bool containsKey(String key) => _prefs!.containsKey(key);
}

/// 存储管理类（对外暴露的统一接口）
class StorageManager {
  static IStorage? _storage;

  /// 初始化存储实例
  static Future<void> initialize() async {
    // 使用SharedPreferences实现
    _storage = await LocalStorage.create();
  }

  // 基础类型存取 -------------------------------------------------
  static Future<bool> saveValue<T>({required String key, required T value}) {
    _assertInitialized();

    if (value is int) {
      return _storage!.setInt(key, value);
    } else if (value is double) {
      return _storage!.setDouble(key, value);
    } else if (value is bool) {
      return _storage!.setBool(key, value);
    } else if (value is String) {
      return _storage!.setString(key, value);
    } else if (value is List<String>) {
      return _storage!.setStringList(key, value);
    }
    throw Exception('Unsupported type: ${T.toString()}');
  }

  static T? getValue<T>({required String key}) {
    _assertInitialized();

    switch (T) {
      case int:
        return _storage!.getInt(key) as T?;
      case double:
        return _storage!.getDouble(key) as T?;
      case bool:
        return _storage!.getBool(key) as T?;
      case String:
        return _storage!.getString(key) as T?;
      case const (List<String>):
        return _storage!.getStringList(key) as T?;
      default:
        throw Exception('Unsupported type: ${T.toString()}');
    }
  }

  // 对象存取 -----------------------------------------------------
  static Future<bool> saveObject<T>({
    required String key,
    required T value,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    _assertInitialized();
    return _storage!.setObject<T>(key, value, fromJson: fromJson);
  }

  static T? getObject<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    _assertInitialized();
    return _storage!.getObject<T>(key, fromJson: fromJson);
  }

  // 对象列表存取 -------------------------------------------------
  static Future<bool> saveObjectList<T>({
    required String key,
    required List<T> value,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    _assertInitialized();
    return _storage!.setObjectList<T>(key, value, fromJson: fromJson);
  }

  static List<T>? getObjectList<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    _assertInitialized();
    return _storage!.getObjectList<T>(key, fromJson: fromJson);
  }

  // 通用操作 -----------------------------------------------------
  static Future<bool> remove(String key) {
    _assertInitialized();
    return _storage!.remove(key);
  }

  static Future<bool> clear() {
    _assertInitialized();
    return _storage!.clear();
  }

  static bool containsKey(String key) {
    _assertInitialized();
    return _storage!.containsKey(key);
  }

  // 辅助方法 -----------------------------------------------------
  static void _assertInitialized() {
    assert(_storage != null, 'Storage not initialized! Call StorageManager.initialize() first.');
  }
}
/* 使用示例
// 1. 确保框架绑定初始化
WidgetsFlutterBinding.ensureInitialized();
// 2. 等待存储完全初始化（必须使用 await）
await StorageManager.initialize();

// 保存数据
await StorageManager.saveValue('username', 'JohnDoe');
await StorageManager.saveValue('age', 25);
await StorageManager.saveValue('isPremium', true);

// 读取数据
String? username = StorageManager.getValue<String>('username');
int? age = StorageManager.getValue<int>('age');
bool? isPremium = StorageManager.getValue<bool>('isPremium');


// 存模型
class User {
  final String name;
  final int age;
  final bool isPremium;

  User({required this.name, required this.age, required this.isPremium});

  // 序列化方法
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'isPremium': isPremium,
  };

  // 反序列化方法
  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    age: json['age'],
    isPremium: json['isPremium'],
  );
}


// 存储单个对象
final user = User(name: 'Alice', age: 30, isPremium: true);
await StorageManager.saveObject(
  key: 'current_user',
  value: user,
  fromJson: User.fromJson,
);

// 读取单个对象
final storedUser = StorageManager.getObject<User>(
  key: 'current_user',
  fromJson: User.fromJson,
);
print(storedUser?.name); // 输出: Alice

// 存储对象列表
final products = [
  Product(id: '1', name: 'Laptop', price: 999.99),
  Product(id: '2', name: 'Phone', price: 699.99),
];
await StorageManager.saveObjectList(
  key: 'cart_products',
  value: products,
  fromJson: Product.fromJson,
);

// 读取对象列表
final storedProducts = StorageManager.getObjectList<Product>(
  key: 'cart_products',
  fromJson: Product.fromJson,
);
print(storedProducts?.length); // 输出: 2

// 检查是否存在
if (StorageManager.containsKey('current_user')) {
  print('用户数据存在');
}

// 删除数据
await StorageManager.remove('cart_products');

// 清空所有数据
await StorageManager.clear();
 */