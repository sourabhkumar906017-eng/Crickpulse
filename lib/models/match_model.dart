class MatchModel {
  final String t1;
  final String t1s;
  final String t2;
  final String t2s;
  final String status;
  final String? dateTimeGMT;
  final Map<String, dynamic>? scorecard;
  final List<dynamic>? commentary;

  MatchModel({
    required this.t1,
    required this.t1s,
    required this.t2,
    required this.t2s,
    required this.status,
    this.dateTimeGMT,
    this.scorecard,
    this.commentary,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      t1: json["t1"] ?? "",
      t1s: json["t1s"] ?? "N/A",
      t2: json["t2"] ?? "",
      t2s: json["t2s"] ?? "N/A",
      status: json["status"] ?? "",
      dateTimeGMT: json["dateTimeGMT"],
      scorecard: json["scorecard"],
      commentary: json["commentary"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "t1": t1,
      "t1s": t1s,
      "t2": t2,
      "t2s": t2s,
      "status": status,
      "dateTimeGMT": dateTimeGMT,
      "scorecard": scorecard,
      "commentary": commentary,
    };
  }
}
