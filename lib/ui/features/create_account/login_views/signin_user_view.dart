// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/ui/features/create_account/login_controller/login_controller.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/custom_textfield_.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => SystemChannels.textInput.invokeMethod('TextInput.hide')),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Container(
          height: size.height,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/doc_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: GetBuilder<LoginController>(
              init: LoginController(),
              builder: (_) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextfield(
                          textEditingController:
                              controller.usernameController,
                          labelText: 'Username',
                          hintText: 'Enter your preferred username',
                        ),
                        CustomSpacer(20),
                        CustomTextfield(
                          textEditingController:
                              controller.passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your preferred password',
                        ),
                        CustomSpacer(20),
                        Center(
                          child: Text(
                            controller.errMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        CustomSpacer(10),
                        Center(
                          child: controller.showLoading == true
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  styleBoolValue: true,
                                  height: 55,
                                  width: screenSize(context).width * 0.6,
                                  color: Colors.blue[800],
                                  child: Text(
                                    'Log in',
                                    style: AppStyles.regularStringStyle(
                                      18,
                                      AppColors.plainWhite,
                                    ),
                                  ),
                                  onPressed: () {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    controller.attemptToSignInUser(context);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
