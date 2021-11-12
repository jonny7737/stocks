import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/models/stock.dart';

import '/src/globals.dart';

class CurrentPrices {
  Map<String, double> prices = {};
  Map<String, Stock> stocks = {};

  static CurrentPrices? _instance;

  CurrentPrices._internal() {
    appEventBus.on<PriceChange>().listen((event) {
      updatePrice(event.symbol, event.newPrice);
    });
    appEventBus.fire(Notify('CurrentPrices repository is available'));
  }

  factory CurrentPrices() => _instance ??= CurrentPrices._internal();

  /// PriceChange event callback.
  void updatePrice(String symbol, double newPrice) {
    double price = prices[symbol] ?? 0.0;
    if (price == newPrice) return;
    newPrice = double.parse(newPrice.toStringAsFixed(3));
    double percentChange = (newPrice - price).abs() / price * 100.00;
    if (percentChange == double.infinity) percentChange = 0.0;
    String p = percentChange.toStringAsFixed(3);
    String message = '';
    if (price < newPrice) {
      message = '↑ $p%';
    } else {
      message = '↓ $p%';
    }
    prices[symbol] = newPrice;
    appEventBus.fire(PriceChanged(EventStatus.success, message, symbol, newPrice));

    bool watching = stocks[symbol]!.watch ?? false;
    if (!watching) appEventBus.fire(PlaySound(pop));
  }

  /// List of Symbols not watched followed by symbols watched
  ///   1.  This must match sorting of listOfPrices()
  List<String> get listOfSymbols {
    List<String> symbols = [];
    stocks.forEach((symbol, stock) {
      if (stock.watch != true) symbols.add(symbol);
    });
    stocks.forEach((symbol, stock) {
      if (stock.watch == true) symbols.add(symbol);
    });
    return symbols;
  }

  /// List of Prices not watched followed by prices watched
  ///   1.  This must match sorting of listOfSymbols()
  List<double> get listOfPrices {
    List<double> _prices = [];
    stocks.forEach((symbol, stock) {
      if (stock.watch != true) _prices.add(price(symbol));
    });
    stocks.forEach((symbol, stock) {
      if (stock.watch == true) _prices.add(price(symbol));
    });
    return _prices;
  }

  List<String> get watchingThese {
    List<String> symbols = [];
    stocks.forEach((symbol, stock) {
      if (stock.watch == true) symbols.add(symbol);
    });
    return symbols;
  }

  List<String> get iOwnThese {
    List<String> symbols = [];
    stocks.forEach((symbol, stock) {
      if (stock.quantity > 0) symbols.add(symbol);
    });
    return symbols;
  }

  double positionValue() {
    double totalValue = 0.0;
    stocks.forEach((key, value) {
      if (value.watch != true) totalValue += (price(key) * value.quantity);
    });
    return double.parse(totalValue.toStringAsFixed(3));
  }

  double positionCost() {
    double totalCost = 0.0;
    stocks.forEach((key, value) {
      if (value.watch != true) {
        totalCost += value.cost;
      }
    });
    return double.parse(totalCost.toStringAsFixed(3));
  }

  /// Return the current price for symbol.
  ///
  /// Returns 0.0 if symbol not found.
  ///
  double price(String symbol) => prices[symbol] ?? 0.0;

  bool watching(String symbol) {
    if (stocks[symbol] == null) {
      return false;
    } else {
      return stocks[symbol]!.watch ?? false;
    }
  }

  double quantity(String symbol) => stocks[symbol]!.quantity;
}
