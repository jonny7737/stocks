import 'package:stocks/src/globals.dart';
import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/models/todays_data.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/repositories/daily_pl.dart';
import 'package:stocks/src/services/data_request.dart';
import 'package:stocks/src/services/market_info.dart';
import 'package:timezone/standalone.dart';

class TodaysChartViewModel {
  final DataRequestService _drs = DataRequestService();
  final CurrentPrices _cpr = CurrentPrices();
  final DailyPL _pl = DailyPL();

  late TZDateTime? xMin;
  late double maxY;
  late double minY;
  late double lastClose;
  List<TodaysData> get td => _pl.td;

  TodaysChartViewModel() {
    _pl.check();
    appEventBus.fire(NewMaxValue(-double.infinity));
    appEventBus.fire(PositionChanged());
    xMin = MarketInfo().nextOpen.subtract(const Duration(minutes: 1));
    minY = _pl.yMinimum;
    maxY = _pl.yMaximum;
    lastClose = 0.0;

    _init();

    appEventBus.on<UpdatePLHistory>().listen((event) {
      _update();
    });
  }

  double dRound(double value, {int digits = 3}) {
    return double.parse(value.toStringAsFixed(digits));
  }

  Future<void> _init() async {
    lastClose = 0.0;
    for (var symbol in _cpr.iOwnThese) {
      double _previousClose = await _drs.previousClose(symbol: symbol);
      lastClose += _previousClose * _cpr.quantity(symbol);
    }
    lastClose = dRound(lastClose - _cpr.positionCost());
    appEventBus.fire(Notify('Position at last close: $lastClose'));
    _update();
  }

  void _update() {
    minY = dRound(_pl.yMinimum * 1.002, digits: 0);
    maxY = dRound(_pl.yMaximum * 0.995, digits: 0);
  }

  setDLO(int markerPos) {}
}
