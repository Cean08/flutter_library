import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* provider
核心原则：只能在 Provider 的后代 Widget 中访问该 Provider。

当遇到这个错误时：
1. 使用 Consumer 包装需要访问 Provider 的部件
2. 提升 Provider 到更上层的 Widget
3. 使用 Builder 创建新的 context
4. 创建独立的 Widget 来获得新的 build context
 */
class User {
  final String id;
  final String name;
  final String email;
  final int age;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  User copyWith({String? id, String? name, String? email, int? age}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'age': age};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }
}

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  User? get currentUser => _currentUser;

  List<User> get users => _users;

  // 登录用户
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // 添加用户
  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  // 删除用户
  void deleteUser() {
    _users.removeLast();
    notifyListeners();
  }
}

/* Bloc
* 不可变性：始终创建新的列表/对象，不要直接修改原状态
* copyWith 模式：使用 copyWith 方法创建状态的新实例
* 使用 EquatableMixin：对于复杂的继承关系，使用 mixin 更灵活
* 包含父类属性：在 props getter 中使用 ...super.props 包含父类属性
* 关键组件总结：
组件	作用	执行顺序
State	定义应用状态	1
Cubit/Bloc	处理业务逻辑	2
BlocProvider	依赖注入	3
BlocBuilder	UI 响应状态	4
context.read	触发事件	5
* */

class BlocUser extends User with EquatableMixin {
  BlocUser({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, email, age];
}

class UserListState extends Equatable {
  final List<BlocUser> users;
  final bool isLoading;
  final String? error;

  const UserListState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UserListState copyWith({
    List<BlocUser>? users,
    bool? isLoading,
    String? error,
  }) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [users, isLoading, error];
}

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListState());

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await Future.delayed(const Duration(seconds: 2));
      final users = [
        BlocUser(id: '1', name: 'Alice', email: 'alice@example.com', age: 25),
        BlocUser(id: '2', name: 'Bob', email: 'bob@example.com', age: 30),
        BlocUser(id: '3', name: 'Charlie', email: 'charlie@example.com', age: 28),
      ];
      emit(state.copyWith(isLoading: false, users: users));
    } catch (e){
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // 更新用户
  void updateUser(String userId, BlocUser updatedUser) {
    final newUsers = state.users.map((user){
      return user.id == userId ? updatedUser : user;
    }).toList();
    emit(state.copyWith(users: newUsers));
  }

  // 删除用户
  void deleteUser(String userId) {
    final newUsers = state.users.where((user){
      return user.id != userId;
    }).toList();
    emit(state.copyWith(users: newUsers));
  }
}
