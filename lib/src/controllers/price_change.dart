import 'package:flutter/material.dart';
import 'package:stocks/src/repositories/current_prices.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class PriceChangeController with ChangeNotifier {
  final CurrentPrices _cp = CurrentPrices();

  PriceChangeController() {
    // Listen for PriceChanged events [from CurrentPrices repository]
    appEventBus.on<PriceChanged>().listen((event) {
      notifyListeners();
    });
  }

  List<String> get symbols => _cp.listOfSymbols;
  List<double> get prices => _cp.listOfPrices;
  double currentPrice(String symbol) => _cp.price(symbol);
  bool watching(String symbol) => _cp.stocks[symbol]!.watch ?? false;
  double quantity(String symbol) => _cp.stocks[symbol]!.quantity;
  double costPerShare(String symbol) =>
      double.parse((_cp.stocks[symbol]!.cost / _cp.stocks[symbol]!.quantity).toStringAsFixed(3));
  double watchingCost(symbol) =>
      watching(symbol) ? double.parse(_cp.stocks[symbol]!.cost.toStringAsFixed(3)) : 0.0;
}
