import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/insights_screen/insights_controller/insights_controller.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/custom_textfield_.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

var log = getLogger('CreateInsightPageView');

class CreateInsightPageView extends StatefulWidget {
  const CreateInsightPageView({super.key});

  @override
  State<CreateInsightPageView> createState() => _CreateInsightPageViewState();
}

class _CreateInsightPageViewState extends State<CreateInsightPageView> {
  final _controller = Get.put(InsightsController());

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenSize(context).width, 60),
          child: const CustomAppbar(
            title: "Create Insight Post",
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          color: AppColors.plainWhite,
        ),
        body: GestureDetector(
          onTap: (() =>
              SystemChannels.textInput.invokeMethod('TextInput.hide')),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenSize(context).width / 14, vertical: 20),
            child: GetBuilder<InsightsController>(
              init: InsightsController(),
              builder: (_) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _controller.imageFilesSelected.isEmpty
                          ? Container(
                              width: screenSize(context).width,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                color: Colors.grey[100],
                              ),
                              child: const Center(child: Text("No images yet")),
                            )
                          : Container(
                              width: 300,
                              height: 350,
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                border:
                                    Border.all(color: AppColors.kPrimaryColor),
                                color: Colors.grey[100],
                                image: DecorationImage(
                                  image: FileImage(
                                    File(_controller
                                        .imageFilesSelected[
                                            _controller.selectedImageIndex]
                                        .path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      _controller.imageFilesSelected.isEmpty
                          ? const SizedBox.shrink()
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                                // border: Border.all(
                                //   color: AppColors.kPrimaryColor,
                                // ),
                                color: AppColors.blueGray,
                              ),
                              height: 90,
                              width: 300,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(4.0),
                              child: GridView.builder(
                                  itemCount:
                                      _controller.imageFilesSelected.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () => _controller
                                          .changeSelectedImageIndex(index),
                                      child: Container(
                                        width: 90,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Colors.grey[100],
                                        ),
                                        child: Image.file(
                                          File(_controller
                                              .imageFilesSelected[index].path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  }),
                            ),

                      CustomSpacer(15),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.uploadfromGallery();
                          },
                          child: Text(
                            _controller.imageFilesSelected.isEmpty
                                ? "Upload Images"
                                : "Choose another image",
                          ),
                        ),
                      ),

                      CustomSpacer(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "Title",
                              style: AppStyles.regularStringStyle(
                                  18, AppColors.fullBlack),
                            ),
                          ],
                        ),
                      ),
                      CustomSpacer(5),
                      CustomTextfield(
                        textEditingController:
                            _controller.insightsTitleController,
                        hintText: 'Title of your post',
                        textInputAction: TextInputAction.next,
                      ),
                      CustomSpacer(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "Details",
                              style: AppStyles.regularStringStyle(
                                  18, AppColors.fullBlack),
                            ),
                          ],
                        ),
                      ),
                      CustomSpacer(5),
                      SizedBox(
                        height: 120,
                        child: CustomTextfield(
                          minimumHeight: 120,
                          maxLines: 10,
                          textEditingController:
                              _controller.insightsDescriptionController,
                          hintText: 'Write details here',
                          textInputAction: TextInputAction.next,
                          textMaxLength: 1000,
                        ),
                      ),
                      //
                      CustomSpacer(40),
                      _controller.loading == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : CustomButton(
                              styleBoolValue: true,
                              width: screenSize(context).width * 0.5,
                              height: 55,
                              color: AppColors.kPrimaryColor,
                              child: Text(
                                'Create Post',
                                style: AppStyles.regularStringStyle(
                                  18,
                                  AppColors.plainWhite,
                                ),
                              ),
                              onPressed: () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                _controller.uploadCreatedInsightData(context);
                              },
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
