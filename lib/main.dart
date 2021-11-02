import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/controllers/new_price_indicator.dart';
import 'package:stocks/src/controllers/pop_sound.dart';
import 'package:stocks/src/controllers/portfolio_updated.dart';
import 'package:stocks/src/controllers/price_change.dart';
import 'package:stocks/src/controllers/selected_item.dart';
import 'package:stocks/src/controllers/sound_enable.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/services/sound_manager.dart';
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
  appEventBus.fire(Notify('Event bus online...'));

  currentPrices = CurrentPrices();
  SoundManager();
  NewPriceIndicatorController();

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
      ListenableProvider<PortfolioUpdateController>(
        create: (_) => PortfolioUpdateController(),
      ),
      ListenableProvider<SelectedItemController>(
        create: (_) => SelectedItemController(),
      ),
      ListenableProvider<PopSoundController>(
        create: (_) => PopSoundController(),
      ),
      ListenableProvider<SoundController>(
        create: (_) => SoundController(),
      ),
      ListenableProvider<NewPriceIndicatorController>(
        create: (_) => NewPriceIndicatorController(),
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
      break;
    case PriceChanged:
      bool watching = currentPrices.stocks[event.symbol]!.watch ?? false;
      if (watching) {
        // ignore: avoid_print
        print(
            '=:[$_now]  ${event.runtimeType}[watching] : ${event.message} - ${event.symbol} : ${event.newPrice}');
      } else {
        // ignore: avoid_print
        print(
            '=:[$_now]  ${event.runtimeType}           : ${event.message} - ${event.symbol} : ${event.newPrice}');
      }
      break;

    //  Filter these messages
    case PlaySound:
      break;

    //  Default message format
    default:
      BusEvent e = event;
      // ignore: avoid_print
      print('-:[$_now]  ${e.runtimeType} : ${e.message}');
  }
}
