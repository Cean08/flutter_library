
import 'dart:isolate';

// 在 Isolate 中执行的函数
void isolateFunction(SendPort sendPort) {
  final result = heavyCalculation();
  // 发送结果回主 Isolate
  sendPort.send(result);
}

int heavyCalculation() {
  int sum = 0;
  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }
  return sum;
}

// 在主 Isolate 中启动
Future<void> startIsolate() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(isolateFunction, receivePort.sendPort);

  // 监听结果
  receivePort.listen((message) {
    print('收到结果: $message');
    receivePort.close();
  });
}