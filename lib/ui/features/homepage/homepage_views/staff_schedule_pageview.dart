import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/gray_curved_container.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/full_screen_image.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';

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
    if (widget.staffData.currentShift != null) {
      _controller.syncStaffCurrentShiftSchedule(widget.staffData.currentShift!);
    }
    if (widget.staffData.offPeriod != null) {
      _controller.syncStaffOffPeriodSchedule(widget.staffData.offPeriod!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
      builder: (_) {
        return ConditionalWillPopScope(
          onWillPop: () async {
            _controller.resetValues();
            Navigator.pop(context);
            return false;
          },
          shouldAddCallback: true,
          child: Scaffold(
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
                    height: 250,
                    padding:
                        const EdgeInsets.only(top: 120, left: 20, right: 20),
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
                  CustomSpacer(20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    width: screenSize(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Assign Shift",
                          style: AppStyles.regularStringStyle(
                              18, AppColors.fullBlack),
                        ),
                        SizedBox(
                          width: screenSize(context).width,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _controller.selectedShift =
                                                ShiftsPeriod.morning;
                                          });
                                          log.wtf(_controller.selectedShift);
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 0),
                                        title: Text(ShiftsPeriod.morning.name
                                            .toString()
                                            .toSentenceCase),
                                        leading: Radio(
                                          value: ShiftsPeriod.morning,
                                          groupValue: _controller.selectedShift,
                                          onChanged: (natural) {
                                            setState(() {
                                              _controller.selectedShift =
                                                  ShiftsPeriod.morning;
                                              log.wtf(
                                                  _controller.selectedShift);
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _controller.selectedShift =
                                                ShiftsPeriod.night;
                                          });
                                          log.wtf(_controller.selectedShift);
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 0),
                                        title: Text(ShiftsPeriod.night.name
                                            .toString()
                                            .toSentenceCase),
                                        leading: Radio(
                                          value: ShiftsPeriod.night,
                                          groupValue: _controller.selectedShift,
                                          onChanged: (natural) {
                                            setState(() {
                                              _controller.selectedShift =
                                                  ShiftsPeriod.night;
                                              log.wtf(
                                                  _controller.selectedShift);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _controller.selectedShift =
                                                ShiftsPeriod.afternoon;
                                          });
                                          log.wtf(_controller.selectedShift);
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 0),
                                        title: Text(ShiftsPeriod.afternoon.name
                                            .toString()
                                            .toSentenceCase),
                                        leading: Radio(
                                          value: ShiftsPeriod.afternoon,
                                          groupValue: _controller.selectedShift,
                                          onChanged: (natural) {
                                            setState(() {
                                              _controller.selectedShift =
                                                  ShiftsPeriod.afternoon;
                                              log.wtf(
                                                  _controller.selectedShift);
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            _controller.selectedShift =
                                                ShiftsPeriod.off;
                                          });
                                          log.wtf(_controller.selectedShift);
                                        },
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 0),
                                        title: Text(ShiftsPeriod.off.name
                                            .toString()
                                            .toSentenceCase),
                                        leading: Radio(
                                          value: ShiftsPeriod.off,
                                          groupValue: _controller.selectedShift,
                                          onChanged: (natural) {
                                            setState(() {
                                              _controller.selectedShift =
                                                  ShiftsPeriod.off;
                                              log.wtf(
                                                  _controller.selectedShift);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        CustomSpacer(20),
                        _controller.selectedShift == null
                            ? const SizedBox.shrink()
                            : Column(
                                children: [
                                  // For Next Shift Date Period Selection
                                  SizedBox(
                                    child:
                                        _controller.selectedShift ==
                                                ShiftsPeriod.off
                                            ? const SizedBox.shrink()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_controller.selectedShift?.name.toString().toSentenceCase} Shift Period",
                                                    style: AppStyles
                                                        .regularStringStyle(
                                                            18,
                                                            AppColors
                                                                .fullBlack),
                                                  ),
                                                  CustomSpacer(15),
                                                  InkWell(
                                                    onTap: (() async {
                                                      _controller
                                                          .selectNextShiftPeriod(
                                                              context);

                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                    }),
                                                    child:
                                                        CustomCurvedContainer(
                                                      borderColor: _controller
                                                                  .shiftDatesValid ==
                                                              false
                                                          ? AppColors.coolRed
                                                          : AppColors
                                                              .transparent,
                                                      width: screenSize(context)
                                                          .width,
                                                      height: _controller
                                                                  .shiftStartingDate ==
                                                              null
                                                          ? 61
                                                          : 65,
                                                      leftPadding: 23,
                                                      child: _controller
                                                                  .shiftStartingDate ==
                                                              null
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "Select Next Shift Period",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: AppStyles
                                                                      .hintStringStyle(
                                                                          13),
                                                                ),
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: screenSize(
                                                                              context)
                                                                          .width *
                                                                      0.42,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        'From:',
                                                                        style: AppStyles.hintStringStyle(
                                                                            13),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat.yMMMEd().format(_controller.shiftStartingDate!),
                                                                            style:
                                                                                AppStyles.inputStringStyle(AppColors.fullBlack).copyWith(fontSize: 14),
                                                                          ),
                                                                          CustomSpacer(
                                                                              8),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'To:',
                                                                      style: AppStyles
                                                                          .hintStringStyle(
                                                                              13),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          DateFormat.yMMMEd()
                                                                              .format(_controller.shiftEndingDate!),
                                                                          style:
                                                                              AppStyles.inputStringStyle(AppColors.fullBlack).copyWith(fontSize: 14),
                                                                        ),
                                                                        CustomSpacer(
                                                                            8),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                  CustomSpacer(8),
                                                  Text(
                                                    _controller.shiftDatesValid ==
                                                            false
                                                        ? "Ending date must be after the starting date"
                                                        : "",
                                                    style: AppStyles
                                                        .floatingHintStringStyleColored(
                                                            14,
                                                            AppColors.coolRed),
                                                  ),
                                                  CustomSpacer(20),
                                                ],
                                              ),
                                  ),

                                  // For Next Off Date Period Selection
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Next Off Period",
                                          style: AppStyles.regularStringStyle(
                                              18, AppColors.fullBlack),
                                        ),
                                        CustomSpacer(15),
                                        InkWell(
                                          onTap: (() async {
                                            _controller
                                                .selectNextOffPeriod(context);

                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          }),
                                          child: CustomCurvedContainer(
                                            borderColor:
                                                _controller.offDatesValid ==
                                                        false
                                                    ? AppColors.coolRed
                                                    : AppColors.transparent,
                                            width: screenSize(context).width,
                                            height:
                                                _controller.offStartingDay ==
                                                        null
                                                    ? 61
                                                    : 65,
                                            leftPadding: 23,
                                            child: _controller.offStartingDay ==
                                                    null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "Select Next Off Period",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppStyles
                                                            .hintStringStyle(
                                                                13),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            screenSize(context)
                                                                    .width *
                                                                0.42,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'From:',
                                                              style: AppStyles
                                                                  .hintStringStyle(
                                                                      13),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  DateFormat
                                                                          .yMMMEd()
                                                                      .format(_controller
                                                                          .offStartingDay!),
                                                                  style: AppStyles.inputStringStyle(
                                                                          AppColors
                                                                              .fullBlack)
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14),
                                                                ),
                                                                CustomSpacer(8),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'To:',
                                                            style: AppStyles
                                                                .hintStringStyle(
                                                                    13),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                DateFormat
                                                                        .yMMMEd()
                                                                    .format(_controller
                                                                        .offEndingDay!),
                                                                style: AppStyles.inputStringStyle(
                                                                        AppColors
                                                                            .fullBlack)
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14),
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
                                        CustomSpacer(8),
                                        Text(
                                          _controller.offDatesValid == false
                                              ? "Ending date must be after the starting date"
                                              : "",
                                          style: AppStyles
                                              .floatingHintStringStyleColored(
                                                  14, AppColors.coolRed),
                                        ),
                                        CustomSpacer(20),
                                      ],
                                    ),
                                  ),

                                  CustomSpacer(12),
                                  Center(
                                    child: Text(
                                      _controller.dateOverlapsError ?? '',
                                      style: AppStyles
                                          .floatingHintStringStyleColored(
                                              14, AppColors.coolRed),
                                    ),
                                  ),
                                  CustomSpacer(6),
                                  _controller.doneLoading == false
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: AppColors.kPrimaryColor,
                                          ),
                                        )
                                      : Center(
                                          child: CustomButton(
                                            styleBoolValue: true,
                                            width:
                                                screenSize(context).width * 0.5,
                                            height: 55,
                                            color: AppColors.kPrimaryColor,
                                            child: Text(
                                              'Upload',
                                              style:
                                                  AppStyles.regularStringStyle(
                                                18,
                                                AppColors.plainWhite,
                                              ),
                                            ),
                                            onPressed: () {
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.hide');
                                              _controller.createStaffSchedule(
                                                context,
                                                widget.staffData,
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
