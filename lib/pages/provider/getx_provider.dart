
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 重要方法总结
/// 方法	          说明	使用场景
/// .obs	        创建响应式变量	需要自动更新的数据
/// Obx()	        响应式UI构建器	包裹需要响应数据变化的UI部件
/// GetBuilder	  简单状态UI构建器	需要手动控制更新的UI部件
/// update()	    手动触发UI更新	简单状态管理中通知UI刷新
/// ever()	      持续监听变化	需要一直监听某个变量的变化
/// debounce()	  防抖监听	搜索框、输入框等频繁变化的场景
/// once()	      单次监听	只需要监听第一次变化的情况
/// Get.put()	    依赖注入	注册控制器实例
/// Get.find()	  获取控制器	获取已注册的控制器实例
/// Get.lazyPut()	懒加载注入	延迟创建控制器，第一次使用时创建
/// onInit()	    控制器初始化	执行初始化逻辑
/// onReady()	    控制器就绪	在界面构建完成后执行逻辑
/// onClose()	    控制器销毁	清理资源、取消订阅等

/// 1. 响应式状态管理 (Reactive State Management)
// 创建响应式控制器
class CounterController extends GetxController {
  // 响应式变量 - 当值改变时自动更新UI
  var count = 0.obs; // .obs 使变量变为响应式

  // 计算属性 - 基于响应式变量自动计算
  Rx<num> get doubleCount => (count * 2).obs;

  void increment() {
    count++; // 直接修改值，UI自动更新
  }

  void decrement() {
    count--;
  }

  void reset() {
    count.value = 0; // 也可以通过 .value 修改
  }

  // 手动触发更新（在简单状态管理中常用）
  @override
  void onInit() {
    super.onInit();
    // 控制器初始化时调用
    print('CounterController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    // 控制器准备就绪时调用
    print('CounterController ready');
  }

  @override
  void onClose() {
    super.onClose();
    // 控制器销毁时调用，用于清理资源
    print('CounterController closed');
  }
}

//使用示例
class CounterPage extends StatelessWidget {
  final CounterController controller = Get.put(CounterController()); // 依赖注入

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GetX Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用 Obx 监听响应式变量变化
            Obx(() => Text(
              'Count: ${controller.count.value}',
              style: TextStyle(fontSize: 24),
            )),

            Obx(() => Text(
              'Double: ${controller.doubleCount.value}',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            )),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.decrement,
                  child: Text('-'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.increment,
                  child: Text('+'),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: controller.reset,
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. 简单状态管理 (Simple State Management)
class UserController extends GetxController {
  String _name = '';
  int _age = 0;

  String get name => _name;
  int get age => _age;

  void updateUser(String newName, int newAge) {
    _name = newName;
    _age = newAge;
    update(); // 手动通知UI更新，必须调用
  }

  void clear() {
    _name = '';
    _age = 0;
    update(); // 必须调用update()来刷新UI
  }
}

//在UI中使用简单状态管理
class UserProfilePage extends StatelessWidget {
  UserProfilePage({super.key});
  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Center(
        child: Column(
          children: [
            // 使用 GetBuilder 包裹需要更新的部件
            GetBuilder<UserController>(
              builder: (controller) {
                return Column(
                  children: [
                    Text('Name: ${controller.name}'),
                    Text('Age: ${controller.age}'),
                  ],
                );
              },
            ),

            ElevatedButton(
              onPressed: () {
                userController.updateUser('John Doe', 25);
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. 多种响应式变量类型
class DataController extends GetxController {
  // 各种类型的响应式变量
  var stringVar = ''.obs;
  var intVar = 0.obs;
  var doubleVar = 0.0.obs;
  var boolVar = false.obs;
  var listVar = <String>[].obs;
  var mapVar = <String, dynamic>{}.obs;

  // 自定义类作为响应式变量
  var user = User().obs;

  void updateAllData() {
    // 批量更新多个响应式变量
    stringVar.value = 'Hello GetX';
    intVar.value = 42;
    doubleVar.value = 3.14;
    boolVar.value = true;
    listVar.assignAll(['item1', 'item2', 'item3']); // 替换整个列表
    mapVar.assignAll({'key1': 'value1', 'key2': 'value2'}); // 替换整个map
    user.update((user) { // 更新自定义对象
      user?.name = 'Alice';
      user?.age = 30;
    });
  }

  void addToList() {
    listVar.add('new item'); // 自动触发更新
  }

  void updateMap() {
    mapVar['newKey'] = 'newValue'; // 自动触发更新
  }
}

class User {
  String name = '';
  int age = 0;
}
/// 4. Workers - 监听状态变化
/// 状态管理选择条件监听
class WorkerController extends GetxController {
  var count = 0.obs;
  var searchText = ''.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();

    // 监听count变化，只有当count > 5时执行
    ever(count, (value) {
      if (value > 5) {
        print('Count is now greater than 5: $value');
      }
    });

    // 监听searchText变化，防抖处理（停止输入500ms后执行）
    debounce(searchText, (value) {
      print('Searching for: $value');
      // 这里可以执行搜索API调用
    }, time: Duration(milliseconds: 500));

    // 监听isLoggedIn变化，只在值改变时执行一次
    once(isLoggedIn, (value) {
      print('Login status changed for the first time: $value');
    });

    // 监听多个响应式变量，任意一个变化时执行
    everAll([count, searchText], (value) {
      print('Either count or searchText changed');
    });

    // 监听count变化，但只在特定条件下执行
    interval(count, (value) {
      print('Count changed to: $value (throttled)');
    }, time: Duration(seconds: 1));
  }

  void increment() => count++;
  void setSearch(String text) => searchText.value = text;
  void toggleLogin() => isLoggedIn.value = !isLoggedIn.value;
}

/// 5. 依赖注入和管理
// 懒加载控制器
class LazyController extends GetxController {
  var data = 'Lazy Data'.obs;
}

// 永久存在的控制器
class PermanentController extends GetxController {
  var permanentData = 'Permanent Data'.obs;
}

class DependencyInjectionExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dependency Injection')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // 懒加载 - 第一次使用时创建
                Get.lazyPut<LazyController>(() => LazyController());
              },
              child: Text('Lazy Put Controller'),
            ),

            ElevatedButton(
              onPressed: () {
                // 永久存在 - 不会被销毁
                Get.put<PermanentController>(
                  PermanentController(),
                  permanent: true,
                );
              },
              child: Text('Put Permanent Controller'),
            ),

            ElevatedButton(
              onPressed: () {
                // 获取控制器实例
                LazyController controller = Get.find<LazyController>();
                print(controller.data.value);
              },
              child: Text('Find Controller'),
            ),

            ElevatedButton(
              onPressed: () {
                // 删除控制器实例
                Get.delete<LazyController>();
              },
              child: Text('Delete Controller'),
            ),
          ],
        ),
      ),
    );
  }
}