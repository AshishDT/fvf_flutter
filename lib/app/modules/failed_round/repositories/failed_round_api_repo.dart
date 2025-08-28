import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../create_bet/models/md_round.dart';

/// Failed Round API Repository
class FailedRoundApiRepo {
  /// Re-run a round with the given prompt
  static Future<MdRound?> reRun({
    required String roundId,
    bool isCustomPrompt = false,
  }) async =>
      APIWrapper.handleApiCall<MdRound>(
        APIService.post<Map<String, dynamic>>(
          path: 'round/re-run',
          data: <String, dynamic>{
            'round_id': roundId,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdRound> data = ApiResponse<MdRound>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdRound.fromJson(json),
            );

            if (data.success == true) {
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
