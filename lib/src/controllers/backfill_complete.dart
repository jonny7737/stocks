import 'package:flutter/material.dart';
import 'package:stocks/src/models/bus_events.dart';

import '../globals.dart';

class BackfillCompleteController extends ChangeNotifier {
  BackfillCompleteController() {
    // Listen for BackfillComplete events [from CurrentPrices repository]
    appEventBus.on<BackfillComplete>().listen((event) {
      notifyListeners();
    });
  }
}
