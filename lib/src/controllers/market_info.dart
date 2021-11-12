import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class MarketInfoController extends ChangeNotifier {
  MarketInfoController() {
    // Listen for PortfolioUpdated events
    appEventBus.on<MarketInfoUpdated>().listen((event) {
      notifyListeners();
    });
  }
}
