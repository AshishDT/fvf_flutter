import 'package:dio/dio.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';

import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Profile API Repository
class ProfileApiRepo {
  /// Get user
  static Future<MdProfile?> getUser() async =>
      APIWrapper.handleApiCall<MdProfile>(
        APIService.get<Map<String, dynamic>>(
          path: 'user/profile',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdProfile> data = ApiResponse<MdProfile>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdProfile.fromJson(json),
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

  /// Update user
  static Future<MdProfile?> updateUser({
    required String username,
    required String profilePic,
  }) async =>
      APIWrapper.handleApiCall<MdProfile>(
        APIService.put<Map<String, dynamic>>(
          path: 'user/update',
          data: {
            'profile_pic': profilePic,
            'username': username,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdProfile> data = ApiResponse<MdProfile>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdProfile.fromJson(json),
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
