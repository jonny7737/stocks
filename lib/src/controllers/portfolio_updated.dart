import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class PortfolioUpdateController extends ChangeNotifier {
  PortfolioUpdateController() {
    // Listen for PortfolioUpdated events
    appEventBus.on<PortfolioUpdated>().listen((event) {
      notifyListeners();
    });
  }
}
