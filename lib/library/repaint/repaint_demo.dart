import 'package:flutter/material.dart';
import 'stream_implementation.dart';
import 'valuenotifier_implementation.dart';
import 'provider_implementation.dart';

class RepaintDemo extends StatefulWidget {
  const RepaintDemo({super.key});

  @override
  State<RepaintDemo> createState() => _RepaintDemoState();
}

class _RepaintDemoState extends State<RepaintDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('高频刷新数据示例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StreamImplementation(),
                  ),
                );
              },
              child: const Text('Stream 实现'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ValueNotifierImplementation(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('ValueNotifier 实现'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProviderImplementation(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Provider 实现'),
            ),
          ],
        ),
      ),
    );
  }
}
