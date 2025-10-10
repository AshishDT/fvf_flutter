import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Report api repo
class ReportApiRepo {
  /// Claim subscription
  static Future<bool?> report({
    required String title,
    String? description,
  }) async =>
      APIWrapper.handleApiCall<bool?>(
        APIService.post<Map<String, dynamic>>(
          path: 'report/create',
          data: <String, dynamic>{
            'title': title,
            'description': description,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<bool?> data = ApiResponse<bool>.fromJson(
              response!.data!,
            );

            if (data.success ?? false) {
              return true;
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
