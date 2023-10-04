import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/app/resources/app.locator.dart';
import 'package:hospital_staff_management/firebase_options.dart';
import 'package:hospital_staff_management/hosp_staff_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  runApp(HospStaffApp());
}
