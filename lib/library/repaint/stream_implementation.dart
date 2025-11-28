import 'dart:async';
import 'package:flutter/material.dart';
import 'stock.dart';
import 'stock_service.dart';

/// Stream: 适合需要复杂数据流操作（过滤、转换等），或有多个独立组件需要监听同一数据源
/// 关键方法说明：
/// StreamController<T>.broadcast()	  创建广播流控制器，允许多个监听器
/// streamController.stream	          获取数据流供外部订阅
/// streamController.add(data)	      向流中添加新数据，触发监听器更新
/// StreamBuilder()	                  UI组件，自动监听流数据变化并重建
/// Timer.periodic()	                定时器，用于周期性触发数据更新、

class StreamStockManager {
  // 1. 创建 StreamController
  final _stockStreamController = StreamController<List<Stock>>.broadcast();
  Timer? _timer;

  // 2. 暴露 Stream 供外部订阅
  Stream<List<Stock>> get stockStream => _stockStreamController.stream;
  // 3. 启动定时更新
  void startUpdates() {
    // 初始数据
    _stockStreamController.add(StockService.generateMockStockData());

    // 每秒更新
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final updatedStocks = StockService.generateMockStockData();
      _stockStreamController.add(updatedStocks); // 4. 发送新数据
    });
  }

  void stopUpdates() {
    _timer?.cancel();
  }

  void dispose() {
    stopUpdates();
    _stockStreamController.close();
  }
}

class StreamImplementation extends StatefulWidget {
  const StreamImplementation({super.key});

  @override
  State createState() => _StreamImplementationState();
}

class _StreamImplementationState extends State<StreamImplementation> {
  final StreamStockManager _manager = StreamStockManager();

  @override
  void initState() {
    super.initState();
    _manager.startUpdates();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream + StreamBuilder 实现'),
        backgroundColor: Colors.blue,
      ),
      // 5. UI层监听数据变化
      body: StreamBuilder<List<Stock>>(
        stream: _manager.stockStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('暂无数据'));
          }

          final stocks = snapshot.data!;
          // 6. 根据数据构建UI
          return _buildStockList(stocks);
        },
      ),
    );
  }

  Widget _buildStockList(List<Stock> stocks) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return _StockItem(stock: stock);
      },
    );
  }
}

class _StockItem extends StatelessWidget {
  final Stock stock;

  const _StockItem({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  stock.name,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${stock.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${stock.change.toStringAsFixed(2)} (${isPositive ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%)',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}