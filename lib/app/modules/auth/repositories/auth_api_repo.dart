import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';

/// Auth API Repository
class AuthApiRepo {
  /// Create user
  static Future<bool?> createUser({
    required String supabaseId,
    required int age,
  }) async =>
      APIWrapper.handleApiCall<bool>(
        APIService.post<Map<String, dynamic>>(
          path: 'user/create-anonymous-user',
          data: <String, dynamic>{
            'supabase_id': supabaseId,
            'age': age,
          },
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<bool> data = ApiResponse<bool>.fromJson(
              response!.data!,
            );

            if (data.success == true) {
              return true;
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

  /// Get cancellation details
// static Future<bool?> getCancellationDetails({
//   required String projectId,
// }) async =>
//     APIWrapper.handleApiCall<bool?>(
//       APIService.get<Map<String, dynamic>>(
//         path: 'cancel-project/details/$projectId',
//       ).then(
//             (Response<Map<String, dynamic>>? response) {
//           if (response?.isOk != true || response?.data == null) {
//             return null;
//           }
//
//           final ApiResponse<bool> data =
//           ApiResponse<MdCancelProjectDetails>.fromJson(
//             response!.data!,
//             fromJsonT: (dynamic json) =>
//                 MdCancelProjectDetails.fromJson(json),
//           );
//
//           if (data.success ?? false) {
//             return data.data;
//           }
//
//           appSnackbar(
//             message:
//             data.message ?? LocaleKeys.snack_bar_something_went_wrong.tr,
//             snackbarState: SnackbarState.danger,
//           );
//           return null;
//         },
//       ),
//     );

  /// Send offer to cancel project
// static Future<bool?> sendOffer({
//   required String projectId,
//   num? amount,
// }) async =>
//     APIWrapper.handleApiCall<bool>(
//       APIService.post<Map<String, dynamic>>(
//         path: 'cancel-project/send-offer',
//         data: <String, dynamic>{
//           'project_id': projectId,
//           'amount': amount,
//         },
//       ).then(
//             (Response<Map<String, dynamic>>? response) {
//           if (response?.isOk != true || response?.data == null) {
//             return null;
//           }
//
//           final ApiResponse<bool> data = ApiResponse<bool>.fromJson(
//             response!.data!,
//           );
//
//           if (data.success == true) {
//             return true;
//           }
//
//           appSnackbar(
//             message:
//             data.message ?? LocaleKeys.snack_bar_something_went_wrong.tr,
//             snackbarState: SnackbarState.danger,
//           );
//           return null;
//         },
//       ),
//     );
}
