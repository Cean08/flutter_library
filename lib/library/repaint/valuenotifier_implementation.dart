// lib/implementations/valuenotifier_implementation.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'stock.dart';
import 'stock_service.dart';

/// ValueNotifier: 简单的状态管理，组件数量不多，追求轻量级解决方案
/// 关键方法说明：
/// ValueNotifier<T>(initialValue)	创建可监听的值容器
/// valueNotifier.value	            获取或设置值，设置时会自动通知监听器
/// ValueListenableBuilder()	      UI组件，监听 ValueNotifier 变化并重建
/// valueListenable.addListener()	  手动添加监听器（ValueListenableBuilder 内部使用）

class ValueNotifierStockManager {
  // 1. 创建 ValueNotifier
  final ValueNotifier<List<Stock>> _stocks = ValueNotifier([]);
  Timer? _timer;

  // 2. 暴露 ValueListenable 供外部监听
  ValueListenable<List<Stock>> get stocksListenable => _stocks;

  // 3. 启动定时更新
  void startUpdates() {
    // 初始数据
    _stocks.value = StockService.generateMockStockData();

    // 每秒更新
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final updatedStocks = StockService.generateMockStockData();
      _stocks.value = updatedStocks; // 4. 更新值并通知监听器
    });
  }

  void stopUpdates() {
    _timer?.cancel();
  }

  void dispose() {
    stopUpdates();
  }
}

class ValueNotifierImplementation extends StatefulWidget {
  const ValueNotifierImplementation({super.key});

  @override
  State createState() => _ValueNotifierImplementationState();
}

class _ValueNotifierImplementationState extends State<ValueNotifierImplementation> {
  final ValueNotifierStockManager _manager = ValueNotifierStockManager();

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
        title: const Text('ValueNotifier + ValueListenableBuilder 实现'),
        backgroundColor: Colors.green,
      ),
      // 5. UI层监听数据变化
      body: ValueListenableBuilder<List<Stock>>(
        valueListenable: _manager.stocksListenable,
        builder: (context, stocks, child) {
          if (stocks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
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

// 复用相同的 StockItem widget
class _StockItem extends StatelessWidget {
  final Stock stock;

  const _StockItem({super.key, required this.stock});

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