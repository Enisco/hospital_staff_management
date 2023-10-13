// ignore_for_file: avoid_print

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
import 'package:intl/intl.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:provider/provider.dart';

var log = getLogger('RecordPageView');

// ignore: constant_identifier_names
enum ToponymTypes { Natural, Artificial }

class RecordToponymController extends GetxController {
  RecordToponymController();

  bool loading = false;

  List<InsightsFeedModel> feedData = [
    // sampleFeedData2,
    // sampleFeedData3,
    // sampleFeedData0,
    // sampleFeedData1,
    // sampleFeedData4
  ];

  getFeeds() async {
    log.w("getting feeds");
    await refreshFeeds();
    update();
  }

  /// Format date string to datetime format
  String formatToDateTime(String dateString) {
    DateTime tempDate = DateFormat("EEE, MMM d, yyyy hh:mm aaa").parse(
      dateString,
    );
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);
    print('formattedDate = $formattedDate');
    return formattedDate;
  }

  Future<void> refreshFeeds() async {
    final toponysFeedsRef = FirebaseDatabase.instance.ref("insights_feeds");

    toponysFeedsRef.onChildAdded.listen(
      (event) {
        InsightsFeedModel insightsFeed = insightsFeedModelFromJson(
          jsonEncode(event.snapshot.value).toString(),
        );
        feedData.add(insightsFeed);

        if (feedData.length > 1) {
          feedData.sort((a, b) => formatToDateTime(b.dateCreated)
              .compareTo(formatToDateTime(a.dateCreated)));

          loading = true;
          update();
        }

        log.wtf("returned feeds: ${insightsFeed.toJson()}");
        log.d("Going again");
      },
    );
  }

  TextEditingController insightsTitleController = TextEditingController();
  TextEditingController insightsDescriptionController = TextEditingController();

  var selectedToponymTypes = ToponymTypes.Natural;

  List<XFile> imageFilesSelected = [];
  int selectedImageIndex = 0;
  String? createInsightsId;

  resetValues() {
    loading = false;

    insightsTitleController = TextEditingController();
    insightsDescriptionController = TextEditingController();

    selectedToponymTypes = ToponymTypes.Natural;
    imageFilesSelected = [];
    update();
  }

  String generateRandomrecordToponymId() {
    Random random = Random();
    int randomNumber1 = random.nextInt(10000);
    int randomNumber2 = random.nextInt(99999);
    createInsightsId = GlobalVariables.myUsername.toString() +
        randomNumber1.toString() +
        randomNumber2.toString();
    update();
    print("GeneratedRandomRecordToponymId: $createInsightsId");
    return createInsightsId!;
  }

  String formatCurrentTime() {
    DateTime now = DateTime.now();
    String lastTime =
        "${DateFormat.yMMMEd().format(now)} ${DateFormat.jm().format(DateTime.now())}";
    print(lastTime);
    return lastTime;
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
      print("Image List Length:${imageFilesSelected.length}");
    } else {
      print("No Image selected");
    }
    print("Returning");
  }

  /// Snap image with Camera
  captureFromCamera() async {
    XFile? capturedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (capturedImage != null) {
      imageFilesSelected.add(capturedImage);
      update();
    } else {
      print("No Image selected");
    }
    print("Returning");
  }

  Future<void> uploadCreatedInsightData(BuildContext context) async {
    if (insightsTitleController.text.trim().isNotEmpty &&
        insightsDescriptionController.text.trim().isNotEmpty &&
        imageFilesSelected.isNotEmpty) {
      loading = true;
      update();
      createInsightsId = generateRandomrecordToponymId();

      /// Upload image to cloud storage
      final firebaseStorage = FirebaseStorage.instance;
      List<String> downloadUrls = [];

      StaffAccountModel myAccountData = StaffAccountModel();

      for (int index = 0; index < 4; index++) {
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

      String dateString = formatCurrentTime();
      log.wtf("dateString: $dateString");

      /// Get my details from RT Db
      final getDataRef = FirebaseDatabase.instance.ref();
      final getDataSnapshot = await getDataRef
          .child('user_details/${GlobalVariables.myUsername}')
          .get();

      if (getDataSnapshot.exists) {
        print("User exists: ${getDataSnapshot.value}");

        StaffAccountModel userAccountModel = staffAccountModelFromJson(
            jsonEncode(getDataSnapshot.value).toString());
        log.w("Retrieved account name: ${userAccountModel.fullName}");

        myAccountData = userAccountModel;
        update();
      }
      log.wtf("myAccountData: ${myAccountData.toJson()}");

      /// Map data
      InsightsFeedModel insightsData = InsightsFeedModel(
        username: GlobalVariables.myUsername,
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
    } else {
      showCustomSnackBar(context, "Ensure all fields are filled", () {},
          AppColors.coolRed, 1000);
    }
  }

  void gotoHomepage(BuildContext context) {
    resetValues();
    Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);
    update();
    context.pop();
  }
}
