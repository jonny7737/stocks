import 'package:flutter/material.dart';
import 'package:stocks/src/repositories/current_prices.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class PriceChangeController extends ChangeNotifier {
  final CurrentPrices _cp = CurrentPrices();

  PriceChangeController() {
    // Listen for PriceChanged events [from CurrentPrices repository]
    appEventBus.on<PriceChanged>().listen((event) {
      notifyListeners();
    });
  }

  List<String> get symbols => _cp.prices.keys.toList();
  List<double> get prices => _cp.prices.values.toList();
}
