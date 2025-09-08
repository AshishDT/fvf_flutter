/// Model for checking if a user can create a bet
class MdCanCreateBet {
  /// Constructor
  MdCanCreateBet({
    this.allowed,
    this.reason,
  });

  /// From JSON
  factory MdCanCreateBet.fromJson(Map<String, dynamic> json) => MdCanCreateBet(
        allowed: json['allowed'],
        reason: json['reason'],
      );

  /// Indicates if creating a bet is allowed
  bool? allowed;

  /// Reason for disallowing bet creation, if any
  String? reason;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'allowed': allowed,
        'reason': reason,
      };
}
