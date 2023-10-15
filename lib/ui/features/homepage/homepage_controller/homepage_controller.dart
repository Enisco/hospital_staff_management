// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

var log = getLogger('HomepageController');

enum ShiftsPeriod { morning, afternoon, night, off, shift }

class HomepageController extends GetxController {
  bool doneLoading = false;
  List<StaffAccountModel> staffsData = [];
  StaffAccountModel? myData;
  DateTime? shiftStartingDate, offStartingDay, shiftEndingDate, offEndingDay;
  bool? allDatesValid, shiftDatesValid, offDatesValid, datesDoNotOverlap;
  String dateOverlapsError = '';

  ShiftsPeriod? selectedShift;

  resetValues() {
    doneLoading = true;
    selectedShift = ShiftsPeriod.shift;
    shiftStartingDate = null;
    shiftEndingDate = null;
    offStartingDay = null;
    offEndingDay = null;
    dateOverlapsError = '';
    shiftDatesValid = null;
    offDatesValid = null;
    datesDoNotOverlap = null;
    update();
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

  syncStaffCurrentShiftSchedule(CurrentShift currentShift) {
    shiftStartingDate = currentShift.start;
    shiftEndingDate = currentShift.end;
    log.wtf(
        "Updated Staff Current Shift Schedule: ${shiftStartingDate?.toIso8601String()}");
    update();
  }

  syncStaffOffPeriodSchedule(OffPeriod offPeriod) {
    offStartingDay = offPeriod.start;
    offEndingDay = offPeriod.end;
    log.wtf("Updated Staff Off Schedule: ${offStartingDay?.toIso8601String()}");
    update();
  }

  // Update the data in the DB
  updateStaffSchedules(
    BuildContext context,
    StaffAccountModel updatedStaffData,
  ) async {
    doneLoading = false;
    update();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('staffs/${updatedStaffData.username}');

    await ref.update(updatedStaffData.toJson()).then((value) async {
      log.w("Staff Schedule Updated");
      context.pop();
    });
    doneLoading = true;
    update();
  }

  createStaffSchedule(
    BuildContext context,
    StaffAccountModel staffData,
  ) {
    if (shiftDatesValid == true && offDatesValid == true) {
      StaffAccountModel updatedStaffData = staffData.copyWith(
        currentShift: CurrentShift(
          shift: selectedShift?.name.toString().toSentenceCase,
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
      dateOverlapsError = 'Reolve all dates conflicts to proceed';
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
      print("User exists: ${getDataSnapshot.value}");

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

  selectNextShiftPeriod(BuildContext context) async {
    List<DateTime>? shiftDateRange = await selectDateRange(context);
    if (allDatesValid == true) {
      shiftStartingDate = shiftDateRange![0];
      shiftEndingDate = shiftDateRange[1];
      log.wtf(
          "shiftDate - start: $shiftStartingDate \t end: $shiftEndingDate ");
      shiftDatesValid = true;
    } else {
      log.w("Invalid shift date selected");
      shiftDatesValid = false;
    }
    dateOverlapsError = '';
    update();
  }

  selectNextOffPeriod(BuildContext context) async {
    List<DateTime>? offDateRange = await selectDateRange(context);
    if (allDatesValid == true) {
      offStartingDay = offDateRange![0];
      offEndingDay = offDateRange[1];
      log.wtf("offDate - start: $offStartingDay \t end: $offEndingDay ");
      offDatesValid = true;
    } else {
      log.w("Invalid off date selected");
      offDatesValid = false;
    }
    dateOverlapsError = '';
    update();
  }
}
