import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class PopSoundController extends ChangeNotifier {
  PopSoundController() {
    // Listen for PortfolioUpdated events
    appEventBus.on<PlaySound>().listen((event) {
      if (event.soundFile == 'pop') notifyListeners();
    });
  }
}
