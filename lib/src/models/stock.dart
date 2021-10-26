class Stock {
  final double quantity;
  final double cost;
  final bool paperTrade;
  final bool? watch;
  final double target = double.negativeInfinity;
  final bool sellTarget = false;
  final bool buyTarget = false;

  const Stock(this.quantity, this.cost, [this.paperTrade = false, this.watch]);
}
