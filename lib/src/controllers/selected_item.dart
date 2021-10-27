import 'package:flutter/material.dart';

import '/src/globals.dart';
import '/src/models/bus_events.dart';

class SelectedItemController extends ChangeNotifier {
  int selectedItem = -1;

  void select(int itemIndex) {
    appEventBus.fire(Notify('Selected item: $itemIndex'));
    selectedItem = itemIndex;
    notifyListeners();
  }
}
