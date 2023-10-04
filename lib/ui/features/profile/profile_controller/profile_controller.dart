// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hospital_staff_management/app/helpers/sharedprefs.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/create_account_model.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';

var log = getLogger('ProfileController');

class ProfileController extends GetxController {
  ProfileController();

  bool detailsLoaded = false;
  String profileImageLink = ' ';
  UserAccountModel myAccountData = UserAccountModel();

  getMyProfileData() async {
    await retrieveSavedProfileImageLink();
    await getMyProfileDataFromDb();
  }

  retrieveSavedProfileImageLink() async {
    String link = await getSharedPrefsSavedString("profileImageLink");
    profileImageLink = link;
    update();
  }

  Future<void> getMyProfileDataFromDb() async {
    final getDataRef = FirebaseDatabase.instance.ref();
    final getDataSnapshot = await getDataRef
        .child('user_details/${GlobalVariables.myUsername}')
        .get();

    if (getDataSnapshot.exists) {
      print("User exists: ${getDataSnapshot.value}");

      UserAccountModel userAccountModel = userAccountModelFromJson(
          jsonEncode(getDataSnapshot.value).toString());
      myAccountData = userAccountModel;
      detailsLoaded = true;
      update();
    }
  }
}
