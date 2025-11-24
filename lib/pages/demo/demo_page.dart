import 'package:flutter/material.dart';
import 'package:flutter_library/library/app_router.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('appbarTitle')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  AppRouter.push(PagePath.provider);
                },
                child: Text('provider'),
              ),
              ElevatedButton(
                onPressed: () {
                  AppRouter.push(PagePath.repaint);
                },
                child: Text('高频数据刷新'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  AppRouter.push(PagePath.login);
                },
                child: Text("去登陆"),
              ),
              ElevatedButton(
                onPressed: () {
                  AppRouter.push(PagePath.roomDetail, extra: "123456");
                },
                child: Text(PagePath.roomDetail),
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
