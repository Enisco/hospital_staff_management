import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/user_schedule_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:badges/badges.dart' as badges;

var log = getLogger('HomepageView');

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      shouldAddCallback: true,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: false,
        bottomNavigationBar: CustomNavBar(
          color: AppColors.plainWhite,
        ),
        body: GlobalVariables.accountType == "admin"
            ? const AdminHomePage()
            : const StaffHomePage(),
      ),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final HomepageController _controller = HomepageController.to;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _controller.getAllStaffsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: _controller,
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.lightGray,
          appBar: PreferredSize(
            preferredSize: Size(screenSize(context).width, 60),
            child: CustomAppbar(
              title: "Staffs",
              actionWidget: InkWell(
                onTap: () async {
                  await context.push("/notificationsView").whenComplete(() {
                    log.wtf("Returned from Notifications Screen:");
                    _controller.getNotificationsData();
                  });
                },
                child: SizedBox(
                  width: 80,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    width: 30,
                    child: badges.Badge(
                      badgeContent: Text(
                        _controller.unseenNotificationsCount.toString(),
                        style: TextStyle(
                          color: AppColors.plainWhite,
                          fontSize: 12,
                        ),
                      ),
                      showBadge: _controller.unseenNotificationsCount > 0
                          ? true
                          : false,
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: AppColors.plainWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.lighterGray,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    reverse: false,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _controller.staffsData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StaffCard(
                        staffData: _controller.staffsData[index],
                      );
                    },
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

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  final HomepageController _controller = HomepageController.to;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _controller.getAllStaffsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: _controller,
      builder: (_) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(screenSize(context).width, 60),
            child: const CustomAppbar(
              title: "My Schedules",
            ),
          ),
          body: _controller.doneLoading == false ||
                  _controller.staffsData.length <= 0
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.kPrimaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomSpacer(10),
                      UserScheduleCard(staffData: _controller.staffsData[0]),
                      CustomSpacer(15),
                      Row(
                        children: [
                          Text(
                            "  Other Staff Schedules",
                            style: AppStyles.regularStringStyle(
                                16, AppColors.fullBlack),
                          ),
                        ],
                      ),
                      Container(
                        color: AppColors.lighterGray,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          reverse: false,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _controller.staffsData.length - 1,
                          itemBuilder: (BuildContext context, int index) {
                            return StaffCard(
                              staffData: _controller.staffsData[index + 1],
                            );
                          },
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
