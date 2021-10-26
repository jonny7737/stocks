import 'package:flutter/material.dart';

class UnknownRouteView extends StatelessWidget {
  const UnknownRouteView({Key? key}) : super(key: key);

  static const routeName = '/unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
      ),
      body: const Center(
        child: Text(
          'ERROR: Unknown route',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
