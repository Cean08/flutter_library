import 'package:flutter/material.dart';
import 'package:flutter_library/library/app_router.dart';
import 'package:flutter_library/widgets/page_content.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPwd = false;
  bool showPwd1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '注册',
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
            TextField(
              obscureText: showPwd1,
              decoration: InputDecoration(
                labelText: "确认密码",
                hintText: "请再次输入密码",
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
                      showPwd1 = !showPwd1;
                    });
                  },
                  icon: Icon(
                    showPwd1 ? Icons.visibility : Icons.visibility_off,
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
            ), child: Text('注册')),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('已有账号'),
                TextButton(onPressed: () {
                  AppRouter.pushReplacement(PagePath.login);
                }, child: Text('去登录 ~')),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
