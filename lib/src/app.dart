import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stocks/src/screens/app_root.dart';
import 'package:stocks/src/services/portfolio.dart';

import 'screens/settings/settings_controller.dart';

/// The Widget that configures this application.
class StocksApp extends StatelessWidget {
  StocksApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  //  TODO: Remove this
  // final DummyPricePumper dpc = DummyPricePumper()..startRunning();

  /// Initialize Portfolio service
  final Portfolio portfolio = Portfolio();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Remove that goofy DEBUG banner.
          debugShowCheckedModeBanner: false,

          restorationScopeId: 'app',

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          home: const AppRootView(),
        );
      },
    );
  }
}
