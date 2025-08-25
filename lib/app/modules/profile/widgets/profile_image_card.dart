import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Profile image card widget
class ProfileImageCard extends GetView<ProfileController> {
  /// ProfileImageCard Constructor
  const ProfileImageCard({
    required this.placeholderAsset,
    super.key,
    this.imageUrl,
  });

  /// Network image URL (optional)
  final String? imageUrl;

  /// Asset placeholder (required if no imageUrl)
  final String placeholderAsset;

  @override
  Widget build(BuildContext context) {
    logI(controller.profile()?.user?.username);
    final bool hasAsset = controller.user().assetImage != null &&
        controller.user().assetImage!.isNotEmpty;
    return IgnorePointer(
      ignoring: !controller.isCurrentUser,
      child: GestureDetector(
        onTap: () async {
          final File? pickedImage =
              await controller.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            controller.image(pickedImage);
            await controller.uploadFile(
              pickedImage: pickedImage,
              folder: 'profile',
            );
            logI('Done');
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
                      height: 64.h,
                      width: 64.w,
                      fit: BoxFit.cover,
                    )
                  : hasAsset
                      ? Image.asset(
                          controller.user().assetImage!,
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
      ),
    );
  }
}
