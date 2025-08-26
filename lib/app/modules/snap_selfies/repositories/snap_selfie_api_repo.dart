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

  /// Get Pre-Selfie Actions
  static Future<List<String>?> getPreSelfieActions() async =>
      APIWrapper.handleApiCall<List<String>?>(
        APIService.get<Map<String, dynamic>>(
          path: 'round/random-pre-selfie-action',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<List<String>> data =
                ApiResponse<List<String>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) =>
                  List<String>.from(json as List<dynamic>),
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
