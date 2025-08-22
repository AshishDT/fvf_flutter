import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Create bet api repository
class CreateBetApiRepo {
  /// Get bets
  static Future<List<String>?> getBets() async =>
      APIWrapper.handleApiCall<List<String>?>(
        APIService.get<Map<String, dynamic>>(
          path: 'round/questions',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<List<String>> data =
                ApiResponse<List<String>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => List<String>.from(json as List),
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
