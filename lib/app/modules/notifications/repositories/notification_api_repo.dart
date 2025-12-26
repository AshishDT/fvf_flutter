import 'package:dio/dio.dart';
import '../../../data/models/api_reponse.dart';
import '../../../data/remote/api_service/api_wrapper.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_notification.dart';

/// Notification API Repository
class NotificationApiRepo {
  /// Get Badges
  static Future<List<MdNotification>?> getNotifications({
    String? userId,
  }) async =>
      APIWrapper.handleApiCall<List<MdNotification>>(
        APIService.get<Map<String, dynamic>>(
          path: 'notification/list',
        ).then(
          (Response<Map<String, dynamic>>? response) {
            if (response?.isOk != true || response?.data == null) {
              return null;
            }

            final ApiResponse<List<MdNotification>> data =
                ApiResponse<List<MdNotification>>.fromJson(
              response!.data!,
              fromJsonT: (dynamic json) => List<MdNotification>.from(
                (json as List<dynamic>).map<MdNotification>(
                  (dynamic x) =>
                      MdNotification.fromJson(x as Map<String, dynamic>),
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
