import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/controllers/portfolio_updated.dart';
import 'package:stocks/src/screens/app_widgets/confetti.dart';
import 'package:stocks/src/screens/app_widgets/current_position.dart';
import 'package:stocks/src/screens/app_widgets/dummy_prices.dart';
import 'package:stocks/src/screens/app_widgets/menu.dart';
import 'package:stocks/src/screens/app_widgets/next_open.dart';
import 'package:stocks/src/screens/app_widgets/siren_player.dart';
import 'package:stocks/src/screens/sample_feature/sample_item_details_view.dart';

import '/src/controllers/navigation.dart';
import 'app_widgets/appbar.dart';

/// Displays application content.
class AppRootView extends StatelessWidget {
  const AppRootView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 0.50),
        child: AppBarWidget(),
      ),
      body: Center(
        child: getBody(context),
      ),
    );
  }
}

/// Simple navigation controller for a single page application.
///
/// Navigation is used to select scaffold body content.
Widget getBody(context) {
  NavigationController navigation = Provider.of<NavigationController>(context);
  Widget body = Container();

  /// Simple navigation controller for a single page application.
  /// Navigation is used to select scaffold body content.
  switch (navigation.currentScreen) {
    case '/':
      body = const MainBody();
      break;
    case '/sample_item':
      body = const SampleItemDetailsView();
      break;
  }
  return body;
}

/// This is the base widget of the main screen content.
/// Each screen will have a base widget with similar structure but different content.
class MainBody extends StatelessWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRootController rootController = context.watch<AppRootController>();
    context.watch<PortfolioUpdateController>();
    return Stack(
      alignment: Alignment.center,
      textDirection: TextDirection.rtl,
      children: [
        // **********************************
        //  Current Prices
        if (rootController.doDummyPrices) const Positioned(top: 10, left: 5, child: DummyPrices()),

        // **********************************
        //  Siren Player
        const Positioned(top: 0, child: SirenPlayer()),

        // **********************************
        //  Siren Player
        const Positioned(top: 0, child: CurrentPosition()),

        // **********************************
        //  Next open date - time
        const Positioned(top: 10, right: 10, child: NextOpen()),

        // **********************************
        //  Menu
        if (rootController.menuVisible)
          const Positioned(top: 0, right: 5, child: SizedBox(width: 275, child: MenuWidget())),

        // **********************************
        //  Confetti
        if (rootController.confettiActive) const AppConfettiWidget(),
      ],
    );
  }
}
