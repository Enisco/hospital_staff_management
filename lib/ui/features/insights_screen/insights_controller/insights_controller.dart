// ignore_for_file: avoid_log.d

import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_model/feed_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';

var log = getLogger('InsightsController');

class InsightsController extends GetxController {
  InsightsController();

  bool loading = false;

  List<InsightsFeedModel> feedData = [];

  getFeeds() async {
    log.w("getting feeds");
    await refreshFeeds();
    update();
  }

  /// Format date string to datetime format
  // String formatToDateTime(String dateString) {
  //   DateTime tempDate = DateFormat("EEE, MMM d, yyyy hh:mm aaa").parse(
  //     dateString,
  //   );
  //   String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);
  //   log.d('formattedDate = $formattedDate');
  //   return formattedDate;
  // }

  // String formatCurrentTime() {
  //   DateTime now = DateTime.now();
  //   String lastTime =
  //       "${DateFormat.yMMMEd().format(now)} ${DateFormat.jm().format(DateTime.now())}";
  //   log.d(lastTime);
  //   return lastTime;
  // }

  Future<void> refreshFeeds() async {
    loading = true;
    update();
    feedData = [];
    final insightsFeedsRef = FirebaseDatabase.instance.ref("insights_feeds");

    insightsFeedsRef.onChildAdded.listen(
      (event) {
        log.wtf("Insights Data: ${event.snapshot.value.toString()}");
        InsightsFeedModel insightsFeed = insightsFeedModelFromJson(
          jsonEncode(event.snapshot.value).toString(),
        );
        feedData.add(insightsFeed);

        if (feedData.length > 1) {
          feedData.sort((a, b) => DateTime.parse(b.dateCreated)
              .compareTo(DateTime.parse(a.dateCreated)));

          loading = true;
          update();
        }

        loading = false;
        update();
        log.wtf("returned feeds: ${insightsFeed.toJson()}");
        log.d("Going again");
      },
    );
  }

  TextEditingController insightsTitleController = TextEditingController();
  TextEditingController insightsDescriptionController = TextEditingController();

  List<XFile> imageFilesSelected = [];
  int selectedImageIndex = 0;
  String? createInsightsId;

  resetValues() {
    loading = false;

    insightsTitleController = TextEditingController();
    insightsDescriptionController = TextEditingController();

    imageFilesSelected = [];
    update();
  }

  String generateRandomInsightId() {
    Random random = Random();
    int randomNumber1 = random.nextInt(10000);
    int randomNumber2 = random.nextInt(99999);
    createInsightsId = GlobalVariables.myUsername.toString() +
        randomNumber1.toString() +
        randomNumber2.toString();
    update();
    log.d("Generated Random Insight Id: $createInsightsId");
    return createInsightsId!;
  }

  void changeSelectedImageIndex(int selectedPickIndex) {
    selectedImageIndex = selectedPickIndex;
    update();
  }

  /// Upload image from gallery
  uploadfromGallery() async {
    List<XFile> selectedImages = await ImagePicker().pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (selectedImages.isNotEmpty) {
      if (selectedImages.length > 4) {
        selectedImages = [
          selectedImages[0],
          selectedImages[1],
          selectedImages[2],
          selectedImages[3],
        ];
      }

      imageFilesSelected.addAll(selectedImages);
      update();
      log.d("Image List Length:${imageFilesSelected.length}");
    } else {
      log.d("No Image selected");
    }
    log.d("Returning");
  }

  Future<void> uploadCreatedInsightData(BuildContext context) async {
    if (insightsTitleController.text.trim().isNotEmpty &&
        insightsDescriptionController.text.trim().isNotEmpty &&
        imageFilesSelected.isNotEmpty) {
      loading = true;
      update();
      createInsightsId = generateRandomInsightId();

      try {
        /// Upload image to cloud storage
        final firebaseStorage = FirebaseStorage.instance;
        List<String> downloadUrls = [];

        StaffAccountModel myAccountData = StaffAccountModel();

        for (int index = 0; index < imageFilesSelected.length; index++) {
          var snapshot = await firebaseStorage
              .ref()
              .child(
                  'hospital_staff_management/insights_data_images/$createInsightsId/${index + 1}')
              .putFile(File(imageFilesSelected[index].path))
              .whenComplete(() => log.w("Uploaded image ${index + 1}"));

          /// Generate download links
          var downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }
        log.w("downloadUrls: $downloadUrls");
        update();

        // String dateString = formatCurrentTime();
        String dateString = DateTime.now().toIso8601String();
        log.wtf("dateString: $dateString");

        /// Get my details from RT Db
        final getDataRef = FirebaseDatabase.instance.ref();
        DataSnapshot? getDataSnapshot;

        if (GlobalVariables.myUsername.contains('admin') == true) {
          getDataSnapshot =
              await getDataRef.child(GlobalVariables.myUsername).get();
        } else {
          getDataSnapshot = await getDataRef
              .child('user_details/${GlobalVariables.myUsername}')
              .get();
        }

        if (getDataSnapshot.exists) {
          log.d("User exists: ${getDataSnapshot.value}");

          StaffAccountModel userAccountModel = staffAccountModelFromJson(
              jsonEncode(getDataSnapshot.value).toString());
          log.w("Retrieved account name: ${userAccountModel.fullName}");

          myAccountData = userAccountModel;
          update();
        }
        log.wtf("myAccountData: ${myAccountData.toJson()}");

        /// Map data
        InsightsFeedModel insightsData = InsightsFeedModel(
          fullName: myAccountData.fullName ?? GlobalVariables.myUsername,
          thumbsUp: 0,
          feedCoverPictureLink: downloadUrls,
          feedName: insightsTitleController.text.trim(),
          feedDescription: insightsDescriptionController.text.trim(),
          userProfilePicsLink: myAccountData.image ??
              dummyAvatarUrl(myAccountData.gender ?? 'male'),
          dateCreated: dateString,
        );

        log.wtf('Insights Data to be uploaded: ${insightsData.toJson()}');

        /// Upload data to firestore
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("insights_feeds/$createInsightsId");

        await ref.set(insightsData.toJson()).then((value) async {
          log.w("Insight posted");
          context.pop();
        });
      } catch (e) {
        showCustomSnackBar(context, "Ensure all fields are filled", () {},
            AppColors.fullBlack, 1000);
      }
    } else {
      showCustomSnackBar(context, "Ensure all fields are filled", () {},
          AppColors.fullBlack, 1000);
    }
    // resetValues();
    update();
  }
}
