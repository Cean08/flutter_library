import 'package:flutter/material.dart';

class RoomDetail extends StatefulWidget {
  final String roomId;
  const RoomDetail({super.key, required this.roomId});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('roomId: ${widget.roomId}'),
      ),
    );
  }
}
