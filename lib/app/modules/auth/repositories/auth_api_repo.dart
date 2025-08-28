import 'package:dio/dio.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Auth API Repository
class AuthApiRepo {
  /// Create user
  static Future<MdUser?> createUser({
    required String supabaseId,
    required int age,
    required String fcmToken,
  }) async =>
      APIWrapper.handleApiCall<MdUser>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/create-anonymous-user',
          data: <String, dynamic>{
            'supabase_id': supabaseId,
            'age': age,
            'fcm_token': fcmToken,
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
