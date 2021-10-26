import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/controllers/price_change.dart';
import 'package:stocks/src/controllers/selected_item.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:timezone/data/latest.dart';

import '/src/globals.dart';
import 'src/app.dart';
import 'src/controllers/navigation.dart';
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
  appEventBus.fire(Notify(EventStatus.success, 'Event bus online...'));

  currentPrices = CurrentPrices();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MultiProvider(
    providers: [
      ListenableProvider<NavigationController>(
        create: (_) => NavigationController(),
      ),
      ListenableProvider<AppRootController>(
        create: (_) => AppRootController(),
      ),
      ListenableProvider<PriceChangeController>(
        create: (_) => PriceChangeController(),
      ),
      ListenableProvider<SelectedItemController>(
        create: (_) => SelectedItemController(),
      ),
    ],
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
void eventLog(event) {
  String _now = DateFormat("Hms").format(DateTime.now());
  switch (event.runtimeType) {
    case PriceChange:
      PriceChange e = event;
      // ignore: avoid_print
      print('=:[$_now]  ${e.runtimeType} : ${e.message} - ${e.symbol} : ${e.newPrice}');
      break;
    case PriceChanged:
      PriceChanged e = event;
      // ignore: avoid_print
      print('=:[$_now]  ${e.runtimeType} : ${e.message} - ${e.symbol} : ${e.newPrice}');
      break;
    default:
      BusEvent e = event;
      // ignore: avoid_print
      print('-:[$_now]  ${e.runtimeType} : ${e.message}');
  }
}
