/// This is a model class for user selfies.
class MdUserSelfie {
  /// Constructor for MdUserSelfie.
  MdUserSelfie({
    this.id,
    this.userId,
    this.selfieUrl,
    this.assetImage,
    this.createdAt,
    this.displayName,
    this.isWaiting = false,
  });

  /// The unique identifier for the selfie.
  final String? id;

  /// The unique identifier for the user who took the selfie.
  final String? userId;

  /// The URL of the selfie image.
  final String? selfieUrl;

  /// The asset image for fallback (mainly for current user).
  final String? assetImage;

  /// The display name of the user who took the selfie.
  final String? displayName;

  /// The date and time when the selfie was created.
  final DateTime? createdAt;

  /// Whether this user is still waiting for a selfie (no image yet).
  final bool isWaiting;
}
