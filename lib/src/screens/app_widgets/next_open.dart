import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/portfolio_updated.dart';
import 'package:stocks/src/services/portfolio.dart';

class NextOpen extends StatelessWidget {
  NextOpen({Key? key}) : super(key: key);

  ///  Portfolio service reference
  final Portfolio portfolio = Portfolio();

  @override
  Widget build(BuildContext context) {
    Provider.of<PortfolioUpdateController>(context);
    return Column(
      children: [
        Text(portfolio.nextOpen.toString()),
        if (portfolio.marketIsOpen) Text(portfolio.nextClose.toString()),
        if (!portfolio.marketIsOpen) const Text('Market Closed'),
      ],
    );
  }
}
