import 'package:flutter/material.dart';
import 'package:flutter_library/library/app_router.dart';
import 'package:flutter_library/widgets/page_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPwd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '登录',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                // 获取焦点时的边框
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              obscureText: showPwd,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "请输入密码",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                // 获取焦点时的边框
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPwd = !showPwd;
                    });
                  },
                  icon: Icon(
                    showPwd ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(onPressed: () {}, style:ButtonStyle(
              textStyle: WidgetStatePropertyAll(TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
              backgroundColor: WidgetStatePropertyAll(Colors.green),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              )
            ), child: Text('登录')),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('还没有账号'),
                TextButton(onPressed: () {
                  AppRouter.pushReplacement(PagePath.register);
                }, child: Text('去注册 ~')),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
