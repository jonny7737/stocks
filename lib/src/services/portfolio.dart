import 'dart:async';
import 'dart:io';

import 'package:objectdb/objectdb.dart';
// ignore: implementation_imports
import 'package:objectdb/src/objectdb_storage_filesystem.dart' show FileSystemStorage;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:stocks/src/globals.dart';
import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/models/stock.dart';
import 'package:stocks/src/models/ta.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/repositories/daily_pl.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';

import 'cash_balance.dart';
import 'data_request.dart';
import 'market_info.dart';

class Portfolio {
  final CurrentPrices _cpr = CurrentPrices();
  final CashBalance _cb = CashBalance();
  final DataRequestService _drs = DataRequestService();
  final MarketInfo m = MarketInfo();
  final DailyPL _pl = DailyPL();

  late Timer currentPriceTimer;
  late ObjectDB db;

  static const Duration stockCheckInterval = Duration(seconds: 10);

  // final Map<String, Stock> stocks = {};
  Map<DateTime, TA> transactions = {};
  bool loadingTransactionDB = false;
  bool creatingDB = false;
  bool ready = false;
  bool doneOnce = false;

  /// Getter now returns TZDateTime.now(eastern)
  TZDateTime get now => TZDateTime.now(eastern);

  Map<String, Stock> get stocks => _cpr.stocks;

  double get _cashOnHand => _cb.cashOnHand;

  double get cashOnHand => double.parse(_cashOnHand.toStringAsFixed(3));

  static Portfolio? _instance;

  factory Portfolio() => _instance ??= Portfolio._internal();

  Portfolio._internal() {
    appEventBus.on<PriceChanged>().listen(checkTargets);
    initPortfolio();
  }

  Future<void> initPortfolio() async {
    await _openDB();
    appEventBus.fire(Notify('Portfolio process initialized'));
    _pl.portfolioReady = true;
  }

  Future<void> _openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbFilePath = [appDocDir.path, 'transactions.db'].join('/');

    if (File(dbFilePath).existsSync()) File(dbFilePath).deleteSync();

    db = ObjectDB(FileSystemStorage(dbFilePath));
    // print('DB path is $dbFilePath');

    currentPriceTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => _currentPriceRepeat());

    await loadPortfolio();

    await _currentPriceRepeat();

    ready = true;
  }

  Future<void> _currentPriceRepeat() async {
    if (!m.okToQueryIEX && doneOnce) {
      return;
    }

    if (await portfolioIsEmpty) return;
    await _updatePrices();
    // for (var symbol in _cpr.listOfSymbols) {
    //   late double newPrice;
    //   do {
    //     newPrice = await _drs.currentPrice(symbol: symbol);
    //   } while (newPrice == -double.infinity);
    //
    //   /// Report the current price to the price change repository for processing.
    //   appEventBus.fire(PriceChange(EventStatus.in_process, 'Price update', symbol, newPrice));
    // }
    // doneOnce = true;

    // double newPrice = -double.infinity;
    // _cpr.prices.keys.toList().forEach((symbol) async {
    //   print('Loading current price for $symbol');
    //   do {
    //     newPrice = await _drs.currentPrice(symbol: symbol);
    //     print('Got current price for $symbol : $newPrice');
    //   } while (newPrice == -double.infinity);
    //
    //   /// Report the current price to the price change repository for processing.
    //   appEventBus.fire(PriceChange(EventStatus.in_process, 'Price update', symbol, newPrice));
    // });
    doneOnce = true;
  }

  Future<void> _updatePrices() async {
    double newPrice = -double.infinity;
    _cpr.prices.keys.toList().forEach((symbol) async {
      do {
        newPrice = await _drs.currentPrice(symbol: symbol);
      } while (newPrice == -double.infinity);

      /// Report the current price to the price change repository for processing.
      appEventBus.fire(PriceChange(EventStatus.in_process, 'Price update', symbol, newPrice));
    });
  }

  Future<bool> get portfolioReady async {
    while (!ready) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return ready;
  }

  /// PriceChanged event listener.
  ///
  /// Check for new price hitting
  /// buy or sell target.
  void checkTargets(event) {
    bool targetHit = false;
    double price = event.newPrice;
    String symbol = event.symbol;

    if (!stocks.keys.contains(symbol)) return;

    if (stocks[symbol]!.buyTarget && stocks[symbol]!.target <= price) {
      targetHit = true;
    }
    if (stocks[symbol]!.sellTarget && stocks[symbol]!.target >= price) {
      targetHit = true;
    }
    if (targetHit) {
      appEventBus.fire(PlaySound(siren1));
    }
  }

  Future<bool> get portfolioIsEmpty async {
    // Wait a maximum of 5 seconds for portfolio stocks to load.
    const loopDelay = Duration(milliseconds: 100);
    int maxLoops = 50;
    while (_cpr.prices.isEmpty) {
      await Future.delayed(loopDelay);
      maxLoops--;
      if (maxLoops == 0) return true;
    }
    // print('Portfolio is empty: ${_cpr.prices.isEmpty}');
    return _cpr.prices.isEmpty;
  }

  void notify(String message) {
    appEventBus.fire(PortfolioUpdated(message));
  }

  Future<void> loadPortfolio() async {
    transactions = await transactionsFromDB();
    if (transactions.isNotEmpty) return;

    creatingDB = true;

    appEventBus.fire(Notify('Portfolio loading startup data'));

    // Setup initial position, not for production.
    depositCash(dollars: 27.47, note: 'Cash at Fidelity');
    depositCash(dollars: 65.41, note: 'Cash at IBKR');
    depositCash(dollars: 900.80, note: 'Funds for initial trades');
    depositCash(dollars: 75.00, note: 'Money to buy SFT x10');
    depositCash(dollars: 25.00, note: 'Money to buy SFT x10');
    depositCash(dollars: 0.85, note: 'Apple Dividend - IBKR');
    depositCash(dollars: 0.88, note: 'Apple Dividend - Fidelity');
    depositCash(dollars: 100.00, note: 'Adtl SFT x10');
    depositCash(dollars: 150.00, note: 'Adtl CGC x7@20');

    // appEventBus.fire(Notify('Current cash on hand: $cashOnHand'));

    //  Initial positions
    bought(symbol: 'aapl', quantity: 2.0, price: 136.50);
    bought(symbol: 'aapl', quantity: 4.0, price: 130.25);
    bought(symbol: 'cgc', quantity: 1.0, price: 48.90);
    bought(symbol: 'cgc', quantity: 2.0, price: 28.95);
    bought(symbol: 'cgc', quantity: 1.0, price: 25.50);
    bought(symbol: 'sft', quantity: 10.0, price: 8.75);
    bought(symbol: 'cgc', quantity: 3.0, price: 21.75);
    bought(symbol: 'sft', quantity: 10.0, price: 6.51);
    bought(symbol: 'sft', quantity: 7.0, price: 6.42);
    bought(symbol: 'cgc', quantity: 7.0, price: 20.10);
    sold(symbol: 'aapl', quantity: 6, price: 150.00);
    sold(symbol: 'cgc', quantity: 11, price: 13.00);
    bought(symbol: 'cgc', quantity: 10.655, price: 13.42);

    // appEventBus.fire(Notify('Current cash on hand: $cashOnHand'));

    //**************************************************************
    //TODO:    Remove these entries after StockWatch UI is complete.
    addWatch(symbol: 'msft', price: 288.42);
    addWatch(symbol: 'rcat', price: 3.77);
    addWatch(symbol: 'aapl', price: 150.00);
    //**************************************************************

    creatingDB = false;
  }

  bool depositCash({required double dollars, String note = ''}) {
    // addMoney(dollars);
    recordTransaction(TA('', 'deposit', 1, dollars, null, note));
    return true;
  }

  double withdrawCash({required double dollars}) {
    var trans = dollars < cashOnHand ? dollars : cashOnHand;
    // subMoney(trans);
    recordTransaction(TA('', 'withdraw', 1, -trans));
    return trans;
  }

  bool bought(
      {required String symbol,
      required double quantity,
      required double price,
      bool paperTrade = false,
      bool? watch}) {
    symbol = symbol.toUpperCase();
    if (price.isNaN) price = 0;
    if (!paperTrade && cashOnHand < price * quantity && !loadingTransactionDB && !creatingDB) {
      appEventBus.fire(Notify('Purchase declined[$symbol : $cashOnHand] - Insufficient funds'));
      return false;
    }
    appEventBus.fire(PriceChange(EventStatus.in_process, 'Buy transaction', symbol, price));

    var s = stocks[symbol] ?? const Stock(0, 0);

    //  if quantity==0 then set the cost to the price at watch time.
    var cost = quantity == 0 ? price : price * quantity;

    Stock s2 = Stock(quantity + s.quantity, (cost) + s.cost, paperTrade, watch);
    stocks.update(symbol, (v) => s2, ifAbsent: () => s2);

    cost = double.parse((price * quantity).toStringAsFixed(3));
    subMoney(cost);
    if (cost == 0) cost = price;
    recordTransaction(TA(symbol, 'bought', quantity, cost, paperTrade, null, watch));

    _drs.requestData(symbol);

    // appEventBus.fire(Notify(EventStatus.success, 'Portfolio stocks[${stocks.length}]'));
    return true;
  }

  bool sold({required String symbol, required double quantity, required double price}) {
    if (price.isNaN) price = 0;
    if (quantity <= 0) return false;
    if (price <= 0) return false;

    symbol = symbol.toUpperCase();
    // appEventBus.fire(Notify(EventStatus.success, 'stocks[$symbol] = ${stocks[symbol]}'));

    if (stocks[symbol] == null) return false;
    if (quantity > stocks[symbol]!.quantity) return false;
    if (quantity == stocks[symbol]!.quantity) {
      stocks.remove(symbol);
    } else {
      stocks[symbol] =
          Stock(stocks[symbol]!.quantity - quantity, stocks[symbol]!.cost - (quantity * price));
    }

    // addMoney(price * quantity);
    appEventBus.fire(PriceChange(EventStatus.in_process, 'Sell transaction', symbol, price));

    recordTransaction(TA(symbol, 'sold', quantity, price * quantity));
    return true;
  }

  void addMoney(double dollars) {
    // _cashOnHand += dollars;
    // notify('Current cash on hand: $cashOnHand');
  }

  void subMoney(double dollars) {
    // _cashOnHand -= dollars;
    // notify('Current cash on hand: $cashOnHand');
  }

  double get totalDeposits => _cb.totalDeposits;

  double get totalWithdrawals => _cb.totalWithdrawals;

  double get startingBalance => _cb.startingBalance;

  double get currentValue => _cpr.positionValue();

  double get posPL => _pl.posPL;

  double get currentInvestment {
    double value = 0.0;

    stocks.forEach((k, v) {
      if (v.watch != true) value += v.cost;
    });
    return double.parse(value.toStringAsFixed(2));
  }

  addWatch({required String symbol, double price = -double.infinity}) async {
    // if (watchingIt(symbol)) {
    //   // a.log('Already Watching $symbol');
    //   appEventBus.fire(WatchEvent(
    //       symbol: symbol,
    //       eventType: WatchEventType.add_watch,
    //       status: EventStatus.fail,
    //       message: 'Already Watching $symbol'));
    //   return;
    // }

    if (iOwnIt(symbol) > 0) {
      // appEventBus.fire(WatchEvent(
      //     symbol: symbol,
      //     eventType: WatchEventType.add_watch,
      //     status: EventStatus.fail,
      //     message: 'Watching owned not supported: $symbol'));
      return;
    }
    // bool refreshCards = false;
    if (price == -double.infinity) {
      price = await _drs.currentPrice(symbol: symbol);
      if (price == -double.infinity) {
        // a.log('Unknown symbol: $symbol');
        // appEventBus.fire(WatchEvent(
        //     symbol: symbol,
        //     eventType: WatchEventType.add_watch,
        //     status: EventStatus.fail,
        //     message: 'Unknown symbol: $symbol'));
        return;
      }
      // refreshCards = true;
    }
    //  Add $symbol to the watch list with a current price
    bought(symbol: symbol, quantity: 0.0, price: price, watch: true);

    // a.log('New Watch added for $symbol @ $price');
    // if (refreshCards) avm.toggleRebuildCards;
    // appEventBus.fire(WatchEvent(
    //     symbol: symbol,
    //     eventType: WatchEventType.add_watch,
    //     status: EventStatus.success,
    //     message: 'Added new watch: $symbol'));
    return;
  }

  ///  iOwnIt returns double : number of shares.
  double iOwnIt(String symbol) {
    if (stocks[symbol] == null || stocks[symbol]!.quantity == 0) return 0;
    // print('$symbol : ${stocks[symbol]!.quantity}');
    return stocks[symbol]!.quantity;
  }

  List<String> iOwnThese() {
    List<String> symbols = [];

    stocks.forEach((key, value) {
      if (stocks[key]!.quantity > 0) symbols.add(key);
    });
    return symbols;
  }

  bool watchingIt(String symbol) {
    // print('W: ${stocks[symbol]!.watch}');
    if (stocks[symbol] == null || stocks[symbol]!.watch != true) return false;
    return true;
  }

  recordTransaction(TA transaction) {
    var now = DateTime.now();
    transactions[now] = transaction;

    appEventBus.fire(Transaction(transaction));

    // print('[$now]  TransAction recorded: ${transaction.action}');

    //  Update Transaction DB
    if (!loadingTransactionDB) {
      // print('RT: ${transaction.toJson()}');
      transactionToDB(now, transaction);
    }
  }

  /// New procedure for loading from database
  ///   1.  Load and process deposits
  ///   2.  Load and process buys
  ///   3.  Load and process sells
  ///   4.  Load and process everything else

  Future<Map<DateTime, TA>> transactionsFromDB() async {
    loadingTransactionDB = true;
    Map<DateTime, TA> t = {};
    // while (db == null) await Future.delayed(Duration(milliseconds: 100));
    var recList = await db.find();
    for (var rec in recList) {
      // print('${rec['_id']} : ${rec.toString()}');
      // var dt = DateTime.parse(rec.keys.first);
      var dt = DateTime.now();
      var ta = TA.fromJson(rec as Map<String, dynamic>);

      t[dt] = ta;

      var price = ta.quantity == 0 ? ta.cost : ta.cost / ta.quantity;
      if (ta.action == 'deposit') {
        depositCash(dollars: ta.cost, note: ta.note ?? '');
      }
      if (ta.action == 'bought') {
        bought(symbol: ta.symbol, quantity: ta.quantity, price: price, watch: ta.watch);
      }
      if (ta.action == 'sold') {
        sold(symbol: ta.symbol, quantity: ta.quantity, price: price);
      }
      // a.log('Portfolio: ${ta.toJson()}');
    }
    // a.log('Portfolio [${t.length}] transactions loaded from DB');
    loadingTransactionDB = false;
    return t;
  }

  Future<void> transactionToDB(DateTime now, TA transaction) async {
    var jsonMap = transaction.toJson();
    jsonMap['transtime'] = now.toString();
    await db.insert(jsonMap);
    // await db.wait();
    // print('New transaction ID $id');
    db.cleanup();
  }

  Future insertAll() async {
    var tList = transactions.entries.toList(growable: false);

    for (var e in tList) {
      // print('TT = ${e.key} : ${e.value.toJson()}');
      await db.insert({e.key.toString(): e.value.toJson()});
    }
    return;
  }
}
