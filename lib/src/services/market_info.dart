import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/services/data_request.dart';
import 'package:stocks/src/services/utils.dart';
import 'package:timezone/standalone.dart';

import '../globals.dart';

/// Singleton service for Market information
///
///   -
///
///   Market open: TZDateTime
///
///   Market close: TZDateTime
///
///   Market is open: bool
///
///   OK to query IEX: bool
///

class MarketInfo extends ChangeNotifier {
  static MarketInfo? _instance;

  MarketInfo._internal() {
    // _init();
  }

  factory MarketInfo() => _instance ??= MarketInfo._internal();

  final DataRequestService _drs = DataRequestService();

  Future<void> init() async {
    await _setNextOpen();
    await _setNextClose();
    _ready = true;
    if (_marketCheckTimer == null) _marketCheck();
  }

  TZDateTime nextOpen = TZDateTime(eastern, 0);
  TZDateTime nextClose = TZDateTime(eastern, 0);
  bool _ready = false;

  bool get marketIsOpen => _now.isAfter(nextOpen) && _now.isBefore(nextClose);

  bool get okToQueryIEX =>
      _ready &&
      _now.isAfter(nextOpen.subtract(const Duration(minutes: 10))) &&
      _now.isBefore(nextClose.add(const Duration(minutes: 15)));

  /// Getter now returns TZDateTime.now(eastern)
  TZDateTime get _now => TZDateTime.now(eastern);
  Timer? _marketCheckTimer;

  void _notify() => appEventBus.fire(MarketInfoUpdated('Market information updated'));

  void _marketCheck() {
    if (_marketCheckTimer == null) {
      _marketCheckTimer = Timer.periodic(const Duration(seconds: 2), checkMarketOC);
    } else {
      _marketCheckTimer!.cancel();
      _marketCheckTimer = Timer.periodic(const Duration(minutes: 5), checkMarketOC);
    }
  }

  int _marketCheckCounter = 0;
  Future<void> checkMarketOC(_) async {
    if (_marketCheckCounter == 2) {
      _marketCheckCounter++;
      _marketCheck();
      return;
    }
    if (_marketCheckCounter < 4) _marketCheckCounter++;
    await _setNextOpen();
    await _setNextClose();
    _notify();
  }

  Future<void> _setNextOpen() async {
    String open = await _drs.nextMarketOpen;
    nextOpen = TZDateTime.from(openDate(open), eastern).add(const Duration(hours: 8, minutes: 30));
    if (_now.weekday <= 5) {
      nextOpen =
          TZDateTime(eastern, _now.year, _now.month, _now.day, nextOpen.hour, nextOpen.minute);
    }

    // open = DateFormat("yyyy-MM-dd HH:mm").format(nextOpen);
  }

  Future<void> _setNextClose() async {
    var now = TZDateTime.now(central);
    if (now.day <= nextOpen.day) {
      nextClose = TZDateTime(eastern, now.year, now.month, now.day, 16, 00, 00);
    }
  }

  Future<bool> get marketInfoIsReady async {
    while (!_ready) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return Future.value(_ready);
  }
}
