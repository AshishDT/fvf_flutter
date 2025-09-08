import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/locale_provider.dart';
import 'package:fvf_flutter/app/data/local/theme_provider.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/data/remote/notification_service/notification_actions.dart';
import 'package:fvf_flutter/app/data/remote/notification_service/notification_service.dart';
import 'package:fvf_flutter/app/data/remote/revenue_cat/revenue_cat_service.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

/// Initialize all core functionalities
Future<void> initializeCoreApp({
  bool encryption = false,
}) async {
  initLogger();

  await GetStorage.init();
  UserProvider.loadUser();
  LocaleProvider.loadCurrentLocale();
  await ThemeProvider.getThemeModeFromStore();

  await SupaBaseService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init(
    onPush: onPush,
    onLocal: onLocal,
  );

  await RevenueCatService.instance.initRevenueCat();

  // Initialize branch
  await FlutterBranchSdk.init();

  APIService.initializeAPIService(
    encryptData: encryption,
  );
}
