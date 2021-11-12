import 'dart:async';

import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/models/todays_data.dart';
import 'package:stocks/src/services/cash_balance.dart';
import 'package:stocks/src/services/data_request.dart';
import 'package:timezone/timezone.dart';

import '/src/services/market_info.dart';
import '../globals.dart';
import 'current_prices.dart';

class DailyPL {
  final DataRequestService _drs = DataRequestService();
  final CurrentPrices _cp = CurrentPrices();
  final CashBalance _cb = CashBalance();
  final MarketInfo m = MarketInfo();

  late Timer updateTimer;
  late List<TodaysData> td;
  late TodaysData tdNull;

  static DailyPL? _instance;

  DailyPL._internal() {
    _init();
  }

  factory DailyPL() => _instance ??= DailyPL._internal();

  Future<void> _init() async {
    TZDateTime o = m.nextOpen;
    tdNull = TodaysData(o, o, -double.infinity);
    td = List.filled(1000, tdNull);

    // startMinute = 570 * debugFudge;
    // endMinute = 960 * debugFudge;

    appEventBus.on<UpdatePLHistory>().listen((event) {
      _update();
    });

    appEventBus.on<PriceChanged>().listen((event) {
      _update();
    });

    updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      appEventBus.fire(UpdatePLHistory());
    });

    await backFillTD();
    appEventBus.fire(UpdatePLHistory());
    appEventBus.fire(Notify('Daily P&L repository is available'));
  }

  void check() {}

  double _pl = 0.0;
  double get pl => double.parse(_pl.toStringAsFixed(3));
  double posPL = 0.0;
  double lastClose = 0.0;

  int startMinute = 570;
  int endMinute = 960;

  bool portfolioReady = false;

  double get newPL => _cp.positionValue() + _cb.cashOnHand - _cb.startingBalance;

  _update() {
    double v = _cp.positionValue();
    double c = _cp.positionCost();
    posPL = double.parse((v - c).toStringAsFixed(3));
    if (!m.okToQueryIEX) return;

    var now = TZDateTime.now(eastern);

    var minuteNdx = ((now.hour * 60) + now.minute) - startMinute;
    if (minuteNdx < 0) return;

    _pl = newPL;

    td[minuteNdx + 1] = TodaysData(m.nextOpen, now, posPL);

    appEventBus.fire(PositionChanged());
  }

  int get numTDRecs {
    int numRecs = 0;
    for (var e in td) {
      if (e != tdNull) {
        // print('[$numRecs] $e');
        numRecs++;
      }
    }
    return numRecs;
  }

  double get yMinimum {
    var t = td.where((e) => e.gainLoss != -double.infinity);
    if (t.isEmpty) return 0.0;
    var m = t.reduce((v, e) {
      if (v == tdNull) return tdNull;
      if (e == tdNull) return v;
      return v.gainLoss < e.gainLoss ? v : e;
    });
    return (m.gainLoss - 1).floorToDouble();
  }

  double get yMaximum {
    var t = td.where((e) => e.gainLoss != -double.infinity);
    if (t.isEmpty) return 0.0;
    var m = t.reduce((v, e) {
      if (v == tdNull) return tdNull;
      if (e == tdNull) return v;
      return v.gainLoss > e.gainLoss ? v : e;
    });
    return (m.gainLoss + 1).ceilToDouble();
  }

  double dRound(double value, {int digits = 3}) {
    return double.parse(value.toStringAsFixed(digits));
  }

  bool get willBackFill {
    if (m.marketIsOpen) {
      appEventBus.fire(Notify('Daily P&L data will back fill'));
      return true;
    }
    appEventBus.fire(Notify('Daily P&L data will NOT back fill'));
    return false;
  }

  Future<void> backFillTD() async {
    if (!willBackFill) return;
    while (_cp.stocks.isEmpty) {
      await Future.delayed(const Duration(seconds: 5));
    }

    appEventBus.fire(Notify('Beginning data chart backfill'));

    Map<String, double> lc = {};
    lastClose = 0.0;
    for (var symbol in _cp.iOwnThese) {
      double _previousClose = await _drs.previousClose(symbol: symbol);
      lc[symbol] = _previousClose;
      lastClose += _previousClose * _cp.quantity(symbol);
    }
    lastClose = dRound(lastClose - _cp.positionCost());
    var lcDT = m.nextOpen.subtract(const Duration(minutes: 1));
    td[0] = TodaysData(m.nextOpen, lcDT, lastClose);

    for (var symbol in _cp.iOwnThese) {
      var data = await _drs.intraDay(symbol);
      for (var c in data) {
        var t = c.date!.hour * 60 + c.date!.minute - 570;
        var v1 = c.close ?? -double.infinity;
        var v2 = c.close == -double.infinity ? lc[symbol]! : v1;
        lc[symbol] = v2;
        v2 = v2 * _cp.stocks[symbol]!.quantity;
        td[t + 1] += TodaysData(m.nextOpen, c.date ?? m.nextOpen, v2);
      }
    }
    for (int i = 1; i < td.length; i++) {
      if (td[i] == tdNull) break;
      var tick = td[i].tick.subtract(const Duration(hours: 1));
      tick = TZDateTime.from(tick, eastern);
      td[i] = TodaysData(m.nextOpen, tick, td[i].gainLoss - _cp.positionCost());
      // print('${td[i]}');
    }
    appEventBus.fire(BackfillComplete());
  }
}
