import 'dart:async';
import 'dart:convert';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:io';

class BLEFileTransfer {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  QualifiedCharacteristic? _fileCharacteristic;
  DeviceConnectionState? _connectionState;

  static const String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  static const String FILE_CHARACTERISTIC_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";

  // 请求权限
  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.location.request();
  }

  // 扫描设备
  void startScanning(void Function(DiscoveredDevice) onDeviceFound) {
    _scanSubscription = _ble.scanForDevices(
      withServices: [Uuid.parse(SERVICE_UUID)],
    ).listen(onDeviceFound);
  }

  // 连接设备
  void connectToDevice(String deviceId) {
    _ble.connectToDevice(
      id: deviceId,
      servicesWithCharacteristicsToDiscover: {
        Uuid.parse(SERVICE_UUID): [Uuid.parse(FILE_CHARACTERISTIC_UUID)]
      },
    ).listen(
          (ConnectionStateUpdate update) {
        _connectionState = update.connectionState;

        if (update.connectionState == DeviceConnectionState.connected) {
          _fileCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(SERVICE_UUID),
            characteristicId: Uuid.parse(FILE_CHARACTERISTIC_UUID),
            deviceId: deviceId,
          );
        }
      },
      onError: (Object error) {
        print('连接错误: $error');
      },
    );
  }

  // 发送文件（分块发送）- 修复后的版本
  Future<void> sendFile(File file) async {
    if (_fileCharacteristic == null) {
      print('未找到文件特征');
      return;
    }

    try {
      List<int> fileBytes = await file.readAsBytes();
      String fileName = file.path.split('/').last;

      // 发送文件头 - 修复：转换为 Uint8List
      List<int> header = utf8.encode('FILE:$fileName:${fileBytes.length}');
      await _ble.writeCharacteristicWithResponse(
          _fileCharacteristic!,
          value: Uint8List.fromList(header) // 修复：转换为 Uint8List
      );

      // 分块发送文件数据
      const int chunkSize = 20; // BLE 限制
      for (int i = 0; i < fileBytes.length; i += chunkSize) {
        int end = (i + chunkSize < fileBytes.length) ? i + chunkSize : fileBytes.length;
        List<int> chunk = fileBytes.sublist(i, end);

        await _ble.writeCharacteristicWithoutResponse(
            _fileCharacteristic!,
            value: Uint8List.fromList(chunk) // 修复：转换为 Uint8List
        );
        await Future.delayed(Duration(milliseconds: 10));
      }

      print('文件发送完成');
    } catch (e) {
      print('发送文件错误: $e');
    }
  }

  // 停止扫描
  void stopScanning() {
    _scanSubscription?.cancel();
  }
}