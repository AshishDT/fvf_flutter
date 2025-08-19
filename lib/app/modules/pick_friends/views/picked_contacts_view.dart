import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/pick_friends/controllers/pick_friends_controller.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/string_ext.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

/// Picked contacts view
class PickedContactsView extends GetView<PickFriendsController> {
  /// Constructor for Picked Contacts View
  const PickedContactsView({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              controller.selectedContacts().length,
              (int index) {
                final bool isFirstIndex = index == 0;

                return contactAvatar(controller.selectedContacts()[index])
                    .animate(position: index)
                    .paddingOnly(
                      left: isFirstIndex ? 24 : 0,
                      right: 24,
                    );
              },
            ),
          ),
        ),
      );

  /// Returns a CircleAvatar for the contact
  Widget contactAvatar(Contact contact) {
    final String initials = contact.displayName.getInitials;
    final Color bgColor = controller.getAvatarColor(contact.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      padding: REdgeInsets.only(top: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 56.h,
                width: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor,
                  border: Border.all(
                    color: const Color(0xFFF6FCFE),
                    width: 3.w,
                  ),
                  image: (contact.photo != null && contact.photo!.isNotEmpty)
                      ? DecorationImage(
                          image: MemoryImage(contact.photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: (contact.photo != null && contact.photo!.isNotEmpty)
                    ? null
                    : Text(
                        initials,
                        style: AppTextStyle.openRunde(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              2.verticalSpace,
              Text(
                contact.name.first,
                style: AppTextStyle.openRunde(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kffffff,
                ),
              ),
            ],
          ),
          Positioned(
            top: -6,
            right: -6,
            child: InkWell(
              onTap: () => controller.toggleSelection(contact.id),
              child: SvgPicture.asset(
                height: 24.h,
                width: 24.w,
                AppImages.closeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
