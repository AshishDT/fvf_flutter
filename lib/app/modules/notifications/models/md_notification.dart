/// Model class for Notification
class MdNotification {
  /// Constructor
  MdNotification({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.roundId,
    this.title,
    this.body,
    this.payload,
    this.isActive,
    this.isDeleted,
  });

  /// Create instance from JSON
  factory MdNotification.fromJson(Map<String, dynamic> json) => MdNotification(
        id: json['id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(
                json['createdAt'],
              ),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(
                json['updatedAt'],
              ),
        userId: json['user_id'],
        roundId: json['round_id'],
        title: json['title'],
        body: json['body'],
        payload: json['payload'],
        isActive: json['is_active'],
        isDeleted: json['is_deleted'],
      );

  /// Unique identifier
  String? id;

  /// Creation timestamp
  DateTime? createdAt;

  /// Last update timestamp
  DateTime? updatedAt;

  /// Associated user ID
  String? userId;

  /// Associated round ID
  String? roundId;

  /// Notification title
  String? title;

  /// Notification body
  String? body;

  /// Additional payload
  String? payload;

  /// Active status
  bool? isActive;

  /// Deletion status
  bool? isDeleted;

  /// Convert instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'user_id': userId,
        'round_id': roundId,
        'title': title,
        'body': body,
        'payload': payload,
        'is_active': isActive,
        'is_deleted': isDeleted,
      };
}
