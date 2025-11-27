import 'package:flutter/material.dart';

import '../provider/getx_router.dart';

class RoomDetail extends StatefulWidget {
  final String roomId;
  const RoomDetail({super.key, required this.roomId});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  @override
  Widget build(BuildContext context) {
    final args = RouteManager.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('房间 ${widget.roomId}')),
      body: Center(
        child: Column(
          children: [
            Text('参数: $args'),
            ElevatedButton(
              onPressed: () => RouteManager.back(result: {'status': 'success'}),
              child: Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}

