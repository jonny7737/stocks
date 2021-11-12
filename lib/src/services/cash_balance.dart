import 'package:flutter/material.dart';
import 'package:stocks/src/models/bus_events.dart';

import '../globals.dart';

/// Singleton service to manage cash
///
/// Monitor transactions for activity affecting cash on hand.
///
/// Provide cash on hand, total deposits, total withdrawals.
class CashBalance extends ChangeNotifier {
  static CashBalance? _instance;

  CashBalance._internal() {
    /// Event listener for Transaction events.
    appEventBus.on<Transaction>().listen((event) {
      _process(event);
    });
  }

  factory CashBalance() => _instance ??= CashBalance._internal();

  double get cashOnHand =>
      double.parse((deposits + income - withdrawals - expenses).toStringAsFixed(3));

  double get totalDeposits => double.parse(deposits.toStringAsFixed(3));
  double get totalWithdrawals => double.parse(withdrawals.toStringAsFixed(3));
  double get startingBalance => totalDeposits - totalWithdrawals;

  // double cash = 0.0;
  double deposits = 0.0;
  double withdrawals = 0.0;
  double income = 0.0;
  double expenses = 0.0;

  _process(Transaction t) {
    bool notify = true;

    switch (t.action) {
      case 'deposit':
        deposits += t.cost;
        break;
      case 'withdraw':
        withdrawals += t.cost;
        break;
      case 'bought':
        if (t.quantity > 0) expenses += t.cost;
        break;
      case 'sold':
        if (t.quantity > 0) income += t.cost;
        break;
      default:
        notify = false;
    }
    if (notify) {
      notifyListeners();
      appEventBus.fire(Notify('Cash on hand: $cashOnHand - Deposits: $totalDeposits'));
    }
  }
}
