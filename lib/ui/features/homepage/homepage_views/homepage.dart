import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/staffs_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

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
    return SafeArea(
      child: ConditionalWillPopScope(
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

  final _controller = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
      builder: (_) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(screenSize(context).width, 60),
            child: const CustomAppbar(
              title: "Staffs",
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.lighterGray,
                  child: ListView.builder(
                    reverse: false,
                    physics: const NeverScrollableScrollPhysics(),
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
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _controller.getMyData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _controller = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      init: HomepageController(),
      builder: (_) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(screenSize(context).width, 60),
            child: const CustomAppbar(
              title: "<My> Schedules",
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                CustomSpacer(20),
                Center(
                  child: Text(
                    _controller.myData?.fullName ?? "No data",
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
