import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/price_change.dart';

class DummyPrices extends StatelessWidget {
  const DummyPrices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PriceChangeController pcc = Provider.of<PriceChangeController>(context);
    return SizedBox(
      width: 150,
      height: 250,
      child: ListView.separated(
        itemCount: pcc.symbols.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return Text('${pcc.symbols[index]}  ${pcc.prices[index]}');
        },
      ),
    );
  }
}
