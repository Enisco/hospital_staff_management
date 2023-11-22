import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.locator.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/fcm_services/fcm_service.dart';
import 'package:hospital_staff_management/app/services/fcm_services/push_notification_service.dart';
import 'package:hospital_staff_management/app/services/snackbar_service.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/req_leave_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/update_user_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/staff_schedule_pageview.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

var log = getLogger('HomepageController');

enum ShiftsPeriod { morning, afternoon, night, off }

class HomepageController extends GetxController {
  static HomepageController get to => Get.find();

  bool doneLoading = false;
  List<StaffAccountModel> staffsData = [];
  StaffAccountModel? myData;
  DateTime? shiftStartingDate,
      offStartingDay,
      shiftEndingDate,
      offEndingDay,
      leaveStartingDay,
      leaveEndingDay;
  bool? allDatesValid,
      leaveDatesValid,
      shiftDatesValid,
      offDatesValid,
      datesDoNotOverlap;
  String? dateOverlapsError = '', leaveRequestError = '';

  List<RequestLeaveModel> notificationsData = [];
  int unseenNotificationsCount = 0;

  ShiftsPeriod? selectedShift;

  resetValues() {
    doneLoading = true;
    selectedShift = null;
    shiftStartingDate = null;
    shiftEndingDate = null;
    offStartingDay = null;
    offEndingDay = null;
    leaveStartingDay = null;
    leaveEndingDay = null;
    dateOverlapsError = '';
    shiftDatesValid = null;
    leaveDatesValid = null;
    offDatesValid = null;
    datesDoNotOverlap = null;
  }

  bool checkDatesNotOverlap() {
    bool check;
    if (shiftStartingDate != null &&
        shiftEndingDate != null &&
        offStartingDay != null &&
        offEndingDay != null) {
      if (isOffPeriodOutsideShift() == true) {
        dateOverlapsError = '';
        check = true;
      } else {
        dateOverlapsError = "The off period overlaps with the shift period.";
        check = false;
      }
    } else {
      dateOverlapsError = '';
      check = true;
    }
    log.w("dateOverlapsError: $dateOverlapsError");
    update();
    return check;
  }

  bool isOffPeriodOutsideShift() {
    datesDoNotOverlap = offStartingDay!.isAfter(shiftEndingDate!) ||
        offEndingDay!.isBefore(shiftStartingDate!) ||
        offStartingDay!.isAtSameMomentAs(shiftEndingDate!) ||
        offEndingDay!.isAtSameMomentAs(shiftStartingDate!);
    update();
    return datesDoNotOverlap!;
  }

  ShiftsPeriod mapExistingShift(String shiftName) {
    if (shiftName.toLowerCase() == ShiftsPeriod.morning.name) {
      return ShiftsPeriod.morning;
    } else if (shiftName.toLowerCase() == ShiftsPeriod.afternoon.name) {
      return ShiftsPeriod.afternoon;
    } else if (shiftName.toLowerCase() == ShiftsPeriod.night.name) {
      return ShiftsPeriod.night;
    } else {
      return ShiftsPeriod.off;
    }
  }

  syncStaffCurrentShiftSchedule(CurrentShift currentShift) {
    selectedShift = mapExistingShift(currentShift.shift!);
    shiftStartingDate = currentShift.start;
    shiftEndingDate = currentShift.end;
    log.wtf(
        "Updated Staff Current Shift Schedule: ${shiftStartingDate?.toIso8601String()}");
  }

  syncStaffOffPeriodSchedule(OffPeriod offPeriod) {
    offStartingDay = offPeriod.start;
    offEndingDay = offPeriod.end;
    if (shiftStartingDate == null) selectedShift = ShiftsPeriod.off;
    log.wtf("Updated Staff Off Schedule: ${offStartingDay?.toIso8601String()}");
  }

