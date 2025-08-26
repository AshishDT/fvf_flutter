import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_bet.dart';
import '../models/md_round.dart';

/// Create bet api repository
class CreateBetApiRepo {
  /// Get question
  static Future<MdBet?> getQuestion() async => APIWrapper.handleApiCall<MdBet?>(
        APIService.get<Map<String, dynamic>>(
          path: 'question/weekly',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdBet> data = ApiResponse<MdBet>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdBet.fromJson(json),
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

  /// Create round
  static Future<MdRound?> createRound({
    required String prompt,
    bool isCustomPrompt = false,
  }) async =>
      APIWrapper.handleApiCall<MdRound>(
        APIService.post<Map<String, dynamic>>(
          path: 'round/create',
          data: <String, dynamic>{
            'prompt': prompt,
            'is_custom_prompt': isCustomPrompt
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
