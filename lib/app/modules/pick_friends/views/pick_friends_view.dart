import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/pick_friends/views/picked_contacts_view.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../controllers/pick_friends_controller.dart';
import '../widgets/contacts_limit.dart';
import 'contacts_card_view.dart';
import 'contacts_search_field.dart';

/// Pick Friends View
class PickFriendsView extends GetView<PickFriendsController> {
  /// Constructor
  const PickFriendsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 300),
          alignment: Alignment.bottomCenter,
          curve: Curves.easeInOut,
          child: Obx(
            () => AppButton(
              buttonText: controller.selectedIds().isEmpty
                  ? 'Start with friends'
                  : 'Start with ${controller.selectedIds().length} friends',
              onPressed: controller.onContinueButtonPressed,
            ),
          ).paddingSymmetric(horizontal: 24),
        ),
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: RefreshIndicator(
                backgroundColor: AppColors.kF5FCFF,
                onRefresh: () async {
                  await controller.getContacts();
                },
                child: AnimatedListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    const CommonAppBar().paddingSymmetric(horizontal: 24),
                    16.verticalSpace,
                    const ContactsSearchField().paddingSymmetric(
                      horizontal: 24,
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.topLeft,
                      curve: Curves.easeInOut,
                      child: Obx(
                        () => Visibility(
                          visible: controller.selectedContacts().isNotEmpty,
                          replacement: const SizedBox(
                            width: double.infinity,
                          ),
                          child: const Align(
                            child: PickedContactsView(),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.topLeft,
                        curve: Curves.easeInOut,
                        child: Obx(
                          () => Visibility(
                            visible: controller.selectedIds().length > 8,
                            replacement: const SizedBox(
                              width: double.infinity,
                            ),
                            child: const ContactsLimit(),
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    const ContactsCard().paddingSymmetric(
                      horizontal: 24,
                    ),
                    150.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
