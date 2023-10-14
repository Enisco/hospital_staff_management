import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/full_screen_image.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

var log = getLogger('EditStaffSchedulePageView');

class EditStaffSchedulePageView extends StatefulWidget {
  final StaffAccountModel staffData;
  const EditStaffSchedulePageView({super.key, required this.staffData});

  @override
  State<EditStaffSchedulePageView> createState() =>
      _EditStaffSchedulePageViewState();
}

class _EditStaffSchedulePageViewState extends State<EditStaffSchedulePageView> {
  final _controller = Get.put(HomepageController());

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime? shiftStartingDate, offStartingDay, shiftEndingDate, offEndingDay;
  bool? allDatesValid;

  Future<List<DateTime>?> selectDateRange(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    List<DateTime>? selectedDateTime = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      type: OmniDateTimePickerType.date,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );

    log.wtf('Time selected: $selectedDateTime');

    if (selectedDateTime != null) {
      var startDayAndTime = selectedDateTime[0];
      var endDayAndTime = selectedDateTime[1];

      if (startDayAndTime
              .add(const Duration(minutes: 1))
              .isBefore(endDayAndTime) &&
          endDayAndTime.isAfter(DateTime.now())) {
        log.wtf("startDayAndTime is before endDayAndTime");
        allDatesValid = true;
      } else {
        log.w("Invalid date selected");
        allDatesValid = false;
      }
      return selectedDateTime;
    }
    return null;
  }

  selectNextShiftPeriod() async {
    List<DateTime>? shiftDateRange = await selectDateRange(context);
    if (allDatesValid == true) {
      shiftStartingDate = shiftDateRange![0];
      shiftEndingDate = shiftDateRange[1];
      log.wtf(
          "shiftDate - start: $shiftStartingDate \t end: $shiftEndingDate ");
    } else {
      log.w("Invalid shift date selected");
    }
  }

  selectNextOffPeriod() async {
    List<DateTime>? offDateRange = await selectDateRange(context);
    if (allDatesValid == true) {
      offStartingDay = offDateRange![0];
      offEndingDay = offDateRange[1];
      log.wtf("offDate - start: $offStartingDay \t end: $offEndingDay ");
    } else {
      log.w("Invalid off date selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
      builder: (_) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(screenSize(context).width, 60),
            child: CustomAppbar(
              title: widget.staffData.fullName ?? '',
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 230,
                  padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.phone_in_talk_outlined,
                                    color: AppColors.bronze),
                                const SizedBox(width: 6),
                                Text(
                                  widget.staffData.phone ?? '',
                                  style: AppStyles.regularStringStyle(
                                      14, AppColors.bronze),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.mail,
                                  color: AppColors.regularBlue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.staffData.email ?? '',
                                  style: AppStyles.regularStringStyle(
                                      14, AppColors.regularBlue),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.health_and_safety_outlined,
                                  color: AppColors.plainWhite,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.staffData.department ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.regularStringStyle(
                                      14, AppColors.plainWhite),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => showFullScreenImage(
                          context,
                          widget.staffData.image ??
                              dummyAvatarUrl(
                                widget.staffData.image ?? 'male',
                              ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.blueGray,
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.staffData.image ??
                                dummyAvatarUrl(
                                  widget.staffData.gender ?? 'male',
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomSpacer(40),
                TextButton(
                  onPressed: () async {
                    selectNextShiftPeriod();
                  },
                  child: const Text(
                    "Select Next Shift Period",
                  ),
                ),
                CustomSpacer(20),
                TextButton(
                  onPressed: () async {
                    selectNextShiftPeriod();
                  },
                  child: const Text(
                    "Select Next Off Period",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
