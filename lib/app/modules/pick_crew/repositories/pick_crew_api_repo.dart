import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Pick crew api repository
class PickCrewApiRepo {
  /// Join invitation
  static Future<MdJoinInvitation?> joinInvitation({
    required String roundId,
  }) async =>
      APIWrapper.handleApiCall<MdJoinInvitation>(
        APIService.post<Map<String, dynamic>>(
          path: 'round/join',
          data: <String, dynamic>{
            'round_id': roundId,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<MdJoinInvitation> data =
                ApiResponse<MdJoinInvitation>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) =>
                  MdJoinInvitation.fromJson(json as Map<String, dynamic>),
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
