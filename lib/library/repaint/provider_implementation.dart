import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock.dart';
import 'stock_service.dart';


/// Provider: 大型应用，需要良好的架构和可测试性，状态逻辑复杂, 性能较高（选择性重建）
/*
关键方法说明：
with ChangeNotifier	      混入变更通知能力
notifyListeners()	        通知所有监听者数据已变更
ChangeNotifierProvider()	在 widget 树中提供 ChangeNotifier 实例
Consumer<T>()	            UI组件，监听指定的 Provider 并重建
Provider.of<T>(context)	  另一种获取 Provider 的方式
 */

// 1. 创建继承 ChangeNotifier 的数据类
class StockProvider with ChangeNotifier {
  // 2. 提供数据访问接口
  List<Stock> _stocks = [];
  Timer? _updateTimer;

  List<Stock> get stocks => _stocks;

  bool get isUpdating => _updateTimer != null;

  // 5. 启动定时更新
  void startUpdates() {
    if (_updateTimer != null) return;

    // 初始数据
    _stocks = StockService.generateMockStockData();
    notifyListeners();

    // 每秒更新
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateStockData();
    });
  }

  void stopUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
    notifyListeners();// 4. 通知所有监听者
  }

  // 3. 更新数据的方法
  void _updateStockData() {
    final updatedStocks = StockService.generateMockStockData();
    _stocks = updatedStocks;
    notifyListeners(); // 4. 通知所有监听者
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}

class ProviderImplementation extends StatelessWidget {
  const ProviderImplementation({super.key});

  @override
  Widget build(BuildContext context) {
    // 6. 在应用顶层提供 Provider
    return ChangeNotifierProvider(
      create: (_) => StockProvider()..startUpdates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider + ChangeNotifier 实现'),
          backgroundColor: Colors.orange,
          actions: [
            Consumer<StockProvider>(// 7. UI层消费数据
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(provider.isUpdating ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (provider.isUpdating) {
                      provider.stopUpdates();
                    } else {
                      provider.startUpdates();
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<StockProvider>(// 7. UI层消费数据
          builder: (context, provider, child) {
            if (provider.stocks.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return _buildStockList(provider.stocks);
          },
        ),
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
            color: Colors.grey.withOpacity(0.2),
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