import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/market_info.dart';
import 'package:stocks/src/services/market_info.dart';

class NextOpen extends StatelessWidget {
  const NextOpen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MarketInfo m = MarketInfo();

    Provider.of<MarketInfoController>(context);
    return Column(
      children: [
        Text(m.nextOpen.toString()),
        if (m.marketIsOpen) Text(m.nextClose.toString()),
        if (!m.marketIsOpen) const Text('Market Closed'),
      ],
    );
  }
}
