import 'package:hospital_staff_management/app/resources/app.locator.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/fcm_services/network_service.dart';
import 'package:hospital_staff_management/app/services/fcm_services/push_notification_model.dart';
import 'package:hospital_staff_management/app/services/fcm_services/push_notification_service.dart';
import 'package:hospital_staff_management/app/services/navigation_service.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';

var log = getLogger('FcmService');

// CallModel callModel = CallModel();

class FcmService {
  Future sendPushNotification({
    required String receipientDeviceToken,
    required String notificationFrom,
    required String serverKey,
  }) async {
    try {
      var data = await _sendIndiePushNotification(
        receipientDeviceToken: receipientDeviceToken,
        serverKey: serverKey,
        notificationFrom: notificationFrom,
      );
      PushNotificationModel pushNotificationModel =
          PushNotificationModel.fromJson(data);
      if (pushNotificationModel.success == 1) {
        return data;
      }
    } catch (e) {
      log.w("Error sending notifications");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        "Error launching calls",
        () {},
        AppColors.fullBlack,
        2,
      );
    }
  }

  final _pushMessagingNotification = locator<PushNotificationService>();
  final _networkHelper = locator<NetworkServiceRepository>();

  final url = "https://fcm.googleapis.com/fcm/send";
  final _domain = "fcm.googleapis.com";
  final _subDomain = "fcm/send";
  // final _serverKey =
  // "AAAALQIUk38:APA91bFmDHUsvoi_ceAbCDuMNvKMJolFFj4ugGk-LbMqe1bSDAlWtCh2krx3vj0kC3Hxv9I2UhJbJhs1lalVBZvZUKVJwCud22syVBs_L-InLLYoTEujwrU_HCbCCCKWFaTW5G65y4Ua";

  // Method to send push notification
  Future _sendIndiePushNotification({
    required String receipientDeviceToken,
    required String notificationFrom,
    required String serverKey,
  }) async {
    Map<String, String> header = {
      'Authorization': 'key=$serverKey',
      'Content-type': 'application/json',
      'Accept': '/',
    };

    var deviceToken = _pushMessagingNotification.deviceToken;
    log.wtf("deviceToken: $deviceToken");

    var body = {
      "to": receipientDeviceToken,
      "priority": "high",
      "notification": {
        "title": "HSMS",
        "body":
            "You have new notifications from ${notificationFrom.toSentenceCase}",
        "sound": "default",
      },
    };

    var data = await _networkHelper.postData(
      domain: _domain,
      subDomain: _subDomain,
      header: header,
      isJson: true,
      body: body,
    );
    return data;
  }
}
