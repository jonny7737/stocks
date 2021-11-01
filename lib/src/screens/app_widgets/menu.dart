import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/navigation.dart';
import 'package:stocks/src/controllers/sound_enable.dart';
import 'package:stocks/src/globals.dart';

import '/src/controllers/app_root.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle ts = const TextStyle(color: Colors.black);
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: const [BoxShadow(blurRadius: 5)]),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          //  Grid view of Table Data for Today's Data
          InkWell(
            child: Text(
              "Today's Data Grid",
              style: ts.copyWith(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.read<AppRootController>().toggleMenu();
              if (context.read<NavigationController>().currentScreen != '/sample_item') {
                context.read<NavigationController>().changeScreen('/sample_item');
              }
            },
          ),
          const Divider(color: Colors.grey, height: 5),

          //  Positions and Watches
          InkWell(
            child: Text(
              'Positions & Watches',
              style: ts.copyWith(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.read<AppRootController>().toggleDummyPrices();
            },
          ),
          const Divider(color: Colors.grey, height: 5),

          //  AutoHide Activity Widget
          Center(
            child: Container(
              margin: const EdgeInsets.all(0),
              child: Consumer(builder: (context, watch, child) {
                return CheckboxListTile(
                  value: true,
                  checkColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  // activeColor: Colors.white54,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Auto Hide Activity Log',
                      style: ts.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                  // ignore: avoid_print
                  onChanged: (bool? newValue) => print('AutoHide'),
                  // context.read(appViewModelProvider).toggleAutoHideActivityWidget,
                );
              }),
            ),
          ),

          const Divider(color: Colors.grey, height: 5),

          //  Activity Log
          InkWell(
            child: Text(
              'Activity Log',
              style: ts.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            onTap: () {
              // context.read(appViewModelProvider).toggleActivityWidget();
              context.read<AppRootController>().toggleMenu();
              context.read<AppRootController>().throwConfetti();
            },
          ),

          const Divider(color: Colors.grey, height: 5),

          //  Enable / disable sound effects
          Center(
            child: Container(
              margin: const EdgeInsets.all(0),
              child: Consumer(builder: (context, watch, child) {
                var sc = Provider.of<SoundController>(context);
                return CheckboxListTile(
                  value: soundEnabled,
                  checkColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  // activeColor: Colors.white54,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Toggle sound effects',
                      style: ts.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                  onChanged: (bool? newValue) {
                    sc.toggleSound(newValue ?? false);
                  },
                  // context.read(appViewModelProvider).toggleAutoHideActivityWidget,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
