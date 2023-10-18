import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/features/profile/profile_controller/profile_controller.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/extension_and_methods/full_screen_image.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

var log = getLogger('ProfilePageView');

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  final _controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _controller.getMyProfileData();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    return ConditionalWillPopScope(
      onWillPop: () async {
        Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);
        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (_) {
            return Scaffold(
              extendBodyBehindAppBar: false,
              appBar: PreferredSize(
                preferredSize: Size(screenSize(context).width, 430),
                child: Container(
                  height: 430,
                  padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _controller.myAccountData.fullName ?? "HSMS",
                        style: AppStyles.regularStringStyle(
                            18, AppColors.plainWhite),
                      ),
                      CustomSpacer(20),
                      InkWell(
                        onTap: () => showFullScreenImage(
                          context,
                          _controller.myAccountData.image ??
                              dummyAvatarUrl(
                                _controller.myAccountData.image ?? 'male',
                              ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.blueGray,
                          radius: 80,
                          backgroundImage: CachedNetworkImageProvider(
                            _controller.myAccountData.image ??
                                dummyAvatarUrl(
                                  _controller.myAccountData.gender ?? 'male',
                                ),
                          ),
                        ),
                      ),
                      CustomSpacer(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          SizedBox(
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.person_alt_circle,
                                      color: AppColors.plainWhite,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _controller.myAccountData.username ?? '',
                                      style: AppStyles.regularStringStyle(
                                          14, AppColors.plainWhite),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone_in_talk_outlined,
                                        color: AppColors.bronze),
                                    const SizedBox(width: 6),
                                    Text(
                                      _controller.myAccountData.phone ?? '',
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
                                      _controller.myAccountData.email ?? '',
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
                                      _controller.myAccountData.department ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.regularStringStyle(
                                          14, AppColors.plainWhite),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: CustomNavBar(
                color: AppColors.plainWhite,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomSpacer(20),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Check if schedules exist,
                          /// If exists, check if the shift and off end dates are not before today
                          (_controller.myAccountData.offPeriod?.start == null &&
                                      _controller.myAccountData.currentShift
                                              ?.start ==
                                          null) ||
                                  (_controller.myAccountData.offPeriod?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true &&
                                      _controller
                                              .myAccountData.currentShift?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true)
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  width: screenSize(context).width,
                                  color: AppColors.plainWhite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Check if Duty time is in the future

                                      _controller.myAccountData.currentShift
                                                  ?.start ==
                                              null
                                          ? const SizedBox.shrink()
                                          : RichText(
                                              text: TextSpan(
                                                text: (DateTime.now().isAtSameMomentAs(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .start!) ==
                                                            true ||
                                                        DateTime.now().isAfter(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .start!) ==
                                                            true)
                                                    ? "Current Shift: "
                                                    : "Next Shift: ",
                                                style: AppStyles.subStringStyle(
                                                  14,
                                                  AppColors.kPrimaryColor,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: DateTime.now().isAfter(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .end!) ==
                                                            true
                                                        ? "Unspecified"
                                                        : _controller
                                                                    .myAccountData
                                                                    .currentShift
                                                                    ?.start ==
                                                                null
                                                            ? "Unspecified"
                                                            : _controller
                                                                .myAccountData
                                                                .currentShift!
                                                                .shift,
                                                    style: AppStyles
                                                        .keyStringStyle(
                                                      14,
                                                      AppColors.kPrimaryColor,
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
                    ),
                    CustomSpacer(5),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.plainWhite,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        children: [
                          /// Check if schedules exist,
                          /// If exists, check if the shift and off end dates are not before today
                          (_controller.myAccountData.offPeriod?.start == null &&
                                      _controller.myAccountData.currentShift
                                              ?.start ==
                                          null) ||
                                  (_controller.myAccountData.offPeriod?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true &&
                                      _controller
                                              .myAccountData.currentShift?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true)
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  width: screenSize(context).width,
                                  color: AppColors.plainWhite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Check if Duty time is in the future

                                      _controller.myAccountData.currentShift
                                                  ?.start ==
                                              null
                                          ? const SizedBox.shrink()
                                          : RichText(
                                              text: TextSpan(
                                                text: (DateTime.now().isAtSameMomentAs(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .start!) ==
                                                            true ||
                                                        DateTime.now().isAfter(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .start!) ==
                                                            true)
                                                    ? "Shift Period: "
                                                    : "Next Shift Period: ",
                                                style: AppStyles.subStringStyle(
                                                  14,
                                                  AppColors.kPrimaryColor,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: DateTime.now().isAfter(
                                                                _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .end!) ==
                                                            true
                                                        ? "Unspecified"
                                                        : _controller
                                                                    .myAccountData
                                                                    .currentShift
                                                                    ?.start ==
                                                                null
                                                            ? "Unspecified"
                                                            : formatPeriod(
                                                                startDate: _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .start!,
                                                                endDate: _controller
                                                                    .myAccountData
                                                                    .currentShift!
                                                                    .end!,
                                                              ),
                                                    style: AppStyles
                                                        .keyStringStyle(
                                                      14,
                                                      AppColors.kPrimaryColor,
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
                    ),
                    CustomSpacer(5),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Column(
                        children: [
                          // CustomSpacer(12),

                          /// Check if schedules exist,
                          /// If exists, check if the shift and off end dates are not before today
                          (_controller.myAccountData.offPeriod?.start == null &&
                                      _controller.myAccountData.currentShift
                                              ?.start ==
                                          null) ||
                                  (_controller.myAccountData.offPeriod?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true &&
                                      _controller
                                              .myAccountData.currentShift?.end
                                              ?.isBefore(DateTime.now()) ==
                                          true)
                              ? const SizedBox.shrink()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  // margin: const EdgeInsets.only(bottom: 15),
                                  width: screenSize(context).width,
                                  color: AppColors.plainWhite,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Check if Duty time is in the future

                                      RichText(
                                        text: TextSpan(
                                          text: (DateTime.now()
                                                          .isAtSameMomentAs(
                                                              _controller
                                                                  .myAccountData
                                                                  .offPeriod!
                                                                  .start!) ==
                                                      true ||
                                                  DateTime.now().isAfter(
                                                          _controller
                                                              .myAccountData
                                                              .offPeriod!
                                                              .start!) ==
                                                      true)
                                              ? DateTime.now().isAfter(
                                                          _controller
                                                              .myAccountData
                                                              .offPeriod!
                                                              .end!) ==
                                                      true
                                                  ? "Last Off Period: "
                                                  : "Off Duty Period: "
                                              : "Next Off Period: ",
                                          style: AppStyles.subStringStyle(
                                            14,
                                            AppColors.kPrimaryColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _controller.myAccountData
                                                          .offPeriod?.start ==
                                                      null
                                                  ? "Unspecifed"
                                                  : formatPeriod(
                                                      startDate: _controller
                                                          .myAccountData
                                                          .offPeriod!
                                                          .start!,
                                                      endDate: _controller
                                                          .myAccountData
                                                          .offPeriod!
                                                          .end!,
                                                    ),
                                              style: AppStyles.keyStringStyle(
                                                14,
                                                AppColors.kPrimaryColor,
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
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
