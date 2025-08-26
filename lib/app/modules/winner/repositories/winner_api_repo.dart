import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_round_details.dart';

/// Winner api repository
class WinnerApiRepo {
  /// Get round details
  static Future<MdRoundDetails?> getRoundDetails({
    required String roundId,
  }) async =>
      APIWrapper.handleApiCall<MdRoundDetails?>(
        APIService.get<Map<String, dynamic>>(
          path: 'round/details/$roundId',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdRoundDetails> data =
                ApiResponse<MdRoundDetails>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdRoundDetails.fromJson(json),
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
