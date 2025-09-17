/// Profile tag model
class MdProfileArgs {
  /// Profile tag model
  MdProfileArgs({
    required this.tag,
    required this.userId,
    required this.supabaseId,
  });

  /// Tag name
  final String tag;

  /// Tag value
  final String userId;

  /// Supabase ID
  final String supabaseId;
}
