import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Snap Selfie API Repository
class SnapSelfieApiRepo {
  /// Submit Selfie
  static Future<bool?> submitSelfie({
    required String roundId,
    required String fileName,
  }) async =>
      APIWrapper.handleApiCall<bool>(
        APIService.post<Map<String, dynamic>>(
          path: 'round/submit-selfie',
          data: <String, dynamic>{
            'round_id': roundId,
            'file_name': fileName,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<bool> data = ApiResponse<bool>.fromJson(
              response!.data!,
            );

            if (data.success == true) {
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
