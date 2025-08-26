import 'package:get/get.dart';

import '../modules/age_input/bindings/age_input_binding.dart';
import '../modules/age_input/views/age_input_view.dart';
import '../modules/ai_choosing/bindings/ai_choosing_binding.dart';
import '../modules/ai_choosing/views/ai_choosing_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/create_bet/bindings/create_bet_binding.dart';
import '../modules/create_bet/views/create_bet_view.dart';
import '../modules/failed_round/bindings/failed_round_binding.dart';
import '../modules/failed_round/views/failed_round_view.dart';
import '../modules/pick_crew/bindings/pick_crew_binding.dart';
import '../modules/pick_crew/views/pick_crew_view.dart';
import '../modules/premium_winner/bindings/premium_winner_binding.dart';
import '../modules/premium_winner/views/premium_winner_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/snap_selfies/bindings/snap_selfies_binding.dart';
import '../modules/snap_selfies/views/snap_selfies_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/winner/bindings/winner_binding.dart';
import '../modules/winner/views/winner_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_BET,
      page: () => const CreateBetView(),
      binding: CreateBetBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.AI_CHOOSING,
      page: () => const AiChoosingView(),
      binding: AiChoosingBinding(),
    ),
    GetPage(
      name: _Paths.PICK_CREW,
      page: () => const PickCrewView(),
      binding: PickCrewBinding(),
    ),
    GetPage(
      name: _Paths.AGE_INPUT,
      page: () => const AgeInputView(),
      binding: AgeInputBinding(),
    ),
    GetPage(
      name: _Paths.SNAP_SELFIES,
      page: () => const SnapSelfiesView(),
      binding: SnapSelfiesBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: _Paths.WINNER,
      page: () => const WinnerView(),
      binding: WinnerBinding(),
    ),
    GetPage(
      name: _Paths.PREMIUM_WINNER,
      page: () => const PremiumWinnerView(),
      binding: PremiumWinnerBinding(),
    ),
    GetPage(
      name: _Paths.FAILED_ROUND,
      page: () => const FailedRoundView(),
      binding: FailedRoundBinding(),
    ),
  ];
}
