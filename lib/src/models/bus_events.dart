import 'package:stocks/src/models/ta.dart';
import 'package:timezone/timezone.dart';
import 'package:uuid/uuid.dart';

var _uuid = const Uuid();

enum EventStatus {
  // ignore: constant_identifier_names
  in_process,
  success,
  fail
}

class BaseEvent {
  final id = _uuid.v4();
  final eventTime = DateTime.now();

  late EventStatus status;
  late String message;
  late bool logIt;

  @override
  String toString() {
    return message;
  }

  BaseEvent({required this.status, required this.message, this.logIt = true});
}

class Notify extends BaseEvent {
  Notify(String message) : super(status: EventStatus.success, message: message);
}

class Navigation extends BaseEvent {
  Navigation(EventStatus status, String message) : super(status: status, message: message);
}

class PriceChange extends BaseEvent {
  String symbol;
  double newPrice;

  PriceChange(EventStatus status, String message, this.symbol, this.newPrice)
      : super(status: status, message: message);
}

class PriceChanged extends BaseEvent {
  String symbol;
  double newPrice;

  PriceChanged(EventStatus status, String message, this.symbol, this.newPrice)
      : super(status: status, message: message);
}

class PlaySound extends BaseEvent {
  String soundFile;

  PlaySound(this.soundFile) : super(status: EventStatus.success, message: 'Playing : $soundFile');
}

class PortfolioUpdated extends BaseEvent {
  PortfolioUpdated(String message)
      : super(status: EventStatus.success, message: message, logIt: true);
}

class BackfillComplete extends BaseEvent {
  BackfillComplete() : super(status: EventStatus.success, message: 'Backfill request completed');
}

class PositionChanged extends BaseEvent {
  PositionChanged() : super(status: EventStatus.success, message: 'Position changed');
}

class MarketInfoUpdated extends BaseEvent {
  MarketInfoUpdated(String message)
      : super(status: EventStatus.success, message: message, logIt: true);
}

class UpdatePLHistory extends BaseEvent {
  UpdatePLHistory() : super(status: EventStatus.success, message: '');
}

class NewMaxValue extends BaseEvent {
  double newValue;
  NewMaxValue(this.newValue)
      : super(status: EventStatus.success, message: 'New max value set: $newValue');
}

class Transaction extends BaseEvent {
  late String action;
  late String symbol;
  late double quantity;
  late double cost;
  late String note;
  late bool paperTrade;
  late bool watch;
  late TZDateTime transtime;

  // TransactionH() : super(status: EventStatus.success, message: '');
  Transaction(TA t) : super(status: EventStatus.success, message: '') {
    action = t.action;
    symbol = t.symbol;
    quantity = t.quantity;
    cost = t.cost;
    note = t.note ?? '';
    paperTrade = t.paperTrade ?? false;
    watch = t.watch ?? false;
  }
}
