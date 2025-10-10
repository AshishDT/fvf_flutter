/// Model class for phone data
class MdPhoneData {
  /// Constructor
  MdPhoneData({
    required this.phoneCode,
    required this.flagEmoji,
    required this.countryCode,
  });

  /// Country code
  String phoneCode;

  /// Flag emoji
  String flagEmoji;

  /// County code
  String countryCode;

  /// Copy with
  MdPhoneData copyWith({
    String? phone,
    String? phoneCode,
    String? flagEmoji,
    String? countryCode,
  }) =>
      MdPhoneData(
        phoneCode: phoneCode ?? this.phoneCode,
        flagEmoji: flagEmoji ?? this.flagEmoji,
        countryCode: countryCode ?? this.countryCode,
      );
}
