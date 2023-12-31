import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/staff_schedule_pageview.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/ui/shared/gray_curved_container.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/full_screen_image.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';

var log = getLogger('UserScheduleCard');

class UserScheduleCard extends StatelessWidget {
  UserScheduleCard({super.key, required this.staffData});
  
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

  gotoEditSchedulePage(BuildContext context, StaffAccountModel staffData) {
    log.w("Going to EditStaffSchedulePageView");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStaffSchedulePageView(
          staffData: staffData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: _controller,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: InkWell(
            onTap: () {
              GlobalVariables.accountType.contains("admin") == true
                  ? gotoEditSchedulePage(context, staffData)
                  : log.w("Staff cannot access this function");
            },
            child: Card(
              color: AppColors.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),
              elevation: 6,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Column(
                  children: [
                    CustomSpacer(15),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.plainWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: myDutyOrLeave(
                        shiftStart: staffData.currentShift?.start,
                        shiftEnd: staffData.currentShift?.end,
                        leaveStart: staffData.offPeriod?.start,
                        leaveEnd: staffData.offPeriod?.end,
                      ),
                    ),
                    CustomSpacer(12),
                    ListTile(
                      onTap: () => gotoEditSchedulePage(context, staffData),
                      trailing: InkWell(
                        onTap: () => showFullScreenImage(
                          context,
                          staffData.image ??
                              dummyAvatarUrl(
                                staffData.image ?? 'male',
                              ),
                        ),
                        child: Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.blue.shade400),
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
                        style: AppStyles.regularStringStyle(
                            16, AppColors.plainWhite),
                      ),
                      subtitle: Text(
                        staffData.department ?? '',
                        style: AppStyles.floatingHintStringStyleColored(
                            14, Colors.blue.shade200),
                      ),
                    ),

                    CustomSpacer(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomCurvedContainer(
                        topPadding: 0,
                        bottomPadding: 0,
                        height: 2,
                        fillColor: AppColors.plainWhite,
                      ),
                    ),

                    /// Check if schedules exist,
                    /// If exists, check if the shift and off end dates are not before today
                    (staffData.offPeriod?.start == null &&
                                staffData.currentShift?.start == null) ||
                            (staffData.offPeriod?.end
                                        ?.isBefore(DateTime.now()) ==
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
                                          text: (DateTime.now()
                                                          .isAtSameMomentAs(
                                                              staffData
                                                                  .currentShift!
                                                                  .start!) ==
                                                      true ||
                                                  DateTime.now().isAfter(
                                                          staffData
                                                              .currentShift!
                                                              .start!) ==
                                                      true)
                                              ? "Current Shift: "
                                              : "Next Shift: ",
                                          style: AppStyles.subStringStyle(
                                            14,
                                            AppColors.plainWhite,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: DateTime.now().isAfter(
                                                          staffData
                                                              .currentShift!
                                                              .end!) ==
                                                      true
                                                  ? "Unspecified"
                                                  : staffData.currentShift
                                                              ?.start ==
                                                          null
                                                      ? "Unspecified"
                                                      : staffData
                                                          .currentShift!.shift,
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
                                          text: (DateTime.now()
                                                          .isAtSameMomentAs(
                                                              staffData
                                                                  .currentShift!
                                                                  .start!) ==
                                                      true ||
                                                  DateTime.now().isAfter(
                                                          staffData
                                                              .currentShift!
                                                              .start!) ==
                                                      true)
                                              ? "Shift Period: "
                                              : "Next Shift Period: ",
                                          style: AppStyles.subStringStyle(
                                            14,
                                            AppColors.plainWhite,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: DateTime.now().isAfter(
                                                          staffData
                                                              .currentShift!
                                                              .end!) ==
                                                      true
                                                  ? "Unspecified"
                                                  : staffData.currentShift
                                                              ?.start ==
                                                          null
                                                      ? "Unspecified"
                                                      : formatPeriod(
                                                          startDate: staffData
                                                              .currentShift!
                                                              .start!,
                                                          endDate: staffData
                                                              .currentShift!
                                                              .end!,
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
                                                    staffData
                                                        .offPeriod!.start!) ==
                                                true ||
                                            DateTime.now().isAfter(staffData
                                                    .offPeriod!.start!) ==
                                                true)
                                        ? DateTime.now().isAfter(staffData
                                                    .offPeriod!.end!) ==
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
                                                endDate:
                                                    staffData.offPeriod!.end!,
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

                    CustomButton(
                      onPressed: () {
                        log.wtf("Requesting Leave");
                        showRequestLeaveDialog(context);
                      },
                      styleBoolValue: true,
                      height: 35,
                      width: 160,
                      color: AppColors.regularBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Request Leave",
                            style: AppStyles.regularStringStyle(
                              15,
                              Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.share_arrival_time_outlined,
                            color: AppColors.plainWhite,
                          ),
                        ],
                      ),
                    ),
                    CustomSpacer(20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showRequestLeaveDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.transparent,
          child: GetBuilder<HomepageController>(
              init: _controller,
              builder: (_) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.plainWhite,
                  ),
                  height: 280,
                  width: screenSize(context).width * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Request Leave",
                        style: AppStyles.regularStringStyle(
                          18,
                          AppColors.fullBlack,
                        ),
                      ),
                      CustomSpacer(12),
                      Text(
                        "Select the period for which you want to request the leave.",
                        textAlign: TextAlign.center,
                        style: AppStyles.normalStringStyle(
                          14,
                          color: AppColors.darkGray,
                        ),
                      ),
                      CustomSpacer(20),

                      // For Leave Date Period Selection
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (() async {
                                _controller.selectRequestLeavePeriod(context);

                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              }),
                              child: CustomCurvedContainer(
                                borderColor:
                                    _controller.leaveDatesValid == false
                                        ? AppColors.coolRed
                                        : AppColors.transparent,
                                width: screenSize(context).width * 0.8,
                                height: _controller.leaveStartingDay == null
                                    ? 61
                                    : 65,
                                leftPadding: 13,
                                child: _controller.leaveStartingDay == null
                                    ? Row(
                                        children: [
                                          Text(
                                            "Select Leave Period",
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                AppStyles.hintStringStyle(13),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenSize(context).width *
                                                0.8 *
                                                0.42,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'From:',
                                                  style:
                                                      AppStyles.hintStringStyle(
                                                          13),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMEd()
                                                          .format(_controller
                                                              .leaveStartingDay!),
                                                      style: AppStyles
                                                              .inputStringStyle(
                                                                  AppColors
                                                                      .fullBlack)
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                    CustomSpacer(8),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'To:',
                                                style:
                                                    AppStyles.hintStringStyle(
                                                        13),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat.yMMMEd().format(
                                                        _controller
                                                            .leaveEndingDay!),
                                                    style: AppStyles
                                                            .inputStringStyle(
                                                                AppColors
                                                                    .fullBlack)
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                  CustomSpacer(8),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            CustomSpacer(3),
                            Center(
                              child: Text(
                                _controller.leaveDatesValid == false
                                    ? "Ending date must be after the starting date"
                                    : "",
                                style: AppStyles.floatingHintStringStyleColored(
                                    14, AppColors.coolRed),
                              ),
                            ),
                          ],
                        ),
                      ),

                      CustomSpacer(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            height: 40,
                            styleBoolValue: true,
                            color: AppColors.lightGray,
                            width: screenSize(context).width * 0.3,
                            child: Text(
                              "Cancel",
                              style: AppStyles.regularStringStyle(
                                15,
                                AppColors.coolRed,
                              ),
                            ),
                            onPressed: () {
                              context.pop();
                              _controller.resetValues();
                            },
                          ),
                          _controller.leaveStartingDay == null
                              ? SizedBox.shrink()
                              : SizedBox(width: 12),
                          _controller.leaveStartingDay == null
                              ? SizedBox.shrink()
                              : CustomButton(
                                  height: 40,
                                  styleBoolValue: true,
                                  color: AppColors.lightGray,
                                  width: screenSize(context).width * 0.3,
                                  child: Text(
                                    "Request",
                                    style: AppStyles.regularStringStyle(
                                      15,
                                      Colors.green.shade700,
                                    ),
                                  ),
                                  onPressed: () {
                                    _controller.sendRequestToAdmin(context);
                                  },
                                ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}

String dummyAvatarUrl(String gender) => gender.toLowerCase() == 'male'
    ? 'https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'
    : 'https://cityofwilliamsport.org/wp-content/uploads/2021/03/femalePlaceholder.jpg';

Text myDutyOrLeave({
  required DateTime? shiftStart,
  required DateTime? shiftEnd,
  required DateTime? leaveStart,
  required DateTime? leaveEnd,
}) {
  if (shiftStart != null &&
      !DateTime.now().isBefore(shiftStart) &&
      !DateTime.now().isAfter(shiftEnd!)) {
    return Text(
      "You're on Duty",
      style: AppStyles.regularStringStyle(16, Colors.green.shade800),
    );
  } else if (leaveStart != null &&
      !DateTime.now().isBefore(leaveStart) &&
      !DateTime.now().isAfter(leaveEnd!)) {
    return Text(
      "You're On Leave",
      style: AppStyles.regularStringStyle(16, Colors.amber.shade900),
    );
  } else {
    return Text(
      "Your duty is unspecified",
      style: AppStyles.regularStringStyle(
        16,
        Colors.grey,
      ),
    );
  }
}
