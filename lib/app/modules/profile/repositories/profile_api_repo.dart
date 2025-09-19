import 'package:dio/dio.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_badge.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_user_rounds.dart';

import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Profile API Repository
class ProfileApiRepo {
  /// Get user
  static Future<MdProfile?> getUser({
    String? userId,
  }) async =>
      APIWrapper.handleApiCall<MdProfile>(
        APIService.get<Map<String, dynamic>>(
          path: 'user/profile',
          params: userId != null && userId.isNotEmpty
              ? <String, dynamic>{'user_id': userId}
              : null,
        ).then(
          (Response<Map<String, dynamic>>? response) {
            logI('Get User Response: $response');
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
  static Future<bool> updateUser({
    String? username,
    String? profilePic,
  }) async =>
      APIWrapper.handleApiCall<bool>(
        APIService.put<Map<String, dynamic>>(
          path: 'user/update',
          data: <String, dynamic>{
            if (profilePic != null) 'profile_pic': profilePic,
            if (username != null) 'username': username,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return false;
            }

            final ApiResponse<MdProfile> data = ApiResponse<MdProfile>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => MdProfile.fromJson(json),
            );

            if (data.success == true) {
              return true;
            }

            appSnackbar(
              message:
                  data.message ?? 'Something went wrong, please try again.',
              snackbarState: SnackbarState.danger,
            );
            return false;
          },
        ),
      ).then((bool? value) => value ?? false);

  /// Get Participant
  static Future<List<MdRound>?> getRounds({
    required int skip,
    required int limit,
    String? userId,
  }) async =>
      APIWrapper.handleApiCall<List<MdRound>>(
        APIService.get<Map<String, dynamic>>(
          path: userId != null && userId.isNotEmpty
              ? 'round/user-rounds/$userId/$skip/$limit'
              : 'round/user-rounds/$skip/$limit',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdUserRounds> data =
                ApiResponse<MdUserRounds>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) =>
                  MdUserRounds.fromJson(json as Map<String, dynamic>),
            );

            if (data.success == true && data.data != null) {
              final List<MdRound> rounds = data.data!.rounds ?? <MdRound>[];
              return rounds;
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

  /// Get Badges
  static Future<List<MdBadge>?> getBadges({
    String? userId,
  }) async =>
      APIWrapper.handleApiCall<List<MdBadge>>(
        APIService.get<Map<String, dynamic>>(
          path: 'user-badge/badges',
          params: userId != null && userId.isNotEmpty
              ? <String, dynamic>{'user_id': userId}
              : null,
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<List<MdBadge>> data =
                ApiResponse<List<MdBadge>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => List<MdBadge>.from(
                (json as List<dynamic>).map<MdBadge>(
                  (dynamic x) => MdBadge.fromJson(x as Map<String, dynamic>),
                ),
              ),
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
