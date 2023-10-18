import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/app/resources/app.locator.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/fcm_services/push_notification_service.dart';
import 'package:hospital_staff_management/firebase_options.dart';
import 'package:hospital_staff_management/hosp_staff_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

var log = getLogger('main');

final _pushMessagingNotification = locator<PushNotificationService>();

Future myBackgroundMessageHandler(RemoteMessage message) async {
  log.w("onBackgroundMessage: From ${message.data['name']}");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log.w('Show notification');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();

  await FirebaseMessaging.instance.getInitialMessage();
  await _pushMessagingNotification.initialize();
  //Handle Push Notification when app is in background and when app is terminated
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(HospStaffApp());
}
