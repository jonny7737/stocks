import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks/src/controllers/price_change.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/services/data_request.dart';
import 'package:stocks/src/services/portfolio.dart';

// class CardsHashRepo {
//   static int hash = 0;
// }

class CardsWidget extends StatelessWidget {
  const CardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // int rebuildCards = useProvider(rebuildCardsProvider).state;

    // var wlp = context.read(watchListDirtyCountProvider);

    // final Future<List<StockCard>> cardList = useMemoized(() {
    //   var avm = context.read(appViewModelProvider);
    //   return buildStockCardList(avm, a, wlp);
    // }, [CardsHashRepo.hash + rebuildCards]);
    final Future<List<StockCard>> cardList = buildStockCardList();

    return FutureBuilder(
      future: cardList,
      builder: (context, cardSnap) {
        if (cardSnap.hasData) {
          // Future.delayed(const Duration(seconds: 1))
          //     .then((_) => context.read(confettiProvider).state = true);
          List<StockCard> s = cardSnap.data as List<StockCard>;
          return SizedBox(
            width: 230,
            child: AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: s.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 150.0,
                      child: FadeInAnimation(
                        child: s[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Column(
            children: const [
              Text('Loading...', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }

  Future<List<StockCard>> buildStockCardList() async {
    var _cp = CurrentPrices();
    var _drs = DataRequestService();

    List<StockCard> s = [];
    List<String> symbols = _cp.listOfSymbols;

    //  Create portfolio cards first.
    for (int i = 0; i < symbols.length; i++) {
      bool watching = _cp.watching(symbols[i]);
      if (watching) continue;
      String coName = (await _drs.getCoNameBySymbol(symbols[i])).split('-')[0].trim();
      s.add(StockCard(symbol: symbols[i], coName: coName));
    }

    //  Now create watch list cards.
    for (int i = 0; i < symbols.length; i++) {
      bool watching = _cp.watching(symbols[i]);
      if (!watching) continue;
      String coName = (await _drs.getCoNameBySymbol(symbols[i])).split('-')[0].trim();
      s.add(StockCard(symbol: symbols[i], coName: coName));
    }

    // CardsHashRepo.hash = s.hashCode;
    return s;
  }
}

class StockCard extends StatelessWidget {
  const StockCard({Key? key, required this.symbol, required this.coName}) : super(key: key);
  final String symbol;
  final String coName;

  @override
  Widget build(BuildContext context) {
    // TODO:  Add support for tracking price change TODAY

    bool watching = Portfolio().watchingIt(symbol);
    TextStyle ts = const TextStyle(color: Colors.black);
    return InkWell(
      onTap: () {
        // var avm = context.read(appViewModelProvider);
        // avm.symbol = symbol;
        // avm.chartViewActive = true;
        // avm.intraDay = true;
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChartView()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: watching ? Colors.yellow[700] : Colors.yellow,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: const [BoxShadow(blurRadius: 5)]),
        padding: const EdgeInsets.all(4),
        width: 200,
        height: 125,
        child: Column(
          children: [
            HeaderRow(symbol: symbol),
            const SizedBox(height: 5),
            Expanded(
              child: SizedBox(
                child: Text('$symbol: $coName',
                    textAlign: TextAlign.center,
                    style: ts.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2),
              ),
            ),
            const SizedBox(height: 15),
            PricesLabelRow(symbol: symbol),
            const SizedBox(height: 5),
            PricesRow(symbol: symbol),
          ],
        ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  HeaderRow({Key? key, required this.symbol}) : super(key: key);

  late final bool watching;
  late final double iOwn;
  final TextStyle ts = const TextStyle(color: Colors.black);
  final String symbol;

  @override
  Widget build(BuildContext context) {
    iOwn = Portfolio().iOwnIt(symbol);
    watching = Portfolio().watchingIt(symbol);
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        if (!watching && iOwn == iOwn.floor()) Text('Own: ${iOwn.toStringAsFixed(0)}', style: ts),
        if (!watching && iOwn != iOwn.floor()) Text('Own: ${iOwn.toStringAsFixed(4)}', style: ts),
        if (watching) Text('Watching', style: ts),
        if (watching) const Expanded(child: SizedBox()),
        if (!watching) Expanded(child: SizedBox(child: PercentGainLoss(symbol: symbol))),
      ],
    );
  }
}

class PercentGainLoss extends StatelessWidget {
  const PercentGainLoss({Key? key, required this.symbol}) : super(key: key);

  final String symbol;
  final TextStyle ts = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    var pcc = context.read<PriceChangeController>();

    double aPPS = pcc.costPerShare(symbol);
    double cPPS = pcc.currentPrice(symbol);
    double percent = (cPPS - aPPS) / aPPS;

    late IconData icon;
    if (percent >= 0) icon = Icons.arrow_upward_sharp;
    if (percent < 0) icon = Icons.arrow_downward_sharp;

    var nf = NumberFormat.decimalPercentPattern(decimalDigits: 2);
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Icon(icon, color: Colors.black, size: 14),
        Text(
          nf.format(percent.abs()),
          style: ts.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class PricesLabelRow extends StatelessWidget {
  const PricesLabelRow({Key? key, required this.symbol}) : super(key: key);

  final String symbol;
  final TextStyle ts = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final bool watching = Portfolio().watchingIt(symbol);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!watching) Expanded(child: Center(child: Text('avg. cost', style: ts))),
        if (watching) Expanded(child: Center(child: Text('org. price', style: ts))),
        Expanded(child: Center(child: Text('current price', style: ts))),
      ],
    );
  }
}

class PricesRow extends StatelessWidget {
  const PricesRow({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: AvgPricePerShare(symbol: symbol),
          ),
        ),
        Expanded(
          child: Center(
            child: CurrentPricePerShare(key: UniqueKey(), symbol: symbol),
          ),
        )
      ],
    );
  }
}

class AvgPricePerShare extends StatelessWidget {
  const AvgPricePerShare({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  final String symbol;
  final TextStyle ts = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final bool watching = Portfolio().watchingIt(symbol);
    return Consumer(builder: (context, watch, child) {
      double aPPS = context.watch<PriceChangeController>().costPerShare(symbol);
      if (watching) aPPS = context.watch<PriceChangeController>().watchingCost(symbol);
      return Text('\$${aPPS.toStringAsFixed(2)}', style: ts.copyWith(fontWeight: FontWeight.bold));
    });
  }
}

// final ownItProvider = Provider((ref) => OwnIt(ref));
//
// class OwnIt {
//   OwnIt(this.ref) {
//     p = ref.read(portfolioProvider);
//   }
//   late var ref;
//   late var p;
//
//   Map<String, double> symbolMap = {};
//
//   bool ownIt(String symbol) {
//     if (symbolMap.containsKey(symbol)) {
//       if (symbolMap[symbol] == 0) return false;
//       return true;
//     } else {
//       var q = p.iOwnIt(symbol);
//       symbolMap[symbol] = q;
//       if (q == 0) return false;
//       return true;
//     }
//   }
// }

class CurrentPricePerShare extends StatelessWidget {
  const CurrentPricePerShare({
    required Key key,
    required this.symbol,
  }) : super(key: key);

  // static const _uuid = Uuid();
  // final String _id = _uuid.v4();
  final String symbol;
  final TextStyle ts = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    // var ownIt = useProvider(
    //     priceChangeProvider.select((s) => s.state.symbol == symbol));

    // ownIt = ownIt && !context.read(portfolioProvider).watchingIt(symbol);

    // print('[CPPS] $symbol ${useProvider(ownItProvider).ownIt(symbol)}');
    // if (ownIt)
    // print('[CurrentPricePerShare:] '
    //     '${context.read(priceChangeProvider.notifier).state.toString()}');

    double cPPS = context.watch<PriceChangeController>().currentPrice(symbol);
    // double cPPS = context.read(priceChangeProvider.notifier).state.newPrice;
    return Text('\$${cPPS.toStringAsFixed(2)}', style: ts.copyWith(fontWeight: FontWeight.bold));
  }
}
