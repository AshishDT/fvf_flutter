import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';

import '../../config/logger.dart';
import '../../models/md_deep_link_data.dart';

/// Handle incoming data
void handleDeepLinkIncomingData(Map<dynamic, dynamic> data) {
  final bool isClickBranchLinkActive = data['+clicked_branch_link'] == true;

  if (isClickBranchLinkActive) {
    final MdDeepLinkData deepLinkData = MdDeepLinkData.fromJson(data);

    switch (deepLinkData.canonicalIdentifier) {
      case 'slay_invite':
        if (deepLinkData.invitationId != null &&
            deepLinkData.invitationId!.isNotEmpty) {
          appSnackbar(
            message: 'Slay invite received: ${deepLinkData.invitationId}',
            snackbarState: SnackbarState.success,
          );
        }
        break;
      default:
        logW('Unknown active deep link canonicalIdentifier: $data');
        break;
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
      showLinkExpiredOrInvalidMessage();
    }
  }
}

/// Helper method to show the user a message about the link status
void showLinkExpiredOrInvalidMessage() {
  // DialogHelper.onLinkExpires();
}
