import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_library/library/router/app_router.dart';

class PageContent extends StatelessWidget {
  final String name;
  const PageContent({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '当前页面: $name',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: Container(
        color: Colors.green,
        decoration: BoxDecoration(color: Colors.blue),
      ),
    );
  }
}
