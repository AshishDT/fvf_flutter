/// Previous participant model
class MdPreviousParticipant {
  /// Constructor
  MdPreviousParticipant({
    this.userId,
    this.userName,
    this.userProfileUrl,
    this.userSupabaseId,
    this.isAdded,
  });

  /// From JSON
  factory MdPreviousParticipant.fromJson(Map<String, dynamic> json) =>
      MdPreviousParticipant(
        userId: json['user_id'],
        userName: json['user_name'],
        userProfileUrl: json['user_profile_url'],
        userSupabaseId: json['user_supabase_id'],
      );

  /// User ID
  String? userId;

  /// User name
  String? userName;

  /// User profile URL
  String? userProfileUrl;

  /// User Supabase ID
  String? userSupabaseId;

  /// Is added
  bool? isAdded;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'user_id': userId,
        'user_name': userName,
        'user_profile_url': userProfileUrl,
        'user_supabase_id': userSupabaseId,
      };
}