  // Update the data in the DB
  updateStaffSchedules(
    BuildContext context,
    StaffAccountModel updatedStaffData,
  ) async {
    doneLoading = false;
    update();
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('staffs/${updatedStaffData.username}');

      await ref.update(updatedStaffData.toJson()).then((value) async {
        // Send Notification to the Staff
        if (updatedStaffData.deviceToken != null) {
          log.w("Device token found");
          FcmService().sendPushNotification(
            receipientDeviceToken: updatedStaffData.deviceToken!,
            message: "You have a new notification from the Admin",
          );
        } else {
          log.w("No device token found");
        }
        log.w("Staff Schedule Updated");
        context.pop();
        resetValues();
        getAllStaffsData();
      });
    } catch (e) {
      dateOverlapsError = 'Error updating staff schedule';
    }
    doneLoading = true;
    update();
  }

  updateScreenValues() {
    // getAllStaffsData();
    update();
    log.w("Updated all values");
  }

  createStaffSchedule(
    BuildContext context,
    StaffAccountModel staffData,
  ) {
    if (shiftDatesValid != false && offDatesValid != false) {
      StaffAccountModel updatedStaffData = staffData.copyWith(
        currentShift: CurrentShift(
          shift: selectedShift == ShiftsPeriod.off
              ? shiftStartingDate != null
                  ? staffData.currentShift?.shift
                  : selectedShift?.name.toString().toSentenceCase
              : selectedShift?.name.toString().toSentenceCase,
          start: shiftStartingDate,
          end: shiftEndingDate,
        ),
        offPeriod: OffPeriod(
          start: offStartingDay,
          end: offEndingDay,
        ),
      );
      log.wtf("updatedStaffData: ${staffAccountModelToJson(updatedStaffData)}");
      if (checkDatesNotOverlap() == true) {
        updateStaffSchedules(context, updatedStaffData);
      } else {
        log.w("Dates are Overlapping");
        update();
      }
    } else {
      dateOverlapsError = 'Resolve all dates conflicts to proceed';
      update();
    }
  }

  updateDeviceFcmToken() async {
    final pushMessagingNotification = locator<PushNotificationService>();
    try {
      var deviceToken = pushMessagingNotification.deviceToken;
      GlobalVariables.myDeviceToken = deviceToken;
      log.wtf("GlobalVariables DeviceToken: ${GlobalVariables.myDeviceToken}");
      UpdateDeviceTokenModel deviceTokenData = UpdateDeviceTokenModel(
        deviceToken: deviceToken,
      );
      DatabaseReference ref;

      if (GlobalVariables.myUsername.contains("admin") == true) {
        ref = FirebaseDatabase.instance.ref(GlobalVariables.myUsername);
      } else {
        ref = FirebaseDatabase.instance
            .ref('staffs/${GlobalVariables.myUsername}');
      }

      await ref.update(deviceTokenData.toJson()).then((value) async {
        log.w("My DeviceToken Updated");
      });
    } catch (e) {
      log.w("Error updating deviceToken: ${e.toString()}");
    }
  }

  getAllStaffsData() {
    updateDeviceFcmToken();
    staffsData = [];
    final allStaffDetailsRef = FirebaseDatabase.instance.ref("staffs");

    if (GlobalVariables.accountType.toLowerCase().contains("admin") == true) {
      log.w("Account type is admin");
      getNotificationsData();
    } else {
      log.w("Account type is staff");
      getMyData();
    }

    allStaffDetailsRef.onChildAdded.listen(
      (event) {
        StaffAccountModel staffDetails = staffAccountModelFromJson(
            jsonEncode(event.snapshot.value).toString());
        staffsData.add(staffDetails);

        log.wtf("returned feeds: ${staffDetails.toJson()}");
        log.d("Going again");
        doneLoading = true;

        /// Sort: If user,  Put user data object first,
        /// arrange others in alphabetical order.

        log.wtf("Sorting list now");
        staffsData.sort((a, b) {
          if (a.username == GlobalVariables.myUsername &&
              b.username == GlobalVariables.myUsername) {
            return a.fullName!.compareTo(b.fullName!);
          } else if (a.username == GlobalVariables.myUsername) {
            return -1;
          } else if (b.username == GlobalVariables.myUsername) {
            return 1;
          } else {
            return a.fullName!.compareTo(b.fullName!);
          }
        });
        log.wtf(staffsData.first);
      },
    );

    doneLoading = true;
  }

  getMyData() async {
    updateDeviceFcmToken();
    final getDataRef = FirebaseDatabase.instance.ref();
    final getDataSnapshot =
        await getDataRef.child('staffs/${GlobalVariables.myUsername}').get();

    if (getDataSnapshot.exists) {
      log.i("User exists: ${getDataSnapshot.value}");

      StaffAccountModel userAccountModel = staffAccountModelFromJson(
        jsonEncode(getDataSnapshot.value).toString(),
      );
      myData = userAccountModel;
      GlobalVariables.myFullName = userAccountModel.fullName!;
      doneLoading = true;
      update();
    }
    doneLoading = true;
  }

  gotoUserSchedule(BuildContext context, String username) async {
    getNotificationsData();
    final getDataRef = FirebaseDatabase.instance.ref();
    final getDataSnapshot = await getDataRef.child('staffs/$username').get();

    if (getDataSnapshot.exists) {
      log.i("User exists: ${getDataSnapshot.value}");

      StaffAccountModel userData = staffAccountModelFromJson(
        jsonEncode(getDataSnapshot.value).toString(),
      );
      doneLoading = true;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditStaffSchedulePageView(
            staffData: userData,
          ),
        ),
      );
    }

    doneLoading = true;
    update();
  }

  Future<List<DateTime>?> selectDateRange(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    List<DateTime>? selectedDateTime = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      // startFirstDate: DateTime(1600).subtract(const Duration(days: 7)),
      startFirstDate: DateTime.now().subtract(const Duration(days: 0)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),

      // endFirstDate: DateTime(1600).subtract(const Duration(days: 7)),
      endFirstDate: DateTime.now().subtract(const Duration(days: 0)),
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
    return selectedDateTime;
  }

  selectNextShiftPeriod(BuildContext context) async {
    List<DateTime>? shiftDateRange = await selectDateRange(context);

    if (shiftDateRange != null) {
      if (shiftDateRange[0].isBefore(shiftDateRange[1]) == true) {
        log.wtf("startDay is before endDay");

        shiftStartingDate = shiftDateRange[0];
        shiftEndingDate = shiftDateRange[1];
        log.wtf(
            "shiftDate - start: $shiftStartingDate \t end: $shiftEndingDate ");
        shiftDatesValid = true;
        allDatesValid = true;
      } else {
        log.w("Invalid shift date selected");
        shiftDatesValid = false;
        allDatesValid = false;
      }
      dateOverlapsError = '';
    } else {
      // dateOverlapsError = 'Select valid dates';
      // update();
    }
    update();
  }

  selectNextOffPeriod(BuildContext context) async {
    List<DateTime>? offDateRange = await selectDateRange(context);

    if (offDateRange != null) {
      if (offDateRange[0].isBefore(offDateRange[1]) == true) {
        log.wtf("startDay is before endDay");

        offStartingDay = offDateRange[0];
        offEndingDay = offDateRange[1];
        log.wtf("offDate - start: $offStartingDay \t end: $offEndingDay ");
        offDatesValid = true;
        allDatesValid = true;
      } else {
        log.w("Invalid off date selected");
        offDatesValid = false;
        allDatesValid = false;
      }
      dateOverlapsError = '';
    } else {
      // dateOverlapsError = 'Select valid dates';
      // update();
    }
    update();
  }

  selectRequestLeavePeriod(BuildContext context) async {
    List<DateTime>? leaveDateRange = await selectDateRange(context);

    if (leaveDateRange != null) {
      if (leaveDateRange[0].isBefore(leaveDateRange[1]) == true) {
        log.wtf("startDay is before endDay");

        leaveStartingDay = leaveDateRange[0];
        leaveEndingDay = leaveDateRange[1];
        log.wtf(
            "Leave Date - start: $leaveStartingDay \t end: $leaveEndingDay ");
        leaveDatesValid = true;
      } else {
        log.w("Invalid Leave date selected");
        leaveDatesValid = false;
      }
      dateOverlapsError = '';
    } else {
      // leaveDatesValid = false;
    }
    update();
  }

  sendRequestToAdmin(BuildContext context) async {
    final pushMessagingNotification = locator<PushNotificationService>();
    try {
      var deviceToken = pushMessagingNotification.deviceToken;
      GlobalVariables.myDeviceToken = deviceToken;
      log.wtf("GlobalVariables DeviceToken: ${GlobalVariables.myDeviceToken}");

      RequestLeaveModel leaveData = RequestLeaveModel(
        username: GlobalVariables.myUsername,
        fullname: GlobalVariables.myFullName,
        leaveStart: leaveStartingDay,
        leaveEnd: leaveEndingDay,
        seen: false,
        granted: false,
        created: DateTime.now(),
        imageUrl: myData?.image,
      );

      DatabaseReference ref =
          FirebaseDatabase.instance.ref('notifications/${leaveData.username}');

      await ref.update(leaveData.toJson()).then((value) async {
        log.w("My DeviceToken Updated");
        context.pop();

        // Get Admin Device Token
        final getDataRef = FirebaseDatabase.instance.ref();
        final getDataSnapshot =
            await getDataRef.child('admin001/device_token').get();

        String notifMessage =
            "You have a leave request from ${leaveData.fullname}";

        if (getDataSnapshot.exists) {
          // Send Notification to the Admin
          log.wtf("Admin Device token: ${getDataSnapshot.value}");
          FcmService().sendPushNotification(
            receipientDeviceToken: getDataSnapshot.value.toString(),
            message: notifMessage,
          );
        } else {}
      }, onError: (e) {
        log.w("Error requesting leave}");
        showCustomSnackBar(
          context,
          "Error requesting leave",
          () {},
          AppColors.fullBlack,
          2000,
        );
      });
    } catch (e) {
      log.w("Error requesting leave}");
      showCustomSnackBar(
        context,
        "Error requesting leave",
        () {},
        AppColors.fullBlack,
        2000,
      );
    }
    resetValues();
  }

  updateNotificationStatus(BuildContext context, String username) async {
    UpdateNotificationModel updatedNotifData =
        UpdateNotificationModel(seen: true, created: DateTime.now());

    DatabaseReference ref =
        FirebaseDatabase.instance.ref('notifications/$username');

    await ref.update(updatedNotifData.toJson()).then((value) async {},
        onError: (e) {
      log.w("Error requesting leave}");
      showCustomSnackBar(
        context,
        "Error requesting leave",
        () {},
        AppColors.fullBlack,
        2000,
      );
    });
    gotoUserSchedule(context, username);
  }

  getNotificationsData() {
    Map<String, RequestLeaveModel> requestLeaveMap = {};
    notificationsData = [];
    unseenNotificationsCount = 0;
    final notifsRef = FirebaseDatabase.instance.ref("notifications");

    notifsRef.onChildAdded.listen(
      (event) {
        RequestLeaveModel notifsDetails = requestLeaveModelFromJson(
            jsonEncode(event.snapshot.value).toString());
        notificationsData.add(notifsDetails);
        if (notifsDetails.seen == false) unseenNotificationsCount += 1;

        log.wtf("returned notifications: ${notifsDetails.toJson()}");
        log.d("$unseenNotificationsCount: Going again");
        doneLoading = true;

        // Sort in order of newest date

        notificationsData.sort((a, b) => a.created!.compareTo(b.created!));

        // Loop through the sorted list and add the most recent
        // notification object for each username to the map
        for (var data in notificationsData) {
          if (!requestLeaveMap.containsKey(data.username)) {
            requestLeaveMap[data.username!] = data;
          }
        }
        notificationsData = requestLeaveMap.values.toList();

        update();
      },
    );

    doneLoading = true;
    update();
  }
}
