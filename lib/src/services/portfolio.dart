import 'dart:async';
import 'dart:io';

import 'package:iex/iex.dart';
import 'package:intl/intl.dart';
import 'package:objectdb/objectdb.dart';
// ignore: implementation_imports
import 'package:objectdb/src/objectdb_storage_filesystem.dart' show FileSystemStorage;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:stocks/src/globals.dart';
import 'package:stocks/src/models/bus_events.dart';
import 'package:stocks/src/models/stock.dart';
import 'package:stocks/src/models/transaction.dart';
import 'package:stocks/src/repositories/current_prices.dart';
import 'package:stocks/src/services/utils.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';

class Portfolio {
  final CurrentPrices _cpr = CurrentPrices();
  late DataRequestProcessor _drp;
  late Timer currentPriceTimer;
  late ObjectDB db;

  static const Duration stockCheckInterval = Duration(seconds: 10);

  // final Map<String, Stock> stocks = {};
  Map<DateTime, Transaction> transactions = {};
  bool loadingTransactionDB = false;
  bool ready = false;
  bool doneOnce = false;

  TZDateTime? nextOpen;
  TZDateTime? nextClose;
  Timer? marketCheckTimer;
  Location eastern = getLocation('US/Eastern');
  Location central = getLocation('US/Central');

  /// Getter now returns TZDateTime.now(eastern)
  TZDateTime get now => TZDateTime.now(eastern);

  Map<String, Stock> get stocks => _cpr.stocks;

  double _cashOnHand = 0.00;

  double get cashOnHand => double.parse(_cashOnHand.toStringAsFixed(2));

  static Portfolio? _instance;

  factory Portfolio() => _instance ??= Portfolio._internal();

  Portfolio._internal() {
    appEventBus.on<PriceChanged>().listen(checkTargets);
    _drp = DataRequestProcessor(serviceEndPoint);
    initPortfolio();
    if (marketCheckTimer == null) marketCheck();
  }

  Future<void> initPortfolio() async {
    await _openDB();
    appEventBus.fire(Notify('Portfolio process initialized'));
  }

  void marketCheck() {
    if (marketCheckTimer == null) {
      marketCheckTimer = Timer.periodic(const Duration(seconds: 2), checkMarketOC);
    } else {
      marketCheckTimer!.cancel();
      marketCheckTimer = Timer.periodic(const Duration(minutes: 5), checkMarketOC);
    }
  }

  int marketCheckCounter = 0;
  Future<void> checkMarketOC(_) async {
    if (marketCheckCounter == 5) {
      marketCheckCounter++;
      marketCheck();
      return;
    }
    await setNextOpen();
    await setNextClose();
    if (marketCheckCounter < 6) marketCheckCounter++;
  }

  bool get marketIsOpen =>
      now.isBefore(nextClose ?? DateTime(0)) && now.isAfter(nextOpen ?? DateTime(0));

  Future<void> setNextOpen() async {
    String open = await _drp.nextMarketOpen();
    // notify('Market opens: $open');
    nextOpen = TZDateTime.from(openDate(open), eastern).add(const Duration(hours: 8, minutes: 30));
    if (now.weekday <= 5) {
      nextOpen =
          TZDateTime(eastern, now.year, now.month, now.day, nextOpen!.hour, nextOpen!.minute);
      // if (now.isAfter(nextClose ?? DateTime(0))) nextOpen = nextOpen!.add(const Duration(days: 1));
    }

    open = DateFormat("yyyy-MM-dd HH:mm").format(nextOpen ?? DateTime(0));
    notify('Market opens: $open');
  }

  Future<void> setNextClose() async {
    if (nextOpen == null) return;

    var now = TZDateTime.now(central);
    if (now.day <= nextOpen!.day) {
      nextClose = TZDateTime(eastern, now.year, now.month, now.day, 16, 00, 00);
      String close = DateFormat("yyyy-MM-dd HH:mm").format(nextClose ?? DateTime(0));
      notify('Market closes: $close');
    }
  }

  Future<void> _openDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbFilePath = [appDocDir.path, 'transactions.db'].join('/');

    // if (File(dbFilePath).existsSync()) File(dbFilePath).deleteSync();

    db = ObjectDB(FileSystemStorage(dbFilePath));
    // print('DB path is $dbFilePath');

    currentPriceTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer t) => _currentPriceRepeat());

    await loadPortfolio();

    await _currentPriceRepeat();

    ready = true;
  }

  bool get okToQueryIEX =>
      now.isAfter(nextOpen!.subtract(const Duration(minutes: 10))) &&
      now.isBefore(nextClose!.add(const Duration(minutes: 5)));

  Future<void> _currentPriceRepeat() async {
    // if (!marketIsOpen &&
    //     now.add(const Duration(minutes: 5)).isAfter(nextClose ?? DateTime(0)) &&
    //     doneOnce) return;
    // print('[$now] okToQueryIEX: $okToQueryIEX');

    if (nextOpen == null) return;
    if (!okToQueryIEX && doneOnce) {
      return;
    }

    if (await portfolioIsEmpty) return;
    _cpr.prices.keys.toList().forEach((symbol) async {
      late double newPrice;
      do {
        newPrice = await _drp.currentPrice(symbol: symbol);
      } while (newPrice == -double.infinity);
      _cpr.updatePrice(symbol, newPrice);
    });
    doneOnce = true;
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
    return _cpr.prices.isEmpty;
  }

  void notify(String message) {
    appEventBus.fire(PortfolioUpdated(message));
  }

  Future<void> loadPortfolio() async {
    transactions = await transactionsFromDB();
    if (transactions.isNotEmpty) return;

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

    appEventBus.fire(Notify('Current cash on hand: $cashOnHand'));

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

    appEventBus.fire(Notify('Current cash on hand: $cashOnHand'));

    //**************************************************************
    //TODO:    Remove these entries after StockWatch UI is complete.
    addWatch(symbol: 'msft', price: 288.42);
    addWatch(symbol: 'rcat', price: 3.77);
    addWatch(symbol: 'aapl', price: 150.00);
    //**************************************************************
  }

  bool depositCash({required double dollars, String note = ''}) {
    addMoney(dollars);
    recordTransaction(Transaction('', 'deposit', 1, dollars, null, note));
    return true;
  }

  double withdrawCash({required double dollars}) {
    var trans = dollars < cashOnHand ? dollars : cashOnHand;
    subMoney(trans);
    recordTransaction(Transaction('', 'withdraw', 1, -trans));
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
    if (!paperTrade && cashOnHand < price * quantity) {
      appEventBus.fire(Notify('Purchase declined - Insufficient funds'));
      return false;
    }
    // if (watch == null || !watch) //  Do not log new Watches here
    //   a.log('bought($symbol, $quantity, $price, $watch)');

    appEventBus.fire(PriceChange(EventStatus.in_process, 'Buy transaction', symbol, price));

    var s = stocks[symbol] ?? const Stock(0, 0);

    //  if quantity==0 then set the cost to the price at watch time.
    var cost = quantity == 0 ? price : price * quantity;

    Stock s2 = Stock(quantity + s.quantity, (cost) + s.cost, paperTrade, watch);
    stocks.update(symbol, (v) => s2, ifAbsent: () => s2);

    // cashOnHand -= price * quantity;
    cost = price * quantity;
    subMoney(cost);
    if (cost == 0) cost = price;
    recordTransaction(Transaction(symbol, 'bought', quantity, cost, paperTrade, null, watch));

    _drp.requestData([
      {'fn': 'price', 'symbol': symbol}
    ]);

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
      stocks[symbol] = Stock(stocks[symbol]!.quantity - quantity, stocks[symbol]!.cost);
    }

    addMoney(price * quantity);
    appEventBus.fire(PriceChange(EventStatus.in_process, 'Sell transaction', symbol, price));

    recordTransaction(Transaction(symbol, 'sold', quantity, price * quantity));
    return true;
  }

  void addMoney(double dollars) {
    _cashOnHand += dollars;
    notify('Current cash on hand: $cashOnHand');
  }

  void subMoney(double dollars) {
    _cashOnHand -= dollars;
    notify('Current cash on hand: $cashOnHand');
  }

  double get totalDeposits {
    double total = 0.0;
    transactions.forEach((k, v) {
      // a.log('Total deposits: ${v.toJson()}');
      if (v.action == 'deposit') total += v.cost;
    });
    return total;
  }

  double get totalWithdrawals {
    double total = 0.0;
    transactions.forEach((k, v) {
      if (v.action == 'withdraw') total += v.cost;
    });
    return total;
  }

  double get startingBalance {
    return totalDeposits - totalWithdrawals;
  }

  double get currentValue {
    double value = 0.0;

    stocks.forEach((k, v) {
      value += v.quantity * _cpr.price(k);
    });
    return double.parse(value.toStringAsFixed(2));
  }

  double get currentInvestment {
    double value = 0.0;

    stocks.forEach((k, v) {
      value += v.cost;
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
      price = await _drp.currentPrice(symbol: symbol);
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

  recordTransaction(Transaction transaction) {
    var now = DateTime.now();
    transactions[now] = transaction;

    // print('[$now]  TransAction recorded: ${transaction.action}');

    //  Update Transaction DB
    if (!loadingTransactionDB) {
      // print('RT: ${transaction.toJson()}');
      transactionToDB(now, transaction);
    }
  }

  Future<Map<DateTime, Transaction>> transactionsFromDB() async {
    loadingTransactionDB = true;
    Map<DateTime, Transaction> t = {};
    // while (db == null) await Future.delayed(Duration(milliseconds: 100));
    var recList = await db.find();
    for (var rec in recList) {
      // print('${rec['_id']} : ${rec.toString()}');
      // var dt = DateTime.parse(rec.keys.first);
      var dt = DateTime.now();
      var ta = Transaction.fromJson(rec as Map<String, dynamic>);
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

  Future<void> transactionToDB(DateTime now, Transaction transaction) async {
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
