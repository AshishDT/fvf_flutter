import 'package:dio/dio.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_bet.dart';
import '../models/md_can_create_bet.dart';
import '../models/md_round.dart';

/// Create bet api repository
class CreateBetApiRepo {
  /// Get question
  static Future<List<MdBet>?> getQuestion() async =>
      APIWrapper.handleApiCall<List<MdBet>?>(
        APIService.get<Map<String, dynamic>>(
          path: 'question/weekly',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<List<MdBet>> data =
                ApiResponse<List<MdBet>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => List<MdBet>.from(
                (json as List<dynamic>).map<MdBet>(
                  (dynamic x) => MdBet.fromJson(x as Map<String, dynamic>),
                ),
              ),
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

  /// Can create round
  static Future<MdCanCreateBet?> canCreateRound() async =>
      APIWrapper.handleApiCall<MdCanCreateBet>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/can-create-round',
        ).then(
              (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdCanCreateBet> data = ApiResponse<MdCanCreateBet>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdCanCreateBet.fromJson(json),
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


  /// User Claim
  static Future<MdUser?> userClaim({
    required String phone,
    required String countryCode,
    required String supabaseId,
  }) async =>
      APIWrapper.handleApiCall<MdUser>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/claim',
          data: <String, dynamic>{
            'phone': phone,
            'country_code': countryCode,
            'supabase_id': supabaseId,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdUser> data = ApiResponse<MdUser>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdUser.fromJson(json),
            );

            if (data.success == true) {
              appSnackbar(
                message: data.message ?? '',
                snackbarState: SnackbarState.success,
              );
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
