import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/locale_provider.dart';
import 'package:fvf_flutter/app/data/local/theme_provider.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
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

  APIService.initializeAPIService(
    encryptData: encryption,
  );
}
