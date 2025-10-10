/// Nested model for `data` inside the phone check response.
class MdCheckPhone {
  /// Check phone constructor
  MdCheckPhone({
    this.id,
    this.isExist,
  });

  /// Creates an instance of [CheckPhoneData] from JSON.
  factory MdCheckPhone.fromJson(Map<String, dynamic> json) => MdCheckPhone(
        id: json['id'],
        isExist: json['is_exist'],
      );

  /// Unique identifier for the user or phone entry.
  final String? id;

  /// Whether the phone number already exists in the system.
  final bool? isExist;

  /// Converts the current instance into a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'is_exist': isExist,
      };
}
