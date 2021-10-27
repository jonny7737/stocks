import 'package:uuid/uuid.dart';

var _uuid = const Uuid();

enum EventStatus {
  // ignore: constant_identifier_names
  in_process,
  success,
  fail
}

class BusEvent {
  final id = _uuid.v4();
  final eventTime = DateTime.now();

  late EventStatus status;
  late String message;

  @override
  String toString() {
    return message;
  }

  BusEvent({required this.status, required this.message});
}

class Notify extends BusEvent {
  Notify(String message) : super(status: EventStatus.success, message: message);
}

class Navigation extends BusEvent {
  Navigation(EventStatus status, String message) : super(status: status, message: message);
}

class PriceChange extends BusEvent {
  String symbol;
  double newPrice;

  PriceChange(EventStatus status, String message, this.symbol, this.newPrice)
      : super(status: status, message: message);
}

class PriceChanged extends BusEvent {
  String symbol;
  double newPrice;

  PriceChanged(EventStatus status, String message, this.symbol, this.newPrice)
      : super(status: status, message: message);
}

class PlaySound extends BusEvent {
  String soundFile;

  PlaySound(EventStatus status, String message, this.soundFile)
      : super(status: status, message: message);
}

class PortfolioUpdated extends BusEvent {
  PortfolioUpdated(String message) : super(status: EventStatus.success, message: message);
}
