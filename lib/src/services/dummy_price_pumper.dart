import 'dart:async';
import 'dart:math';

import 'package:stocks/src/globals.dart';
import 'package:stocks/src/models/bus_events.dart';

class DummyPricePumper {
  Map<String, double> startingPoint = {
    'aapl': 169.79,
    'msft': 309.50,
    'sft': 6.49,
    'cgc': 13.10,
  };

  bool doDummyPrices = true;
  int currentSymbol = 0;
  Map<String, double> dummyData = {};
  var rnd = Random();

  static const Duration triggerTime = Duration(seconds: 5);
  late Timer t;

  void startRunning() {
    t = Timer.periodic(triggerTime, _priceChange);
  }

  void _priceChange(_) {
    double adj = (rnd.nextInt(199) - 99 ~/ 2) / 100.0;

    double newPrice = startingPoint.values.elementAt(currentSymbol) + adj;
    newPrice = double.parse(newPrice.toStringAsFixed(2));

    appEventBus.fire(PriceChange(EventStatus.in_process, 'New dummy price',
        startingPoint.keys.elementAt(currentSymbol), newPrice));
    currentSymbol++;
    if (currentSymbol == startingPoint.length) t.cancel(); //currentSymbol = 0;
  }
}
