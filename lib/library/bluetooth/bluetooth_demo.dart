import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'bluetooth_serial.dart';

class BluetoothFileTransferPage extends StatefulWidget {
  @override
  _BluetoothFileTransferPageState createState() => _BluetoothFileTransferPageState();
}

class _BluetoothFileTransferPageState extends State<BluetoothFileTransferPage> {
  final BluetoothFileTransfer _bluetooth = BluetoothFileTransfer();
  List<BluetoothDevice> _devices = [];
  bool _isScanning = false;
  BluetoothDevice? _connectedDevice;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _bluetooth.enableBluetooth();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    List<BluetoothDevice> devices = await _bluetooth.discoverDevices();

    setState(() {
      _devices = devices;
      _isScanning = false;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    bool connected = await _bluetooth.connectToDevice(device);

    if (connected) {
      setState(() {
        _connectedDevice = device;
      });
      _bluetooth.startListening(); // 开始监听接收
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已连接到 ${device.name}'))
      );
    }
  }

  void _sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      try {
        await _bluetooth.sendFile(file);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('文件发送成功'))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('文件发送失败: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('蓝牙文件传输'),
        actions: [
          if (_connectedDevice != null)
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: _sendFile,
            )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isScanning ? null : _startScan,
              child: _isScanning
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text('扫描设备'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _devices[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(device.name ?? '未知设备'),
                    subtitle: Text(device.address),
                    trailing: _connectedDevice?.address == device.address
                        ? Icon(Icons.check, color: Colors.green)
                        : ElevatedButton(
                      onPressed: () => _connectToDevice(device),
                      child: Text('连接'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}