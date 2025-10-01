import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/splash/splash_api_repo.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/utils/app_config.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Splash Controller
class SplashController extends GetxController {
  /// On init
  @override
  void onInit() {
    setAppConfig();
    setPurchaseId();
    Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        if (SupaBaseService.isLoggedIn) {
          Get.offAllNamed(Routes.CREATE_BET);
        } else {
          Get.offAllNamed(Routes.AUTH);
        }
      },
    );
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

  /// Set purchase id
  Future<void> setPurchaseId() async {
    final bool? isAnonymous = await Purchases.isAnonymous;

    final String supabaseId = UserProvider.currentUser?.supabaseId ?? '';

    if (!(isAnonymous ?? false) && UserProvider.currentUser != null) {
      if (supabaseId.isNotEmpty) {
        logW('Login to purchase with supabase Id |Splash| $supabaseId');
        await Purchases.logIn(supabaseId);
      }
    }
  }

  /// Set app config
  Future<void> setAppConfig() async {
    final Map<String, dynamic>? _config =
        await SplashScreenApiRepo.getAppConfig();

    if (_config != null) {
      final int? maxParticipants = _config['max_part'];

      final int? minParticipants = _config['min_part'];

      final int? minSubmission = _config['min_sub'];

      final num? roundDuration = _config['round_duration'];

      if (maxParticipants != null) {
        AppConfig.maxPart = maxParticipants;
      }

      if (minParticipants != null) {
        AppConfig.minPart = minParticipants;
      }

      if (minSubmission != null) {
        AppConfig.minSubmissions = minSubmission;
      }

      if (roundDuration != null) {
        AppConfig.roundDurationInMinutes = roundDuration;
      }
    }
  }
}
