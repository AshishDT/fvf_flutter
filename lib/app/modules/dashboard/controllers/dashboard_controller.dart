import 'dart:ui';

import 'package:get/get.dart';

import '../../../data/enums/language_enum.dart';
import '../../../data/local/locale_provider.dart';

/// Dashboard controller
class DashboardController extends GetxController {
  /// On init
  @override
  void onInit() {
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

  /// On language change
  void onLanguageChange(LanguageEnum value) {
    if (value == LanguageEnum.hindi) {
      LocaleProvider.changeLocale(
        const Locale('hi_IN'),
      );
      return;
    }

    if (value == LanguageEnum.english) {
      LocaleProvider.changeLocale(
        const Locale('en_US'),
      );
      return;
    }
  }
}
