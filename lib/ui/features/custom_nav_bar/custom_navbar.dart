// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hospital_staff_management/ui/features/custom_nav_bar/page_index_class.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_key_strings.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key, required this.color});
  final Color color;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lighterGray,
      height: 68,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 17),
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Home Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    0) {
                  print('Home selected');
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(0);
                  context.canPop() ? context.pop() : () {};
                } else {
                  print('You are already in homepage');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            0
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          0
                      ? 30
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.home,
                      size: 20,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.2),
                    ),
                    Text(
                      AppKeyStrings.home,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                0
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Record Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    1) {
                  print('Record selected');
                  final bool currentPageIndexCheck =
                      Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? true
                          : false;
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(1);

                  print('currentPageIndexCheck: $currentPageIndexCheck');
                  currentPageIndexCheck == true
                      ? context.push('/recordPageView')
                      : context.pushReplacement('/recordPageView');
                } else {
                  print('You are already in recordPageView');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            1
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          1
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          1
                      ? 30
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.lightbulb_outlined,
                      size: 20,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              1
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.2),
                    ),
                    Text(
                      AppKeyStrings.insights,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                1
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Profile Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    2) {
                  print('Profile selected');
                  final bool currentPageIndexCheck =
                      Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? true
                          : false;
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(2);

                  print('currentPageIndexCheck: $currentPageIndexCheck');
                  currentPageIndexCheck == true
                      ? context.push('/profilePageView')
                      : context.pushReplacement('/profilePageView');
                } else {
                  print('You are already in ProfilePageView');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            2
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          2
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          2
                      ? 30
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              2
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.2),
                      size: 20,
                    ),
                    Text(
                      AppKeyStrings.profile,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                2
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Activity Icon
            InkWell(
              onTap: () {
                if (Provider.of<CurrentPage>(context, listen: false)
                        .currentPageIndex !=
                    3) {
                  print('Activity selected');
                  final bool currentPageIndexCheck =
                      Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              0
                          ? true
                          : false;
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(3);

                  print('currentPageIndexCheck: $currentPageIndexCheck');
                  currentPageIndexCheck == true
                      ? context.push('/activityPageView')
                      : context.pushReplacement('/activityPageView');
                } else {
                  print('You are already in ActivityPageView');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(23)),
                  border: Border.all(
                    color: Provider.of<CurrentPage>(context, listen: false)
                                .currentPageIndex ==
                            3
                        ? AppColors.lightGray
                        : AppColors.transparent,
                  ),
                  color: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          3
                      ? AppColors.kPrimaryColor
                      : AppColors.transparent,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Provider.of<CurrentPage>(context, listen: false)
                              .currentPageIndex ==
                          3
                      ? 30
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.leaderboard_outlined,
                      color: Provider.of<CurrentPage>(context, listen: false)
                                  .currentPageIndex ==
                              3
                          ? AppColors.plainWhite
                          : AppColors.fullBlack.withOpacity(0.2),
                      size: 20,
                    ),
                    Text(
                      AppKeyStrings.activity,
                      style: AppStyles.navBarStringStyle(
                        Provider.of<CurrentPage>(context, listen: false)
                                    .currentPageIndex ==
                                3
                            ? AppColors.plainWhite
                            : AppColors.fullBlack.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
