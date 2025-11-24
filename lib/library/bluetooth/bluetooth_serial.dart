import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class BluetoothFileTransfer {
  BluetoothConnection? _connection;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // 启用蓝牙
  Future<void> enableBluetooth() async {
    bool? isEnabled = await _bluetooth.isEnabled;
    if (!isEnabled!) {
      await _bluetooth.requestEnable();
    }
  }

  // 发现设备
  Future<List<BluetoothDevice>> discoverDevices() async {
    List<BluetoothDevice> devices = [];
    _bluetooth.startDiscovery().listen((result) {
      if (!devices.any((device) => device.address == result.device.address)) {
        devices.add(result.device);
      }
    });
    await Future.delayed(Duration(seconds: 10));
    return devices;
  }

  // 连接设备
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      return true;
    } catch (e) {
      print('连接失败: $e');
      return false;
    }
  }

  // 发送文件
  Future<void> sendFile(File file) async {
    if (_connection == null || !_connection!.isConnected) {
      throw Exception('未连接到设备');
    }

    // 读取文件并转换为 Uint8List
    List<int> fileBytes = await file.readAsBytes();
    Uint8List fileData = Uint8List.fromList(fileBytes); // 修复：转换为 Uint8List

    // 发送文件信息（文件名和大小）
    String fileInfo = 'FILE:${file.path.split('/').last}:${fileBytes.length}';
    List<int> infoBytes = ascii.encode('$fileInfo\n');
    _connection!.output.add(Uint8List.fromList(infoBytes)); // 修复：转换为 Uint8List
    await _connection!.output.allSent;

    // 发送文件数据
    _connection!.output.add(fileData);
    await _connection!.output.allSent;
  }

  // 接收文件 - 修复后的版本
  void startListening() {
    // 修复：处理可能的空值
    if (_connection?.input != null) {
      _connection!.input!.listen(_handleIncomingData);
    }
  }

  // 处理接收到的数据
  void _handleIncomingData(Uint8List data) {
    String message = ascii.decode(data);

    if (message.startsWith('FILE:')) {
      // 解析文件信息
      List<String> parts = message.split(':');
      if (parts.length >= 3) {
        String fileName = parts[1];
        int fileSize = int.parse(parts[2].trim());

        // 开始接收文件数据
        _receiveFile(fileName, fileSize);
      }
    }
  }

  void _receiveFile(String fileName, int fileSize) {
    List<int> fileData = [];

    // 修复：处理可能的空值
    if (_connection?.input != null) {
      _connection!.input!.listen((Uint8List data) {
        fileData.addAll(data);

        if (fileData.length >= fileSize) {
          // 保存文件
          File file = File('/storage/emulated/0/Download/$fileName');
          file.writeAsBytes(fileData.sublist(0, fileSize));
          print('文件保存完成: ${file.path}');
        }
      });
    }
  }

  // 断开连接
  void disconnect() {
    _connection?.close();
  }
}