
import 'dart:isolate';
import 'package:get/get.dart';
import 'isolate.dart';

class Item {
  late String id;
  late String title;

  Item({
    required this.id,
    required this.title,
  });

  Item copyWith({String? id, String? title}) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}

class ItemController extends GetxController {
  var item = Item(id: '111', title: 'title').obs;
  Future<void> updateTitle(String title) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(isolateFunction, receivePort.sendPort);
    receivePort.listen((message) {
      print('收到结果: $message');
      receivePort.close();
      item.update((val){
        val!.title = title;
      });
    });
  }
}