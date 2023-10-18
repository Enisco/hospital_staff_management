// ignore_for_file: avoid_log.d

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';

var log = getLogger('RecordPageView');

enum GenderType { male, female, others, gender }

class CreateStaffAccountController extends GetxController {
  CreateStaffAccountController();

  bool showLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GenderType? selectedGender;

  File? selectedImage;
  String? birthYear;

  setBirthYear(String yearSelected) {
    birthYear = yearSelected;
    update();
  }

  resetValues() {
    showLoading = false;

    usernameController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    departmentController = TextEditingController();

    selectedImage = null;
    birthYear = null;
    selectedGender = null;

    update();
  }

  /// Select Profile image from gallery
  selectProfilePicture() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
      log.wtf("Profile Image selected");
    } else {
      log.w("No Image selected");
    }
  }

  Future<void> uploadNewStaffData(BuildContext context) async {
    if (usernameController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        fullNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        selectedGender != GenderType.gender &&
        birthYear != null &&
        selectedImage != null) {
      showLoading = true;
      update();

      /// Upload image to cloud storage
      final firebaseStorage = FirebaseStorage.instance;

      var snapshot = await firebaseStorage
          .ref()
          .child('staffs/${usernameController.text.trim()}')
          .putFile(selectedImage!)
          .whenComplete(() => log.w("Uploaded staff profile image"));

      /// Generate download links
      var downloadUrl = await snapshot.ref.getDownloadURL();
      log.w("staff profile image link: $downloadUrl");

      /// Map data
      StaffAccountModel newUserData = StaffAccountModel(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        image: downloadUrl,
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        gender: selectedGender.toString().toSentenceCase,
        department: departmentController.text.trim(),
        yearOfBirth: birthYear,
      );

      log.wtf('newUserData to be uploaded: ${newUserData.toJson()}');

      /// Upload data to FirebaseDatabase
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        "staffs/${newUserData.username}",
      );

      await ref.set(newUserData.toJson()).then((val) async {
        showCustomSnackBar(
          context,
          const Row(children: [
            Icon(Icons.check_circle_outline_rounded),
            SizedBox(width: 5),
            Text("Successful! Staff Data Recorded."),
          ]),
          () {},
          AppColors.fullBlack,
          1500,
        );
        resetValues();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      });
    } else {
      showCustomSnackBar(context, "Ensure all fields are filled", () {},
          AppColors.fullBlack, 1000);
    }
  }
}
