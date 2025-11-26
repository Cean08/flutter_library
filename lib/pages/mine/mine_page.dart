import 'package:flutter/material.dart';
import 'package:flutter_library/widgets/page_content.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, //导航下面的分割线
        title: Text(
          '我的',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.green),
      ),
    );
  }
}