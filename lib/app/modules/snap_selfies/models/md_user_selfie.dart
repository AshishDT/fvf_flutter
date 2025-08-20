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
    this.rank,
  });

  /// The unique identifier for the selfie.
  String? id;

  /// The unique identifier for the user who took the selfie.
  String? userId;

  /// The URL of the selfie image.
  String? selfieUrl;

  /// The asset image for fallback (mainly for current user).
  String? assetImage;

  /// The display name of the user who took the selfie.
  String? displayName;

  /// The date and time when the selfie was created.
  DateTime? createdAt;

  /// Whether this user is still waiting for a selfie (no image yet).
  bool isWaiting;

  /// Rank
  int? rank;

  /// Copy method to create a new instance with the same properties.
  MdUserSelfie copyWith({
    String? id,
    String? userId,
    String? selfieUrl,
    String? assetImage,
    DateTime? createdAt,
    String? displayName,
    bool? isWaiting,
    int? rank,
  }) =>
      MdUserSelfie(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        selfieUrl: selfieUrl ?? this.selfieUrl,
        assetImage: assetImage ?? this.assetImage,
        createdAt: createdAt ?? this.createdAt,
        displayName: displayName ?? this.displayName,
        isWaiting: isWaiting ?? this.isWaiting,
        rank: rank ?? this.rank,
      );
}