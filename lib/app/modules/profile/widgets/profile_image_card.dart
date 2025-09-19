import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Profile image card widget
class ProfileImageCard extends GetView<ProfileController> {
  /// ProfileImageCard Constructor
  const ProfileImageCard({
    required this.placeholderAsset,
    required this.navigatorTag,
    super.key,
    this.imageUrl,
  });

  /// Network image URL (optional)
  final String? imageUrl;

  /// Asset placeholder (required if no imageUrl)
  final String placeholderAsset;

  /// Navigator tag
  final String navigatorTag;

  @override
  String? get tag => navigatorTag;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          final File? pickedImage =
              await controller.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            controller.image(pickedImage);
            await controller.uploadFile(
              pickedImage: pickedImage,
              folder: 'profile',
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 1,
            child: Obx(
              () => controller.image().path.isNotEmpty
                  ? Image.file(
                      controller.image(),
                      fit: BoxFit.cover,
                    )
                  : imageUrl != null && imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) =>
                              Align(
                            child: Image.asset(
                              placeholderAsset,
                              height: 64.h,
                              width: 64.w,
                            ),
                          ),
                          errorWidget: (BuildContext context, String url,
                                  Object error) =>
                              Align(
                            child: Image.asset(
                              placeholderAsset,
                              height: 64.h,
                              width: 64.w,
                            ),
                          ),
                        )
                      : Align(
                          child: Image.asset(
                            placeholderAsset,
                            height: 64.h,
                            width: 64.w,
                          ),
                        ),
            ),
          ),
        ),
      );
}
