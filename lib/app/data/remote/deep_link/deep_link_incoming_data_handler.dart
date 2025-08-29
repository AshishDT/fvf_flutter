import 'dart:async';

import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/utils/app_loader.dart';
import 'package:get/get.dart';
import '../../../modules/snap_selfies/repositories/snap_selfie_api_repo.dart';
import '../../config/logger.dart';
import '../../models/md_deep_link_data.dart';
import '../../models/md_join_invitation.dart';

/// Observable to track if deep link is being handled
RxString invitationId = ''.obs;

/// Handle incoming data
void handleDeepLinkIncomingData(Map<dynamic, dynamic> data) {
  final MdDeepLinkData deepLinkData = MdDeepLinkData.fromJson(data);

  if (deepLinkData.clickedBranchLink == true) {
    if ((deepLinkData.tags?.contains('slay_invite') ?? false) ||
        deepLinkData.canonicalIdentifier == 'slay_invite') {
      if (deepLinkData.invitationId?.isNotEmpty ?? false) {
        final bool isHost =
            deepLinkData.hostId == SupaBaseService.currentUser?.id;

        final bool isUserLoggedIn =
            SupaBaseService.isLoggedIn && SupaBaseService.currentUser != null;

        if (isUserLoggedIn) {
          if (isHost) {
            return;
          }
          joinProjectInvitation(
            deepLinkData.invitationId!,
          );
          invitationId('');
        } else {
          invitationId(deepLinkData.invitationId!);
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
      'ikmza.app.link',
      'ikmza-alternate.app.link',
      'ikmza.test-app.link',
      'ikmza-alternate.test-app.link',
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
      appSnackbar(
        message: 'You have successfully joined the project!',
        snackbarState: SnackbarState.success,
      );

      unawaited(
        Get.toNamed(
          Routes.SNAP_SELFIES,
          arguments: _joinedData,
        ),
      );
    }
  } on Exception {
    Loader.dismiss();
  } finally {
    Loader.dismiss();
  }
}
