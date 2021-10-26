import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class NavigationController extends ChangeNotifier {
  String currentScreen = '/';

  void changeScreen(String nextScreen) {
    appEventBus.fire(Navigation(
      EventStatus.in_process,
      'Navigation request: $currentScreen => $nextScreen',
    ));
    currentScreen = nextScreen;
    notifyListeners();
  }
}
