import 'dart:async';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/utils/app_loader.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../routes/app_pages.dart';

/// Pick crew controller
class PickCrewController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      bet.value = Get.arguments as String;
      bet.refresh();
    }
    super.onInit();
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    super.onClose();
  }

  /// Observable for bet text
  RxString bet = ''.obs;

  /// Share text
  Future<void> shareUri() async {
    Loader.show();
    await Future<void>.delayed(
      const Duration(seconds: 3),
      () {
        Loader.dismiss();
        SharePlus.instance
            .share(
          ShareParams(
            uri: Uri.parse(
              'https://slay.app/invite?bet=${Uri.encodeComponent(bet.value)}',
            ),
            title: 'Slay',
            subject: 'Slay Invitation',
          ),
        )
            .then(
          (ShareResult result) {
            if (result.status == ShareResultStatus.success) {
              appSnackbar(
                message: 'Invitation shared successfully!',
                snackbarState: SnackbarState.success,
              );
              Get.toNamed(
                Routes.SNAP_SELFIES,
                arguments: bet.value,
              );
            }
          },
        );
      },
    );
    Loader.dismiss();
  }
// Future<void> shareUri() async {
//   Loader.show();
//   try {
//     final String? _invitationLink =
//         await DeepLinkService.generateSlayInviteLink(
//       title: bet(),
//       invitationId: '1',
//     );
//
//     if (_invitationLink == null || _invitationLink.isEmpty) {
//       Loader.dismiss();
//       appSnackbar(
//         message: 'Failed to generate invitation link. Please try again.',
//         snackbarState: SnackbarState.danger,
//       );
//       return;
//     }
//
//     final Uri uri = Uri.parse(_invitationLink);
//
//     Loader.dismiss();
//
//     unawaited(
//       SharePlus.instance
//           .share(
//         ShareParams(
//           uri: uri,
//           title: 'Slay',
//           subject: 'Slay Invitation',
//         ),
//       )
//           .then(
//         (ShareResult result) {
//           if (result.status == ShareResultStatus.success) {
//             appSnackbar(
//               message: 'Invitation shared successfully!',
//               snackbarState: SnackbarState.success,
//             );
//             Get.toNamed(
//               Routes.SNAP_SELFIES,
//               arguments: bet.value,
//             );
//           }
//         },
//       ),
//     );
//   } on Exception {
//     Loader.dismiss();
//   } finally {
//     Loader.dismiss();
//   }
// }
}
