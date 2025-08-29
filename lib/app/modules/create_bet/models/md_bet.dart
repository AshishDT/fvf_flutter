/// Md bet
class MdBet {
  /// Constructor
  MdBet({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.question,
    this.validFrom,
    this.validTo,
    this.isActive,
    this.isDeleted,
  });

  /// From JSON
  factory MdBet.fromJson(Map<String, dynamic> json) => MdBet(
        id: json['id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        question: json['question'],
        validFrom: json['valid_from'] == null
            ? null
            : DateTime.parse(json['valid_from']),
        validTo:
            json['valid_to'] == null ? null : DateTime.parse(json['valid_to']),
        isActive: json['is_active'],
        isDeleted: json['is_deleted'],
      );

  /// Id
  String? id;

  /// Created at
  DateTime? createdAt;

  /// Updated at
  DateTime? updatedAt;

  /// Question
  String? question;

  /// Valid from
  DateTime? validFrom;

  /// Valid to
  DateTime? validTo;

  /// Is active
  bool? isActive;

  /// Is deleted
  bool? isDeleted;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'question': question,
        'valid_from': validFrom?.toIso8601String(),
        'valid_to': validTo?.toIso8601String(),
        'is_active': isActive,
        'is_deleted': isDeleted,
      };
}
