import 'dart:async';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import '../../../utils/app_config.dart';
import '../../config/logger.dart';
import 'deep_link_incoming_data_handler.dart';

/// Deep link service
class DeepLinkService {
  /// Branch deep link listener
  static StreamSubscription<dynamic>? branchSubscription;

  /// Generate slay invite link
  static Future<String?> generateSlayInviteLink({
    required String title,
    required String invitationId,
    required String hostId,
  }) async {
    final BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'slay_invite',
      title: title,
      contentDescription: 'Slay invite deep link',
      expirationDateInMilliSec: _expiryTime,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('invitation_id', invitationId)
        ..addCustomMetadata('host_id', hostId),
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

  /// Get the expiry time for the link
  static int get _expiryTime => DateTime.now()
      .toUtc()
      .add(
        Duration(seconds: AppConfig.roundDurationInSeconds),
      )
      .millisecondsSinceEpoch;

  /// Initialize deep link listener
  static void initBranchListener() {
    branchSubscription = FlutterBranchSdk.listSession().listen(
      (Map<dynamic, dynamic> data) {
        handleDeepLinkIncomingData(data);
      },
      onError: (dynamic error) {
        logE('Branch error: $error');
      },
    );
  }
}
