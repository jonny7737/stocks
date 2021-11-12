import 'package:quiver/core.dart' show hash2;
import 'package:timezone/standalone.dart';

class TodaysData {
  final TZDateTime open;
  final TZDateTime tick;
  final double gainLoss;

  TodaysData(this.open, this.tick, this.gainLoss);

  @override
  String toString() {
    return '${open.toString()} : ${tick.toString()} - ${gainLoss.toStringAsFixed(2)}';
  }

  @override
  bool operator ==(other) {
    return (other is TodaysData) && other.tick == tick && other.gainLoss == gainLoss;
  }

  @override
  int get hashCode => hash2(tick.hashCode, gainLoss.hashCode);

  TodaysData operator +(TodaysData other) {
    TZDateTime tick;
    if (this.tick != open) {
      tick = this.tick;
    } else {
      tick = other.tick;
    }

    if (gainLoss == -double.infinity) {
      if (other.gainLoss == -double.infinity) {
        return this;
      } else {
        return TodaysData(open, tick, other.gainLoss);
      }
    } else {
      if (other.gainLoss == -double.infinity) {
        return this;
      } else {
        return TodaysData(open, tick, double.parse((gainLoss + other.gainLoss).toStringAsFixed(2)));
      }
    }
  }

  TodaysData adj(double adj) {
    if (adj == -double.infinity) return this;

    if (gainLoss == -double.infinity) {
      return TodaysData(open, tick, adj);
    } else {
      return TodaysData(open, tick, double.parse((gainLoss + adj).toStringAsFixed(2)));
    }
  }
}
