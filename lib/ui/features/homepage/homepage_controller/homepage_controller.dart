import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.locator.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/app/services/fcm_services/fcm_service.dart';
import 'package:hospital_staff_management/app/services/fcm_services/push_notification_service.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/update_user_model.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

var log = getLogger('HomepageController');

enum ShiftsPeriod { morning, afternoon, night, off }

class HomepageController extends GetxController {
  bool doneLoading = false;
  List<StaffAccountModel> staffsData = [];
  StaffAccountModel? myData;
  DateTime? shiftStartingDate, offStartingDay, shiftEndingDate, offEndingDay;
  bool? allDatesValid, shiftDatesValid, offDatesValid, datesDoNotOverlap;
  String? dateOverlapsError = '';

  ShiftsPeriod? selectedShift;

  resetValues() {
    doneLoading = true;
    selectedShift = null;
    shiftStartingDate = null;
    shiftEndingDate = null;
    offStartingDay = null;
    offEndingDay = null;
    dateOverlapsError = '';
    shiftDatesValid = null;
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
        log.w("Staff Schedule Updated");

        // Send Notification to the Staff
        if (updatedStaffData.deviceToken == null) {
          FcmService().sendPushNotification(
            receipientDeviceToken: updatedStaffData.deviceToken!,
            notificationFrom: GlobalVariables.accountType,
          );
        }
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

  getAllStaffsData() {
    doneLoading = false;
    update();
    staffsData = [];
    final allStaffDetailsRef = FirebaseDatabase.instance.ref("staffs");

    allStaffDetailsRef.onChildAdded.listen(
      (event) {
        StaffAccountModel staffDetails = staffAccountModelFromJson(
            jsonEncode(event.snapshot.value).toString());
        staffsData.add(staffDetails);

        doneLoading = true;
        update();
        log.wtf("returned feeds: ${staffDetails.toJson()}");
        log.d("Going again");
      },
    );
    doneLoading = true;
    update();
  }

  getMyData() async {
    final getDataRef = FirebaseDatabase.instance.ref();
    final getDataSnapshot =
        await getDataRef.child('staffs/${GlobalVariables.myUsername}').get();

    if (getDataSnapshot.exists) {
      log.i("User exists: ${getDataSnapshot.value}");

      StaffAccountModel userAccountModel = staffAccountModelFromJson(
        jsonEncode(getDataSnapshot.value).toString(),
      );
      myData = userAccountModel;
      doneLoading = true;
      update();
    }
  }

  Future<List<DateTime>?> selectDateRange(BuildContext context) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    List<DateTime>? selectedDateTime = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      // startFirstDate: DateTime(1600).subtract(const Duration(days: 7)),
      startFirstDate: DateTime.now().subtract(const Duration(days: 7)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),

      // endFirstDate: DateTime(1600).subtract(const Duration(days: 7)),
      endFirstDate: DateTime.now().subtract(const Duration(days: 7)),
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

  updateDeviceFcmToken() async {
    final _pushMessagingNotification = locator<PushNotificationService>();
    try {
      var deviceToken = _pushMessagingNotification.deviceToken;
      GlobalVariables.myDeviceToken = deviceToken;
      log.wtf("GlobalVariables DeviceToken: ${GlobalVariables.myDeviceToken}");
      UpdateDeviceTokenModel deviceTokenData = UpdateDeviceTokenModel(
        deviceToken: deviceToken,
      );

      DatabaseReference ref =
          FirebaseDatabase.instance.ref('staffs/${GlobalVariables.myUsername}');

      await ref.update(deviceTokenData.toJson()).then((value) async {
        log.w("Staff Schedule Updated");
      });
    } catch (e) {
      log.w("Error updating deviceToken: ${e.toString()}");
    }
  }
}
