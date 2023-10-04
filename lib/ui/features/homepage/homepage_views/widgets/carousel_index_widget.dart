// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';

class CarouselSliderWidget extends StatelessWidget {
  bool indexOn;
  CarouselSliderWidget({super.key, required this.indexOn});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: indexOn ? 5 : 3,
      backgroundColor: indexOn ? AppColors.regularBlue : AppColors.black,
    );
  }
}
