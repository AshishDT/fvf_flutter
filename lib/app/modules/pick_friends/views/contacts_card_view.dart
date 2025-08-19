import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/pick_friends/controllers/pick_friends_controller.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/string_ext.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/check_box.dart';

/// Contacts Card widget
class ContactsCard extends GetView<PickFriendsController> {
  /// Constructor for Contacts Card
  const ContactsCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: REdgeInsets.only(left: 16, right: 16),
        constraints: BoxConstraints(
          maxHeight: 400.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24).r,
          color: AppColors.kE4F7FB,
        ),
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.filteredContacts().length,
            itemBuilder: (BuildContext context, int index) {
              final Contact contact = controller.filteredContacts()[index];
              final String phone =
                  contact.phones.isNotEmpty ? contact.phones.first.number : '';

              final bool isFirstItem = index == 0;

              return GestureDetector(
                onTap: () => controller.toggleSelection(contact.id),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding:
                        REdgeInsets.only(bottom: 24, top: isFirstItem ? 16 : 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Obx(
                          () => CustomCheckbox(
                            value: controller.selectedIds().contains(contact.id),
                            onChanged: (_) =>
                                controller.toggleSelection(contact.id),
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              circleAvatar(contact),
                              8.horizontalSpace,
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      contact.displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.openRunde(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.k3D4445,
                                      ),
                                    ),
                                    if (phone.isNotEmpty) ...<Widget>[
                                      Text(
                                        phone,
                                        style: AppTextStyle.openRunde(
                                          fontSize: 12.sp,
                                          color: AppColors.k707C7E,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(position: index),
                ),
              );
            },
          ),
        ),
      );

  /// Returns a CircleAvatar for the contact
  CircleAvatar circleAvatar(Contact contact) {
    final String initials = contact.displayName.getInitials;
    final Color bgColor = controller.getAvatarColor(contact.id);

    if (contact.photo != null && contact.photo!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.photo!),
        radius: 22.r,
        backgroundColor: bgColor,
      );
    } else {
      return CircleAvatar(
        backgroundColor: bgColor,
        radius: 22.r,
        child: Text(
          initials,
          style: AppTextStyle.openRunde(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }


}
