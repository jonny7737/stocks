import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/controllers/navigation.dart';
import '/src/controllers/selected_item.dart';
import '/src/screens/settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    Key? key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  }) : super(key: key);

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    NavigationController navigation = Provider.of<NavigationController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              navigation.changeScreen(SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text('SampleItem ${item.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                Provider.of<SelectedItemController>(context, listen: false).select(index);
                navigation.changeScreen(SampleItemDetailsView.routeName);
              });
        },
      ),
    );
  }
}
