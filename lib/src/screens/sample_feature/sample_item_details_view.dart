import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/controllers/navigation.dart';
import 'package:stocks/src/screens/app_widgets/confetti.dart';
import 'package:stocks/src/screens/app_widgets/menu.dart';

import '/src/controllers/selected_item.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    if (context.read<NavigationController>().currentScreen != routeName) {
      return const Material();
    }
    int itemIndex = Provider.of<SelectedItemController>(context).selectedItem;

    AppRootController rootController = context.watch<AppRootController>();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              'More Information Here\nfor Item #: $itemIndex',
              textAlign: TextAlign.center,
            ),
          ),

          // **********************************
          //  Menu
          if (rootController.menuVisible)
            const Positioned(top: 0, right: 5, child: SizedBox(width: 275, child: MenuWidget())),

          // **********************************
          //  Confetti
          if (rootController.confettiActive) const AppConfettiWidget(),
        ],
      ),
    );
  }
}
