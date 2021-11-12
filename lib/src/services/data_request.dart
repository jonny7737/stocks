import 'package:flutter/material.dart';
import 'package:iex/iex.dart';
import 'package:stocks/src/models/bus_events.dart';

import '../globals.dart';

/// Singleton service for access to IEX DataRequestProcessor
///
class DataRequestService extends ChangeNotifier {
  static DataRequestService? _instance;

  DataRequestService._internal() {
    appEventBus.fire(Notify('Data Request Service is available.'));
  }

  factory DataRequestService() => _instance ??= DataRequestService._internal();

  final DataRequestProcessor _drp = DataRequestProcessor(serviceEndPoint);

  Future<String> get nextMarketOpen => _drp.nextMarketOpen();

  Future<double> currentPrice({required String symbol}) async {
    return await _drp.currentPrice(symbol: symbol);
  }

  Future<double> previousClose({required String symbol}) {
    return _drp.previousClose(symbol: symbol);
  }

  void requestData(symbol) {
    _drp.requestData([
      {'fn': 'price', 'symbol': symbol}
    ]);
  }

  Future<List<ChartData>> intraDay(String symbol) async {
    return await _drp.intraDay(symbol);
  }
}
