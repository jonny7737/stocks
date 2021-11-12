import 'dart:async';

import 'package:flutter/material.dart';

class AppRootController extends ChangeNotifier {
  bool menuVisible = false;
  bool confettiActive = false;
  bool doDummyPrices = true;

  bool widgetOneVisible = true;
  bool widgetTwoVisible = false;
  bool widgetThreeVisible = false;

  int activeWidget = 1;

  void toggleDummyPrices() {
    doDummyPrices = !doDummyPrices;
    toggleMenu();
  }

  /// Show / Hide application menu.
  void toggleMenu() {
    menuVisible = !menuVisible;
    // appEventBus.fire(Notify(EventStatus.success, 'Menu toggled: $menuVisible'));
    notifyListeners();
  }

  /// Activate Confetti widget and trigger widget tree rebuild.
  ///
  /// Default play time is 10 seconds.
  ///
  /// Remove Confetti widget from screens after 11 seconds.
  void throwConfetti() {
    confettiActive = true;
    notifyListeners();

    //  Widget rebuild after 0.5 seconds will remove confetti from the screen.
    Timer(const Duration(milliseconds: 500), () {
      confettiActive = false;
    });

    //  Remove confetti from the screen after 12seconds.
    Timer(const Duration(seconds: 12), () {
      notifyListeners();
    });
  }
}
