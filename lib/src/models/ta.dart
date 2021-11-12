///
///   Portfolio transaction model
class TA {
  final String symbol;
  final String action;
  final double quantity;
  final double cost;
  final bool? paperTrade;

  /// Transaction comment
  final String? note;
  final bool? watch;
  final String? dbId;

  TA(this.symbol, this.action, this.quantity, this.cost,
      [this.paperTrade = false, this.note, this.watch, this.dbId]);

  TA.fromJson(Map<String, dynamic> json)
      : symbol = json["symbol"] ?? '',
        action = json["action"],
        quantity = json["quantity"],
        cost = json["cost"].isNaN ? 0.0 : json["cost"],
        paperTrade = json["paperTrade"],
        note = json["note"],
        watch = json["watch"],
        dbId = json["_id"];

  Map toJson() {
    Map json = {};

    if (symbol.isNotEmpty) json["symbol"] = symbol;
    json["action"] = action;
    json["quantity"] = quantity;
    json["cost"] = cost;
    if (action == 'bought' && quantity != 0) {
      json["paperTrade"] = paperTrade;
    }
    if (note != null && note != '') json["note"] = note;
    if (watch != null) json["watch"] = watch;

    return json;
  }
}
