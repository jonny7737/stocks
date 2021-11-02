import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/app_root.dart';
import 'package:stocks/src/controllers/new_price_indicator.dart';

import '/src/controllers/navigation.dart';
import '../../globals.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NavigationController>(context);

    return Stack(
      children: <Widget>[
        // AppBar background with drag and double tap support
        Positioned.fill(
          child: GestureDetector(
            onTapDown: (_) {
              appWindow.startDragging();
            },
            onDoubleTap: () {
              appWindow.maximizeOrRestore();
            },
            child: const Material(
              elevation: 10.0,
              color: Colors.black87,
              // color: Color.fromARGB(255, 35, 35, 79),
            ),
          ),
        ),

        // AppBar title
        const Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Text(
                appTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),

        // Time to open clock
        // if (useProvider(appViewModelProvider).appBarWidth != 0)
        //   Positioned(
        //     top: 3,
        //     right: context.read(appViewModelProvider).appBarWidth / 6.0,
        //     child: IgnorePointer(child: Column(children: [const TimeToOpenWidget()])),
        //   ),

        //  AppBar menu widget
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Center(
            child: IconButton(
              padding: const EdgeInsets.all(0),
              color: Colors.white,
              icon: const Icon(Icons.menu, size: 20),
              onPressed: () {
                // context.read(appViewModelProvider).toggleMenu;
                // navigation.changeScreen(SampleItemDetailsView.routeName);
                Provider.of<AppRootController>(context, listen: false).toggleMenu();
              },
            ),
          ),
        ),

        // New price indicator
        Positioned(
          top: 0,
          bottom: 0,
          right: 200,
          child: Consumer(
            builder: (context, watch, child) {
              Provider.of<NewPriceIndicatorController>(context);
              return Text(context.read<NewPriceIndicatorController>().indicator);
            },
          ),
        ),

        if (Provider.of<NavigationController>(context, listen: false).currentScreen != '/')
          // AppBar back button
          Positioned(
            top: 0,
            bottom: 0,
            left: 75,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              onPressed: () {
                Provider.of<NavigationController>(context, listen: false).changeScreen('/');
              },
            ),
          ),
      ],
    );
  }
}
