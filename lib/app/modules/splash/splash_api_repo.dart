import 'package:dio/dio.dart';
import '../../data/models/api_reponse.dart';
import '../../data/remote/api_service/api_wrapper.dart';
import '../../data/remote/api_service/init_api_service.dart';
import '../../ui/components/app_snackbar.dart';

/// Splash screen api repo
class SplashScreenApiRepo {
  /// Get app config
  static Future<Map<String, dynamic>?> getAppConfig() async =>
      APIWrapper.handleApiCall<Map<String, dynamic>?>(
        APIService.get<Map<String, dynamic>>(
          path: 'app-config',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<Map<String, dynamic>> data =
                ApiResponse<Map<String, dynamic>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => json as Map<String, dynamic>,
            );

            if (data.success ?? false) {
              return data.data;
            }

            appSnackbar(
              message:
                  data.message ?? 'Something went wrong, please try again.',
              snackbarState: SnackbarState.danger,
            );
            return null;
          },
        ),
      );
}
