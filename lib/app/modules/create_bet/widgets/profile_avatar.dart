import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Profile Avatar Widget
class ProfileAvatar extends StatelessWidget {
  /// Constructor
  const ProfileAvatar({
    Key? key,
    this.profileUrl,
    this.onTap,
  }) : super(key: key);

  /// Profile image URL
  final String? profileUrl;

  /// Tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = profileUrl != null && profileUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          height: 24,
          width: 24,
          color: Colors.grey.shade200,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: profileUrl!,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) =>
                      const Center(
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (BuildContext context, String url,
                          Object error) =>
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                )
              : const Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
