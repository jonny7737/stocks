import 'package:flutter/material.dart';
import 'package:stocks/src/globals.dart';
import 'package:stocks/src/models/bus_events.dart';

class MaxValueController with ChangeNotifier {
  double maxValue = -double.infinity;

  MaxValueController() {
    appEventBus.on<NewMaxValue>().listen((event) {
      setValue(event.newValue);
    });
  }

  void setValue(double newValue) {
    maxValue = newValue;
    notifyListeners();
  }
}
