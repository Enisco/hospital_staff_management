import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/custom_navbar.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/ui/features/profile/profile_controller/profile_controller.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/ui/shared/global_variables.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_key_strings.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
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

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () async {
        Provider.of<CurrentPage>(context, listen: false)
            .setCurrentPageIndex(0);
        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenSize(context).width, 60),
          child: CustomAppbar(
            title: AppKeyStrings.profile,
            appbarColor: AppColors.plainWhite,
            titleColor: AppColors.kPrimaryColor,
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          color: AppColors.plainWhite,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize(context).width / 14, vertical: 20),
          child: GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (_) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.green,
                            Colors.yellow,
                            Colors.red,
                            Colors.purple
                          ]),
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: AppColors.plainWhite,
                            shape: BoxShape.circle,
                          ),
                          child: _controller.myAccountData.image == '' ||
                                  _controller.myAccountData.image == null
                              ? CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.blueGray,
                                  foregroundImage: CachedNetworkImageProvider(
                                    _controller.myAccountData.image!,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    CustomSpacer(20),
                    Text(
                      GlobalVariables.myUsername,
                      style: AppStyles.keyStringStyle(
                        18,
                        AppColors.fullBlack,
                      ),
                    ),
                    _controller.detailsLoaded == true
                        ? Column(
                            children: [
                              CustomSpacer(5),
                              Text(
                                "${_controller.myAccountData.fullName}",
                                style: TextStyle(
                                  color: Colors.purple.shade300,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CustomSpacer(30),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: AppColors.plainWhite,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Card(
                                        elevation: 4,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: const Color.fromARGB(
                                                    255, 186, 221, 238)
                                                .withOpacity(0.2),
                                          ),
                                          width: screenSize(context).width,
                                          child: Column(
                                            children: [
                                              CustomSpacer(12),
                                              Text(
                                                "Total Points: ",
                                                style: AppStyles
                                                    .regularStringStyle(
                                                  15,
                                                  AppColors.black,
                                                ),
                                              ),
                                              CustomSpacer(8),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    CustomSpacer(40),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        color: AppColors.lighterGray,
                                      ),
                                      child: Column(
                                        children: [
                                          CustomSpacer(20),
                                          Text(
                                            "Toponyms Recorded:",
                                            textAlign: TextAlign.center,
                                            style:
                                                AppStyles.regularStringStyle(
                                              16,
                                              AppColors.kPrimaryColor,
                                            ),
                                          ),
                                          CustomSpacer(25),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              CustomSpacer(40),
                              CircularProgressIndicator(
                                color: AppColors.kPrimaryColor,
                              )
                            ],
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
