/// Md bet
class MdBet {
  /// Constructor
  MdBet({
    this.id,
    this.question,
  });

  /// From json
  factory MdBet.fromJson(Map<String, dynamic> json) => MdBet(
        id: json['id'],
        question: json['question'],
      );

  /// Bet id
  String? id;

  /// Question
  String? question;

  /// To json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'question': question,
      };
}
