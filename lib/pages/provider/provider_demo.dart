import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_counter.dart';
import 'getx_data.dart';
import 'package:flutter_library/pages/user.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProviderDemo extends StatefulWidget {
  const ProviderDemo({super.key});

  @override
  State<ProviderDemo> createState() => _ProviderDemoState();
}

class _ProviderDemoState extends State<ProviderDemo> {
  final ItemController controller = Get.put(ItemController());
  var count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider')),
      body: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('状态管理: '),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Consumer<UserProvider>(
                  builder: (context, provider, child) => Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserProvider>().login(
                            User(
                              id: '111',
                              name: 'peter',
                              email: 'email1',
                              age: 10,
                            ),
                          );
                        },
                        child: Text('provider'),
                      ),
                      Text(provider.currentUser?.name ?? ""),
                    ],
                  ),
                ),
                BlocProvider(
                  create: (context) => CounterCubit(),
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              context.read<CounterCubit>().increment();
                            },
                            child: Text('flutter_bloc++'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CounterCubit>().decrement();
                            },
                            child: Text('flutter_bloc--'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CounterCubit>().reset();
                            },
                            child: Text('flutter_bloc_reset'),
                          ),
                          BlocBuilder<CounterCubit, CounterState>(
                            builder: (context, state) {
                              return Text('${state.count}');
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    ElevatedButton(onPressed: () {
                      count++;
                      controller.updateTitle('title$count');
                    }, child: Text('getx')),
                    Obx(() => Text('${controller.item.toJson()}')),
                  ],
                ),
              ],
            ),
            BlocProvider(
              create: (context) => UserListCubit()..loadUsers(),
              child: Builder(
                builder: (context) {
                  return Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          BlocUser user = BlocUser(
                            id: '22',
                            name: '用户 22',
                            email: 'user22@example.com',
                            age: 22,
                          );
                          context.read<UserListCubit>().updateUser('1', user);
                        },
                        child: Text('flutter_bloc_add_user'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<UserListCubit>().deleteUser('22');
                        },
                        child: Text('flutter_bloc_delete_user'),
                      ),
                      BlocBuilder<UserListCubit, UserListState>(
                        builder: (context, state) {
                          return Text(state.users.toString());
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
