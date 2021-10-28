import 'package:stocks/src/models/bus_events.dart';

import '/src/globals.dart';

class CurrentPrices {
  Map<String, double> prices = {};

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
    if (prices[symbol] == newPrice) return;
    prices[symbol] = newPrice;
    appEventBus.fire(PriceChanged(EventStatus.success, '', symbol, newPrice));
  }

  /// Return the current price for symbol.
  ///
  /// Returns 0.0 if symbol not found.
  ///
  double price(String symbol) => prices[symbol] ?? 0.0;
}
