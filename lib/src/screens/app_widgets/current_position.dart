import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/portfolio_updated.dart';
import 'package:stocks/src/controllers/price_change.dart';
import 'package:stocks/src/services/portfolio.dart';

class CurrentPosition extends StatelessWidget {
  const CurrentPosition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///  Portfolio service reference
    final Portfolio portfolio = Portfolio();

    Provider.of<PortfolioUpdateController>(context);

    const TextStyle ts = TextStyle(color: Colors.black);

    return Container(
      width: 500,
      height: 200,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [BoxShadow(blurRadius: 5)]),
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Stack(
        children: [
          //  Title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
                child: InkWell(
              onDoubleTap: () {
                portfolio.notify('Current Position double tap');
              },
              child: Text('Current Position',
                  style: ts.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
            )),
          ),

          //  Deposits - Withdrawals
          Positioned(
              top: 2,
              child: Consumer(
                builder: (context, watch, child) {
                  var p = portfolio;
                  return Text(
                    NumberFormat.simpleCurrency().format(p.startingBalance),
                    style: ts,
                  );
                },
              )),

          //  Available cash
          Positioned(
              top: 25,
              child: Column(
                children: [
                  const Text('Available cash', style: ts),
                  Consumer(
                    builder: (context, watch, child) {
                      var cash = portfolio.cashOnHand;
                      return Text(NumberFormat.simpleCurrency().format(cash),
                          style: ts.copyWith(fontWeight: FontWeight.bold));
                    },
                  ),
                ],
              )),

          //  Current holdings
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text('Current Holdings', style: ts),
                  Consumer(
                    builder: (context, watch, child) {
                      Provider.of<PriceChangeController>(context);
                      var v = portfolio.currentValue;
                      return Text(
                        NumberFormat.simpleCurrency().format(v),
                        style: ts.copyWith(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          //     //  Gain / loss
          Positioned(
            top: 25,
            right: 10,
            child: Center(
              child: Column(
                children: [
                  const Text('Gain (loss)', style: ts),
                  Consumer(
                    builder: (context, watch, child) {
                      Provider.of<PriceChangeController>(context);
                      var pl =
                          portfolio.startingBalance - portfolio.cashOnHand - portfolio.currentValue;
                      if (pl <= 0) {
                        return Text(
                          NumberFormat.simpleCurrency().format(pl),
                          style: ts.copyWith(fontWeight: FontWeight.bold),
                        );
                      }

                      return Text(
                        '(${NumberFormat.simpleCurrency().format(pl)})',
                        style: ts.copyWith(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          //  Gain / loss percent
          Positioned(
            top: 0,
            right: 0,
            child: Center(
              child: Consumer(
                builder: (context, watch, child) {
                  Provider.of<PriceChangeController>(context);
                  var v = portfolio.currentValue;
                  var i = portfolio.currentInvestment;
                  double percent = (v - i) / (i);
                  if (v > i) {
                    return Text(
                      NumberFormat.decimalPercentPattern(decimalDigits: 2).format(percent),
                      style: ts.copyWith(fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward_sharp,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 3),
                        if (percent.isNaN) const SizedBox(width: 37),
                        if (!percent.isNaN)
                          Text(
                            NumberFormat.decimalPercentPattern(decimalDigits: 2)
                                .format(percent.abs()),
                            style: ts.copyWith(fontWeight: FontWeight.bold),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),

          //  Today at a glance
          // Positioned(top: 60, bottom: 0, left: 0, right: 0, child: TodayChartWidget()),
        ],
      ),
    );
  }
}
