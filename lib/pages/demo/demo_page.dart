import 'package:flutter/material.dart';
import 'package:flutter_library/library/router/app_router.dart';
import 'package:get/get.dart';


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
              ElevatedButton(
                onPressed: () {
                  AppRouter.push(PagePath.screenutil);
                },
                child: Text("屏幕适配"),
              ),
              TextButton(
                onPressed: () {
                  AppRouter.go(PagePath.login);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Getx 路由")),
              ElevatedButton(
                onPressed: () {
                  try {
                    Get.defaultDialog(
                      title: "标题",
                      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      middleText: "这是一个对话框",
                      middleTextStyle: TextStyle(fontSize: 16),
                      backgroundColor: Colors.white,
                      radius: 10.0,
                      textConfirm: "确定",
                      textCancel: "取消",
                      onConfirm: () {
                        // 确定按钮回调
                        print("确定");
                        Get.back();
                      },
                      onCancel: () {
                        // 取消按钮回调
                        Get.back();
                      },
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.blue,
                      barrierDismissible: false,
                    );
                  } catch(e){
                    print(e);
                  }

                },
                child: Text("Getx Dialog"),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDialog(context);
                },
                child: Text("flutter Dialog"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5), // 设置蒙版颜色和透明度
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('标题'),
          content: Text('这是一个原生的Dialog。'),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
