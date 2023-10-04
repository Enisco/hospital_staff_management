import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/features/record_screen/record_controller/record_controller.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/custom_textfield.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_key_strings.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:provider/provider.dart';

var log = getLogger('RecordPageView');

class RecordPageView extends StatefulWidget {
  const RecordPageView({super.key});

  @override
  State<RecordPageView> createState() => _RecordPageViewState();
}

class _RecordPageViewState extends State<RecordPageView> {
  final _controller = Get.put(RecordToponymController());

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
      child: ConditionalWillPopScope(
        onWillPop: () async {
          Provider.of<CurrentPage>(context, listen: false)
              .setCurrentPageIndex(0);
          context.pop();
          return false;
        },
        shouldAddCallback: true,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(screenSize(context).width, 60),
              child: CustomAppbar(
                title: AppKeyStrings.recordToponym,
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
                child: GetBuilder<RecordToponymController>(
                    init: RecordToponymController(),
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
                                    child: const Center(
                                        child: Text("No images yet")),
                                  )
                                : Container(
                                    width: 300,
                                    height: 350,
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      border: Border.all(
                                          color: AppColors.kPrimaryColor),
                                      color: Colors.grey[100],
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(_controller
                                              .imageFilesSelected[_controller
                                                  .selectedImageIndex]
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(7)),
                                      border: Border.all(
                                        color: AppColors.kPrimaryColor,
                                      ),
                                      color: AppColors.lighterGray,
                                    ),
                                    height: 90,
                                    width: 300,
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.all(4.0),
                                    child: GridView.builder(
                                        itemCount: _controller
                                            .imageFilesSelected.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () => _controller
                                                .changeSelectedImageIndex(
                                                    index),
                                            child: Container(
                                              width: 90,
                                              // height: 500,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
                                                color: Colors.grey[100],
                                              ),
                                              child: Image.file(
                                                File(_controller
                                                    .imageFilesSelected[index]
                                                    .path),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                            SizedBox(
                              height: _controller.imageFilesSelected.isEmpty
                                  ? 30
                                  : 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.uploadfromGallery();
                                },
                                child: Text(
                                  _controller.imageFilesSelected.isEmpty
                                      ? "SELECT FROM GALLERY"
                                      : "CHOOSE ANOTHER IMAGE",
                                ),
                              ),
                            ),
                            SizedBox(
                                height: _controller.imageFilesSelected.isEmpty
                                    ? 20
                                    : 5),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.captureFromCamera();
                                },
                                child: Text(
                                  _controller.imageFilesSelected.isEmpty
                                      ? "CAPTURE WITH CAMERA"
                                      : "CAPTURE ANOTHER IMAGE",
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    AppKeyStrings.toponym,
                                    style: AppStyles.regularStringStyle(
                                        18, AppColors.fullBlack),
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                              topPadding: 14,
                              fillColor: AppColors.regularBlue,
                              textEditingController:
                                  _controller.toponymNameController,
                              labelText: 'What is the name?',
                              textInputAction: TextInputAction.next,
                            ),
                            CustomSpacer(15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    AppKeyStrings.toponymDesc,
                                    style: AppStyles.regularStringStyle(
                                        18, AppColors.fullBlack),
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                              height: 120,
                              textEditingController:
                                  _controller.toponymDescriptionController,
                              labelText: 'Give details of the toponym . . .',
                              textInputAction: TextInputAction.next,
                            ),
                            CustomSpacer(15),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    AppKeyStrings.toponymType,
                                    style: AppStyles.regularStringStyle(
                                        18, AppColors.fullBlack),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                log.w(_controller.selectedToponymTypes);
                                _controller.selectedToponymTypes =
                                    ToponymTypes.Natural;
                                log.wtf(_controller.selectedToponymTypes);
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              title: Text(ToponymTypes.Natural.name.toString()),
                              leading: Radio(
                                value: ToponymTypes.Natural,
                                groupValue: _controller.selectedToponymTypes,
                                onChanged: (natural) {
                                  setState(() {
                                    log.w(_controller.selectedToponymTypes);
                                    _controller.selectedToponymTypes =
                                        ToponymTypes.Natural;
                                    log.wtf(_controller.selectedToponymTypes);
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              onTap: () => setState(() {
                                log.w(_controller.selectedToponymTypes);
                                _controller.selectedToponymTypes =
                                    ToponymTypes.Artificial;
                                log.wtf(_controller.selectedToponymTypes);
                              }),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              title:
                                  Text(ToponymTypes.Artificial.name.toString()),
                              leading: Radio(
                                value: ToponymTypes.Artificial,
                                groupValue: _controller.selectedToponymTypes,
                                onChanged: (artificial) {
                                  setState(() {
                                    log.w(_controller.selectedToponymTypes);
                                    _controller.selectedToponymTypes =
                                        ToponymTypes.Artificial;
                                    log.wtf(_controller.selectedToponymTypes);
                                  });
                                },
                              ),
                            ),
                            //
                            CustomSpacer(65),
                            CustomButton(
                              styleBoolValue: true,
                              width: screenSize(context).width * 0.5,
                              color: Colors.amber[600],
                              child: Text(
                                'Upload',
                                style: AppStyles.regularStringStyle(
                                    20, AppColors.plainWhite),
                              ),
                              onPressed: () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                _controller.uploadRecordToponymData(context);
                              },
                            ),
                            CustomSpacer(10),
                            GetBuilder<RecordToponymController>(
                              init: RecordToponymController(),
                              builder: (_) {
                                return Center(
                                  child: _controller.showLoading == true
                                      ? Platform.isAndroid
                                          ? const CircularProgressIndicator()
                                          : const CupertinoActivityIndicator()
                                      : const SizedBox.shrink(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )),
      ),
    );
  }
}
