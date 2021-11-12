import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class NewPriceIndicatorController extends ChangeNotifier {
  List indicatorChars = ['-', '\\', '*', '|', '/'];
  int indicatorIndex = 0;

  NewPriceIndicatorController() {
    // Listen for PriceChanged events [from CurrentPrices repository]
    appEventBus.on<PriceChange>().listen((event) {
      indicatorIndex++;
      if (indicatorIndex == indicatorChars.length) indicatorIndex = 0;
      notifyListeners();
    });
  }

  String get indicator => indicatorChars[indicatorIndex];
}
