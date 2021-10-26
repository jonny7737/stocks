import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/screens/app_widgets/confetti.dart';
import 'package:stocks/src/screens/app_widgets/dummy_prices.dart';
import 'package:stocks/src/screens/app_widgets/menu.dart';
import 'package:stocks/src/screens/sample_feature/sample_item_details_view.dart';

import '/src/controllers/navigation.dart';
import 'app_widgets/appbar.dart';

/// Displays application main content.
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

Widget getBody(context) {
  NavigationController navigation = Provider.of<NavigationController>(context);
  Widget body = Container();
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

class MainBody extends StatelessWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRootController rootController = context.watch<AppRootController>();
    // print('rebuilding MainBody');
    return Stack(
      children: [
        // **********************************
        //  Current Prices
        if (rootController.doDummyPrices) const Positioned(top: 10, left: 5, child: DummyPrices()),

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
