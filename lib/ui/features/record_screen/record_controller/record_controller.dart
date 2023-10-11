// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:math';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:hospital_staff_management/app/helpers/sharedprefs.dart';
// import 'package:hospital_staff_management/app/resources/app.logger.dart';
// import 'package:hospital_staff_management/app/services/snackbar_service.dart';
// import 'package:hospital_staff_management/ui/features/create_account/create_account_model/account_models.dart';
// import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
// import 'package:hospital_staff_management/ui/features/record_screen/record_model/record_model.dart';
// import 'package:hospital_staff_management/ui/shared/global_variables.dart';
// import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
// import 'package:provider/provider.dart';

// var log = getLogger('RecordPageView');

// // ignore: constant_identifier_names
// enum ToponymTypes { Natural, Artificial }

// class RecordToponymController extends GetxController {
//   RecordToponymController();

//   bool showLoading = false;

//   TextEditingController toponymNameController = TextEditingController();
//   TextEditingController toponymDescriptionController = TextEditingController();

//   var selectedToponymTypes = ToponymTypes.Natural;

//   List<XFile> imageFilesSelected = [];
//   int selectedImageIndex = 0;
//   String? recordToponymId;

//   resetValues() {
//     showLoading = false;

//     toponymNameController = TextEditingController();
//     toponymDescriptionController = TextEditingController();

//     selectedToponymTypes = ToponymTypes.Natural;
//     imageFilesSelected = [];
//     update();
//   }

//   String generateRandomrecordToponymId() {
//     Random random = Random();
//     int randomNumber1 = random.nextInt(10000);
//     int randomNumber2 = random.nextInt(99999);
//     recordToponymId = GlobalVariables.myUsername.toString() +
//         randomNumber1.toString() +
//         randomNumber2.toString();
//     update();
//     print("GeneratedRandomRecordToponymId: $recordToponymId");
//     return recordToponymId!;
//   }

//   String formatCurrentTime() {
//     DateTime now = DateTime.now();
//     String lastTime =
//         "${DateFormat.yMMMEd().format(now)} ${DateFormat.jm().format(DateTime.now())}";
//     print(lastTime);
//     return lastTime;
//   }

//   void changeSelectedImageIndex(int selectedPickIndex) {
//     selectedImageIndex = selectedPickIndex;
//     update();
//   }

