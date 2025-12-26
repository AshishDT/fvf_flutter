import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/models/md_user.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_check_phone.dart';

/// Claim phone api repository
class ClaimPhoneApiRepo {
  /// Create round
  static Future<MdCheckPhone?> checkPhone({
    required String phone,
    required String phoneCode,
  }) async =>
      APIWrapper.handleApiCall<MdCheckPhone>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/check-phone',
          data: <String, dynamic>{
            'phone': phone,
            'country_code': phoneCode,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdCheckPhone> data =
                ApiResponse<MdCheckPhone>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdCheckPhone.fromJson(json),
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

  /// Login
  static Future<MdUser?> login({
    required String phone,
    required String phoneCode,
    required String fcmToken,
    required String userId,
    String? dob,
  }) async =>
      APIWrapper.handleApiCall<MdUser>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/login',
          data: <String, dynamic>{
            'phone': phone,
            'country_code': phoneCode,
            'fcm_token': fcmToken,
            'id': userId,
            if (dob != null && dob.isNotEmpty) 'dob': dob,
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
