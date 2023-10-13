import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/features/profile/profile_controller/staff_controller.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/custom_textfield_.dart';
import 'package:hospital_staff_management/ui/shared/gray_curved_container.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_key_strings.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:provider/provider.dart';

var log = getLogger('AddStaffPageView');

class AddStaffPageView extends StatefulWidget {
  const AddStaffPageView({super.key});

  @override
  State<AddStaffPageView> createState() => _AddStaffPageViewState();
}

class _AddStaffPageViewState extends State<AddStaffPageView> {
  CreateStaffAccountController _controller =
      Get.put(CreateStaffAccountController());

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CreateStaffAccountController());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
    _controller.resetValues();
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
            child: const CustomAppbar(
              title: "Add New Staff",
            ),
          ),
          body: GestureDetector(
            onTap: (() =>
                SystemChannels.textInput.invokeMethod('TextInput.hide')),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize(context).width / 14, vertical: 20),
              child: GetBuilder<CreateStaffAccountController>(
                init: CreateStaffAccountController(),
                builder: (_) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _controller.selectedImage == null
                            ? Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Colors.grey[100],
                                ),
                                child:
                                    const Center(child: Text("No images yet")),
                              )
                            : Container(
                                width: 250,
                                height: 250,
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  border: Border.all(
                                      color: AppColors.kPrimaryColor),
                                  color: Colors.grey[100],
                                  image: DecorationImage(
                                    image: FileImage(
                                      _controller.selectedImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _controller.selectProfilePicture();
                            },
                            child: Text(
                              _controller.selectedImage == null
                                  ? "Select From Gallery"
                                  : "Choose Another Image",
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         AppKeyStrings.toponym,
                        //         style: AppStyles.regularStringStyle(
                        //             18, AppColors.fullBlack),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        CustomTextfield(
                          textEditingController: _controller.fullNameController,
                          labelText: "Full name",
                          hintText: 'Staff full name',
                          textInputAction: TextInputAction.next,
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController: _controller.usernameController,
                          labelText: "Username",
                          hintText: 'Give staff a username',
                          textInputAction: TextInputAction.next,
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController: _controller.passwordController,
                          labelText: "Password",
                          hintText: 'Give staff a password',
                          textInputAction: TextInputAction.next,
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController: _controller.phoneController,
                          labelText: "Phone Number",
                          hintText: 'Staff\'s phone number',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController: _controller.emailController,
                          labelText: "Email",
                          hintText: 'Staff\'s email address',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController:
                              _controller.departmentController,
                          labelText: "Department",
                          hintText: 'Staff\'s department',
                          textInputAction: TextInputAction.done,
                        ),
                        CustomSpacer(20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Year of Birth",
                              style: AppStyles.inputStringStyle(
                                AppColors.fullBlack,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                DateTime? selectedDate;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Select Year"),
                                      content: SizedBox(
                                        width: 300,
                                        height: 400,
                                        child: YearPicker(
                                          firstDate: DateTime(
                                              DateTime.now().year - 70, 1),
                                          lastDate: DateTime(
                                              DateTime.now().year - 10, 1),
                                          initialDate: DateTime.now(),
                                          selectedDate:
                                              selectedDate ?? DateTime.now(),
                                          onChanged: (DateTime dateTime) {
                                            setState(() {
                                              selectedDate = dateTime;
                                            });
                                            _controller.setBirthYear(
                                              dateTime.year.toString(),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: CustomCurvedContainer(
                                fillColor: AppColors.plainWhite,
                                borderColor: AppColors.kPrimaryColor,
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    _controller.birthYear ?? "Year",
                                    style: _controller.birthYear == null
                                        ? AppStyles.hintStringStyle(14)
                                        : AppStyles.inputStringStyle(
                                            AppColors.fullBlack,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomSpacer(20),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                AppKeyStrings.gender,
                                style: AppStyles.regularStringStyle(
                                    18, AppColors.fullBlack),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            log.w(_controller.selectedGender);
                            _controller.selectedGender = GenderType.male;
                            log.wtf(_controller.selectedGender);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          title: Text(
                              GenderType.male.name.toString().toSentenceCase),
                          leading: Radio(
                            value: GenderType.male,
                            groupValue: _controller.selectedGender,
                            onChanged: (natural) {
                              setState(() {
                                log.w(_controller.selectedGender);
                                _controller.selectedGender = GenderType.male;
                                log.wtf(_controller.selectedGender);
                              });
                            },
                          ),
                        ),

                        ListTile(
                          onTap: () {
                            log.w(_controller.selectedGender);
                            _controller.selectedGender = GenderType.female;
                            log.wtf(_controller.selectedGender);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          title: Text(
                              GenderType.female.name.toString().toSentenceCase),
                          leading: Radio(
                            value: GenderType.female,
                            groupValue: _controller.selectedGender,
                            onChanged: (natural) {
                              setState(() {
                                log.w(_controller.selectedGender);
                                _controller.selectedGender = GenderType.female;
                                log.wtf(_controller.selectedGender);
                              });
                            },
                          ),
                        ),

                        ListTile(
                          onTap: () {
                            log.w(_controller.selectedGender);
                            _controller.selectedGender = GenderType.others;
                            log.wtf(_controller.selectedGender);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          title: Text(
                              GenderType.others.name.toString().toSentenceCase),
                          leading: Radio(
                            value: GenderType.others,
                            groupValue: _controller.selectedGender,
                            onChanged: (natural) {
                              setState(() {
                                log.w(_controller.selectedGender);
                                _controller.selectedGender = GenderType.others;
                                log.wtf(_controller.selectedGender);
                              });
                            },
                          ),
                        ),
                        //
                        CustomSpacer(35),
                        _controller.showLoading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppColors.kPrimaryColor,
                                ),
                              )
                            : CustomButton(
                                styleBoolValue: true,
                                width: screenSize(context).width * 0.5,
                                color: AppColors.kPrimaryColor,
                                child: Text(
                                  'Upload',
                                  style: AppStyles.regularStringStyle(
                                      20, AppColors.plainWhite),
                                ),
                                onPressed: () {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  _controller.uploadNewStaffData(context);
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
      ),
    );
  }
}