//   /// Upload image from gallery
//   uploadfromGallery() async {
//     List<XFile> selectedImages = await ImagePicker().pickMultiImage(
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (selectedImages.isNotEmpty) {
//       if (selectedImages.length > 4) {
//         selectedImages = [
//           selectedImages[0],
//           selectedImages[1],
//           selectedImages[2],
//           selectedImages[3],
//         ];
//       }

//       imageFilesSelected.addAll(selectedImages);
//       update();
//       print("Image List Length:${imageFilesSelected.length}");
//     } else {
//       print("No Image selected");
//     }
//     print("Returning");
//   }

//   /// Snap image with Camera
//   captureFromCamera() async {
//     XFile? capturedImage = await ImagePicker().pickImage(
//       source: ImageSource.camera,
//       maxWidth: 1800,
//       maxHeight: 1800,
//     );
//     if (capturedImage != null) {
//       imageFilesSelected.add(capturedImage);
//       update();
//     } else {
//       print("No Image selected");
//     }
//     print("Returning");
//   }

//   Future<void> uploadRecordToponymData(BuildContext context) async {
//     int recordToponymPoints = 50;
//     if (toponymNameController.text.trim().isNotEmpty &&
//         toponymDescriptionController.text.trim().isNotEmpty &&
//         imageFilesSelected.isNotEmpty) {
//       showLoading = true;
//       update();
//       recordToponymId = generateRandomrecordToponymId();

//       /// Upload image to cloud storage
//       final firebaseStorage = FirebaseStorage.instance;
//       List<String> downloadUrls = [];

//       for (int index = 0; index < 4; index++) {
//         var snapshot = await firebaseStorage
//             .ref()
//             .child(
//                 'hospital_staff_management/toponyms_images/$recordToponymId/${index + 1}')
//             .putFile(File(imageFilesSelected[index].path))
//             .whenComplete(() => log.w("Uploaded image ${index + 1}"));

//         /// Generate download links
//         var downloadUrl = await snapshot.ref.getDownloadURL();
//         downloadUrls.add(downloadUrl);
//       }
//       log.w("downloadUrls: $downloadUrls");
//       update();

//       String dateString = formatCurrentTime();
//       log.wtf("dateString: $dateString");

//       /// get saved profileImageLink
//       String myProfileImageLink =
//           await getSharedPrefsSavedString("profileImageLink");

//       /// Map data
//       RecordToponymModel toponymData = RecordToponymModel(
//         username: GlobalVariables.myUsername,
//         thumbsUp: 0,
//         feedCoverPictureLink: downloadUrls,
//         feedName: toponymNameController.text.trim(),
//         feedDescription: toponymDescriptionController.text.trim(),
//         userProfilePicsLink: myProfileImageLink,
//         dateCreated: dateString,
//         toponymType: selectedToponymTypes.name,
//       );

//       print('toponymData to be uploaded: ${toponymData.toJson()}');

//       /// Upload data to firestore
//       DatabaseReference ref =
//           FirebaseDatabase.instance.ref("toponym_data/$recordToponymId");

//       print(toponymData.toJson());

//       await ref.set(toponymData.toJson()).whenComplete(() async {
//         /// Get my details from RT Db
//         final getDataRef = FirebaseDatabase.instance.ref();
//         final getDataSnapshot = await getDataRef
//             .child('user_details/${GlobalVariables.myUsername}')
//             .get();

//         UserAccountModel updateAccountData = UserAccountModel();

//         if (getDataSnapshot.exists) {
//           print("User exists: ${getDataSnapshot.value}");

//           UserAccountModel userAccountModel = userAccountModelFromJson(
//               jsonEncode(getDataSnapshot.value).toString());
//           log.w("Retrieved total points is ${userAccountModel.totalPoints}");

//           userAccountModel.totalPoints = userAccountModel.totalPoints ?? 0;
//           userAccountModel.totalToponymsRecorded =
//               userAccountModel.totalToponymsRecorded ?? 0;
//           userAccountModel.naturalToponymsRecorded =
//               userAccountModel.naturalToponymsRecorded ?? 0;
//           userAccountModel.artificialToponymsRecorded =
//               userAccountModel.artificialToponymsRecorded ?? 0;

//           userAccountModel
//             ..totalPoints = userAccountModel.totalPoints! + recordToponymPoints
//             ..totalToponymsRecorded =
//                 userAccountModel.totalToponymsRecorded! + 1
//             ..naturalToponymsRecorded =
//                 selectedToponymTypes == ToponymTypes.Natural
//                     ? userAccountModel.naturalToponymsRecorded! + 1
//                     : userAccountModel.naturalToponymsRecorded
//             ..artificialToponymsRecorded =
//                 selectedToponymTypes == ToponymTypes.Artificial
//                     ? userAccountModel.artificialToponymsRecorded! + 1
//                     : userAccountModel.artificialToponymsRecorded;
//           log.w("userAccountModel: ${userAccountModel.toJson()}");

//           updateAccountData = userAccountModel;
//           update();
//         }
//         log.wtf("updateAccountData: ${updateAccountData.toJson()}");

//         /// Update Data back to the Db
//         DatabaseReference ref = FirebaseDatabase.instance
//             .ref("user_details/${GlobalVariables.myUsername}");

//         print(updateAccountData.toJson());

//         await ref
//             .update(updateAccountData.toJson())
//             .whenComplete(
//               () => showCustomSnackBar(context, "Successful! Toponym recorded.",
//                   () {}, Colors.green, 1000),
//             )
//             .whenComplete(() => gotoHomepage(context));
//       });
//     } else {
//       showCustomSnackBar(context, "Ensure all fields are filled", () {},
//           AppColors.coolRed, 1000);
//     }
//   }

//   void gotoHomepage(BuildContext context) {
//     resetValues();
//     Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);
//     update();
//     context.pop();
//   }
// }
