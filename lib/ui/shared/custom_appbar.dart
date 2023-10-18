import 'package:flutter/material.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

class CustomAppbar extends StatelessWidget {
  final String? title;
  final Color? appbarColor, titleColor;
  const CustomAppbar(
      {super.key, this.title, this.appbarColor, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: screenSize(context).width,
      height: 120,
      decoration: BoxDecoration(
        color: appbarColor ?? AppColors.kPrimaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            title ?? "HSMS",
            style: AppStyles.regularStringStyle(
                18, titleColor ?? AppColors.plainWhite),
          ),
        ),
      ),
    );
  }
}
