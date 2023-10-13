// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/helpers/sharedprefs.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/admin_models.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';

var log = getLogger('CreateUserController');

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginController();

  bool showLoading = false;
  String errMessage = '',
      userExisting = ' ',
      countrySelected = ' ',
      stateSelected = ' ',
      citySelected = ' ';

  File? imageFile;
  String? imageUrl;

  void resetValues() {
    errMessage = "";
    showLoading = false;
    update();
  }

  updateVals() {
    update();
  }

  void gotoSignInUserPage(BuildContext context) {
    log.d('Going to sign in user page');
    resetValues();
    context.push('/SignInView');
  }

  void gotoHomepage(BuildContext context) {
    log.d('Going to homepage page');
    resetValues();
    context.go('/homepageView');
  }

  void attemptToSignInUser(BuildContext context) {
    log.d('attemptToSignInUser . . .');
    errMessage = '';

    if (usernameController.text.trim().isNotEmpty &&
        !usernameController.text.trim().contains(" ") &&
        passwordController.text.trim().isNotEmpty &&
        !passwordController.text.trim().contains(" ")) {
      log.d('signing in user . . .');
      String enteredUsername = usernameController.text.trim();
      showLoading = true;
      errMessage = '';
      update();
      if (enteredUsername.contains("admin") == true) {
        checkIfAdminExistsForSignIn(context);
      } else {
        checkIfStaffExistsForSignIn(context);
      }
    } else {
      errMessage = 'All fields must be filled, and with no spaces';
      log.d("Errormessage: $errMessage");
      showLoading = false;
      update();
    }
  }

  Future<void> checkIfAdminExistsForSignIn(BuildContext context) async {
    log.d('checking if User Exists');
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child(usernameController.text.trim()).get();
    if (snapshot.exists) {
      log.d("User exists: ${snapshot.value}");
      AdminAccountModel adminLoginData =
          adminAccountModelFromJson(jsonEncode(snapshot.value).toString());
      log.d(
          "adminLoginData: ${adminLoginData.toJson()} \nPassword Existing: ${adminLoginData.password}");
      if (adminLoginData.password == passwordController.text.trim()) {
        showLoading = false;
        update();
        GlobalVariables.myUsername = usernameController.text.trim();
        log.d("GlobalVariables Username: ${GlobalVariables.myUsername}");
        GlobalVariables.accountType = "admin";
        saveSharedPrefsStringValue(
            "myUsername", usernameController.text.trim());
        saveSharedPrefsStringValue("accountType", "admin");
        log.wtf("Logged in as ${GlobalVariables.accountType}");
        gotoHomepage(context);
      } else {
        log.d('Password does not match.');
        errMessage = "Error! username or password incorrect";
        showLoading = false;
        update();
      }
    } else {
      log.d('User data does not exist.');
      errMessage = "Error! User ${usernameController.text.trim()} not found";
      showLoading = false;
      update();
    }
  }

  Future<void> checkIfStaffExistsForSignIn(BuildContext context) async {
    log.d('checking if User Exists');
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('staffs/${usernameController.text.trim()}').get();
    if (snapshot.exists) {
      log.d("User exists: ${snapshot.value}");
      StaffAccountModel userAccountModel = staffAccountModelFromJson(
        jsonEncode(snapshot.value).toString(),
      );
      log.d(
          "UserAccountModel: ${userAccountModel.toJson()} \nPassword Existing: ${userAccountModel.password}");
      if (userAccountModel.password == passwordController.text.trim()) {
        showLoading = false;
        update();
        GlobalVariables.myUsername = usernameController.text.trim();
        GlobalVariables.accountType = "staff";
        log.d("GlobalVariables Username: ${GlobalVariables.myUsername}");
        saveSharedPrefsStringValue(
            "myUsername", usernameController.text.trim());
        saveSharedPrefsStringValue("accountType", "staff");
        gotoHomepage(context);
        log.wtf("Logged in as ${GlobalVariables.accountType}");
        gotoHomepage(context);
      } else {
        log.d('Password does not match.');
        errMessage = "Error! username or password incorrect";
        showLoading = false;
        update();
      }
    } else {
      log.d('User data does not exist.');
      errMessage = "Error! User ${usernameController.text.trim()} not found";
      showLoading = false;
      update();
    }
  }

  /// Upload image from gallery
  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  /// Snap image with Camera
  getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }
}
