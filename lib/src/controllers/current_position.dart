import 'package:flutter/material.dart';
import 'package:stocks/src/models/bus_events.dart';

import '../globals.dart';

class CurrentPositionController with ChangeNotifier {
  CurrentPositionController() {
    // Listen for BackfillComplete events [from CurrentPrices repository]
    appEventBus.on<PositionChanged>().listen((event) {
      notifyListeners();
    });
  }
}
