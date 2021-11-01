import 'package:flutter/material.dart';

import '/src/globals.dart';

/// Toggle sound effects and notify listeners.
class SoundController extends ChangeNotifier {
  toggleSound(bool s) {
    soundEnabled = s;
    notifyListeners();
  }
}
