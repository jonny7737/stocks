import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/new_price_indicator.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/repositories/daily_pl.dart';
import 'package:stocks/src/services/market_info.dart';
import 'package:stocks/src/services/sound_manager.dart';
import 'package:timezone/data/latest.dart';

import '/src/globals.dart';
import 'src/app.dart';
import 'src/models/bus_events.dart';
import 'src/screens/settings/settings_controller.dart';
import 'src/screens/settings/settings_service.dart';

late CurrentPrices currentPrices;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();

  // Print all events
  //  TODO: Add event logging level configuration to SettingsController
  appEventBus.on().listen(eventLog);
  appEventBus.fire(Notify('Event bus online...'));

  //  Ensure Market info next open and next close are initialized.
  await MarketInfo().init();
  currentPrices = CurrentPrices();
  SoundManager();
  NewPriceIndicatorController();
  DailyPL();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MultiProvider(
    providers: providers,
    child: StocksApp(settingsController: settingsController),
  ));

  doWhenWindowReady(() {
    const initialSize = Size(windowWidth, windowHeight);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.title = appTitle;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

// Print all events.
// TODO: Check SettingsController for log level and process accordingly
void eventLog(e) {
  if (e.logIt == false) return;
  String _now = DateFormat("Hms").format(DateTime.now());
  String message = '[$_now]  ${e.runtimeType}';
  switch (e.runtimeType) {
    //  Filter these messages
    case PlaySound:
      message = '';
      break;
    case UpdatePLHistory:
      message = '';
      break;
    case PriceChange:
      message = '';
      break;
    case PositionChanged:
      message = '';
      break;

    //  Logs to see
    case Transaction:
      message = '-:$message ${e.action}  ${e.symbol} ${e.quantity} ${e.cost} ${e.watch}';
      break;
    case PriceChanged:
      if (currentPrices.watching(e.symbol)) {
        // message = '=:$message[watching] : ${e.message} - ${e.symbol} : ${e.newPrice}';
        message = '';
      } else {
        message = '=:$message           : ${e.message} - ${e.symbol} : ${e.newPrice}';
      }
      break;

    //  Default message format
    default:
      message = '-:$message ${e.message}';
  }
  if (message != '') {
    // ignore: avoid_print
    print(message);
  }
}
