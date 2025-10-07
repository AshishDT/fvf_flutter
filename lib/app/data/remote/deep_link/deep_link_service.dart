import 'dart:async';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import '../../config/logger.dart';
import 'deep_link_incoming_data_handler.dart';

/// Deep link service
class DeepLinkService {
  /// Branch deep link listener
  static StreamSubscription<dynamic>? branchSubscription;

  /// Generate slay invite link (normal or view-only)
  static Future<String?> generateSlayInviteLink({
    required String title,
    required String invitationId,
    required String hostId,
    bool isViewOnly = false,
  }) async {
    final BranchContentMetaData metaData = BranchContentMetaData()
      ..addCustomMetadata('invitation_id', invitationId)
      ..addCustomMetadata('host_id', hostId);

    if (isViewOnly) {
      metaData.addCustomMetadata('is_view_only', true);
    }

    final BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'slay_invite',
      title: title,
      contentDescription:
          isViewOnly ? 'Slay view-only deep link' : 'Slay invite deep link',
      contentMetadata: metaData,
    );

    final BranchLinkProperties lp = BranchLinkProperties(
      tags: <String>['slay_invite'],
    );

    final BranchResponse<dynamic> response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );

    if (response.success) {
      return response.result;
    } else {
      logE(
          'Branch link generation failed: ${response.errorCode} - ${response.errorMessage}');
      return null;
    }
  }

  /// Initialize deep link listener
  static void initBranchListener() {
    if (branchSubscription != null) {
      return;
    }

    branchSubscription = FlutterBranchSdk.listSession().listen(
      (Map<dynamic, dynamic> data) {
        if (!data.containsKey('+clicked_branch_link')) {
          return;
        }

        final bool clicked = data['+clicked_branch_link'] == true;
        if (!clicked) {
          return;
        }

        handleDeepLinkIncomingData(data);
      },
      onError: (dynamic error) {
        logE('Branch error: $error');
      },
    );
  }
}
