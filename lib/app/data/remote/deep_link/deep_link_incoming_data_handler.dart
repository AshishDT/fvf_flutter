import 'dart:async';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/notification_service/notification_actions_handler.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/utils/app_loader.dart';
import 'package:get/get.dart';
import '../../../modules/snap_selfies/repositories/snap_selfie_api_repo.dart';
import '../../config/logger.dart';
import '../../models/md_deep_link_data.dart';
import '../../models/md_join_invitation.dart';

/// Observable to track if deep link is being handled
RxString invitationId = ''.obs;

/// Observable to track if the link is view-only
RxBool isViewOnly = false.obs;

/// Handle incoming data
void handleDeepLinkIncomingData(Map<dynamic, dynamic> data) {
  final MdDeepLinkData deepLinkData = MdDeepLinkData.fromJson(data);

  if (deepLinkData.clickedBranchLink == true) {
    if ((deepLinkData.tags?.contains('slay_invite') ?? false) ||
        deepLinkData.canonicalIdentifier == 'slay_invite') {
      if (deepLinkData.invitationId?.isNotEmpty ?? false) {
        final bool isUserLoggedIn =
            SupaBaseService.isLoggedIn && UserProvider.currentUser != null;

        final bool isViewOnlyLink = deepLinkData.isViewOnly ?? false;

        if (isUserLoggedIn) {
          if (isViewOnlyLink) {
            NotificationActionsHandler.handleRoundDetails(
              roundId: deepLinkData.invitationId!,
              isViewOnly: true,
            );
          } else {
            joinProjectInvitation(
              deepLinkData.invitationId!,
            );
          }

          invitationId('');
          isViewOnly(false);
        } else {
          invitationId(deepLinkData.invitationId!);
          isViewOnly(deepLinkData.isViewOnly);
          appSnackbar(
            message: 'Please log in to join the invitation.',
            snackbarState: SnackbarState.info,
          );
        }
      }
      return;
    } else {
      logW('Unknown active deep link canonicalIdentifier: $data');
    }
  } else {
    const List<String> branchDomains = <String>[
      '0wkmj.app.link',
      '0wkmj-alternate.app.link',
      '0wkmj.test-app.link',
      '0wkmj-alternate.test-app.link',
    ];

    final bool isNonBranchLinkPresent = data.containsKey('+non_branch_link');
    final String? nonBranchLink =
        isNonBranchLinkPresent ? data['+non_branch_link'] as String? : null;

    final bool isBranchDomainInNonBranchLink = nonBranchLink != null &&
        branchDomains.any((String domain) => nonBranchLink.contains(domain));

    if (isNonBranchLinkPresent && isBranchDomainInNonBranchLink) {
      logWTF('Expired or invalid deep link clicked: $data');
    }
  }
}

/// Join project invitation
Future<void> joinProjectInvitation(String invitationId) async {
  Loader.show();

  try {
    final MdJoinInvitation? _joinedData =
        await SnapSelfieApiRepo.joinInvitation(
      roundId: invitationId,
    );

    Loader.dismiss();

    if (_joinedData != null) {
      await NotificationActionsHandler.handleRoundDetails(
        roundId: invitationId,
        isViewOnly: _joinedData.isViewOnly ?? false,
      );
    }
  } on Exception {
    Loader.dismiss();
  } finally {
    Loader.dismiss();
  }
}
