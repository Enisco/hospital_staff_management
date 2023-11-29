import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/full_screen_image.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';

var log = getLogger('CoStaffCard');

class CoStaffCard extends StatelessWidget {
  CoStaffCard({super.key, required this.staffData});

  final HomepageController _controller = HomepageController.to;

  final StaffAccountModel staffData;

  String formatPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    String formattedDateString =
        "${DateFormat.yMMMEd().format(startDate)} - ${DateFormat.yMMMEd().format(endDate)}";
    return formattedDateString;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: _controller,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.plainWhite,
          ),
          child: Column(
            children: [
              ListTile(
                leading: InkWell(
                  onTap: () => showFullScreenImage(
                    context,
                    staffData.image ??
                        dummyAvatarUrl(
                          staffData.image ?? 'male',
                        ),
                  ),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blue.shade400),
                      shape: BoxShape.circle,
                      color: AppColors.blueGray,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            staffData.image ??
                                dummyAvatarUrl(staffData.image ?? 'male'),
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                title: Text(
                  staffData.fullName ?? '',
                  style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
                ),
                subtitle: Text(
                  staffData.department ?? '',
                  style: AppStyles.hintStringStyle(13),
                ),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkGray),
                  ),
                  child: onDutyOrLeave(
                    shiftStart: staffData.currentShift?.start,
                    shiftEnd: staffData.currentShift?.end,
                    leaveStart: staffData.offPeriod?.start,
                    leaveEnd: staffData.offPeriod?.end,
                  ),
                ),
              ),

              /// Check if schedules exist,
              /// If exists, check if the shift and off end dates are not before today
              (staffData.offPeriod?.start == null &&
                          staffData.currentShift?.start == null) ||
                      (staffData.offPeriod?.end?.isBefore(DateTime.now()) ==
                              true &&
                          staffData.currentShift?.end
                                  ?.isBefore(DateTime.now()) ==
                              true)
                  ? const SizedBox.shrink()
                  : Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 15),
                      width: screenSize(context).width,
                      color: AppColors.kPrimaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Check if Duty time is in the future

                          staffData.currentShift?.start == null
                              ? const SizedBox.shrink()
                              : RichText(
                                  text: TextSpan(
                                    text: (DateTime.now().isAtSameMomentAs(
                                                    staffData.currentShift!
                                                        .start!) ==
                                                true ||
                                            DateTime.now().isAfter(staffData
                                                    .currentShift!.start!) ==
                                                true)
                                        ? "Current Shift: "
                                        : "Next Shift: ",
                                    style: AppStyles.subStringStyle(
                                      14,
                                      AppColors.plainWhite,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: DateTime.now().isAfter(staffData
                                                    .currentShift!.end!) ==
                                                true
                                            ? "Unspecified"
                                            : staffData.currentShift?.start ==
                                                    null
                                                ? "Unspecified"
                                                : staffData.currentShift!.shift,
                                        style: AppStyles.keyStringStyle(
                                          14,
                                          AppColors.plainWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                          staffData.currentShift?.start == null
                              ? const SizedBox.shrink()
                              : RichText(
                                  text: TextSpan(
                                    text: (DateTime.now().isAtSameMomentAs(
                                                    staffData.currentShift!
                                                        .start!) ==
                                                true ||
                                            DateTime.now().isAfter(staffData
                                                    .currentShift!.start!) ==
                                                true)
                                        ? "Shift Period: "
                                        : "Next Shift Period: ",
                                    style: AppStyles.subStringStyle(
                                      14,
                                      AppColors.plainWhite,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: DateTime.now().isAfter(staffData
                                                    .currentShift!.end!) ==
                                                true
                                            ? "Unspecified"
                                            : staffData.currentShift?.start ==
                                                    null
                                                ? "Unspecified"
                                                : formatPeriod(
                                                    startDate: staffData
                                                        .currentShift!.start!,
                                                    endDate: staffData
                                                        .currentShift!.end!,
                                                  ),
                                        style: AppStyles.keyStringStyle(
                                          14,
                                          AppColors.plainWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                          RichText(
                            text: TextSpan(
                              text: (DateTime.now().isAtSameMomentAs(
                                              staffData.offPeriod!.start!) ==
                                          true ||
                                      DateTime.now().isAfter(
                                              staffData.offPeriod!.start!) ==
                                          true)
                                  ? DateTime.now().isAfter(
                                              staffData.offPeriod!.end!) ==
                                          true
                                      ? "Last Off Period: "
                                      : "Off Duty Period: "
                                  : "Next Off Period: ",
                              style: AppStyles.subStringStyle(
                                14,
                                AppColors.plainWhite,
                              ),
                              children: [
                                TextSpan(
                                  text: staffData.offPeriod?.start == null
                                      ? "Unspecifed"
                                      : formatPeriod(
                                          startDate:
                                              staffData.offPeriod!.start!,
                                          endDate: staffData.offPeriod!.end!,
                                        ),
                                  style: AppStyles.keyStringStyle(
                                    14,
                                    AppColors.plainWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
