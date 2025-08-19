import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/create_bet/bindings/create_bet_binding.dart';
import '../modules/create_bet/views/create_bet_view.dart';
import '../modules/pick_crew/bindings/pick_crew_binding.dart';
import '../modules/pick_crew/views/pick_crew_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

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
      name: _Paths.PICK_CREW,
      page: () => const PickCrewView(),
      binding: PickCrewBinding(),
    ),
  ];
}
