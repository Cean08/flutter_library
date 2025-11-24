import 'dart:math';
import 'stock.dart';

class StockService {
  static final List<Stock> _initialStocks = [
    Stock(symbol: 'AAPL', name: 'Apple Inc.', price: 150.0, change: 0.0, changePercent: 0.0),
    Stock(symbol: 'GOOGL', name: 'Alphabet Inc.', price: 2800.0, change: 0.0, changePercent: 0.0),
    Stock(symbol: 'MSFT', name: 'Microsoft Corp.', price: 300.0, change: 0.0, changePercent: 0.0),
    Stock(symbol: 'TSLA', name: 'Tesla Inc.', price: 900.0, change: 0.0, changePercent: 0.0),
    Stock(symbol: 'AMZN', name: 'Amazon.com Inc.', price: 3300.0, change: 0.0, changePercent: 0.0),
  ];

  static List<Stock> generateMockStockData() {
    final random = Random();
    return _initialStocks.map((stock) {
      final change = (random.nextDouble() - 0.5) * 10;
      final newPrice = (stock.price + change).clamp(1.0, double.infinity);
      final changePercent = (change / stock.price) * 100;

      return stock.copyWith(
        price: double.parse(newPrice.toStringAsFixed(2)),
        change: double.parse(change.toStringAsFixed(2)),
        changePercent: double.parse(changePercent.toStringAsFixed(2)),
      );
    }).toList();
  }
}