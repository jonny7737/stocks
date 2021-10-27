import 'dart:async';

import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

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

    //  Remove confetti from the screen after 11 seconds.
    Timer(const Duration(seconds: 11), () {
      notifyListeners();
    });
  }

  //  TODO: This is for testing.  Remove after UI implemented.
  void toggleWidget(String widget) {
    switch (widget) {
      case 'one':
        widgetOneVisible = !widgetOneVisible;
        break;
      case 'two':
        widgetTwoVisible = !widgetTwoVisible;
        break;
      case 'three':
        widgetThreeVisible = !widgetThreeVisible;
        break;
      default:
    }
    notifyListeners();
  }

  void showWidget(String widget, bool show) {
    switch (widget) {
      case 'one':
        widgetOneVisible = show;
        break;
      case 'two':
        widgetTwoVisible = show;
        break;
      case 'three':
        widgetThreeVisible = show;
        break;
      default:
    }

    appEventBus.fire(Notify('Widget $widget is Visible: $show'));
    // if (show) {
    notifyListeners();
    // }
  }

  //  TODO: Remove after testing is complete.
  void showNextWidget() {
    switch (activeWidget) {
      case 1:
        activeWidget = 2;
        showWidget('one', false);
        showWidget('two', true);
        break;
      case 2:
        activeWidget = 3;
        showWidget('two', false);
        showWidget('three', true);
        break;
      case 3:
        activeWidget = 1;
        showWidget('three', false);
        showWidget('one', true);
        break;
      default:
    }
    notifyListeners();
  }
}
