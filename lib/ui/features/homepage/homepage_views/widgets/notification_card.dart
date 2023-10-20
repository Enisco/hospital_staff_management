// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/req_leave_model.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatefulWidget {
  RequestLeaveModel notificationData;
  NotificationCard({
    super.key,
    required this.notificationData,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  final _controller = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
        init: _controller,
        builder: (_) {
          return InkWell(
            onTap: () {
              // setState(() {
              //   widget.notificationData.seen = true;
              // });
              if (widget.notificationData.seen == false) {
                HomepageController().updateNotificationStatus(
                  context,
                  widget.notificationData.username!,
                );
              } else {
                _controller.gotoUserSchedule(
                  context,
                  widget.notificationData.username!,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              width: screenSize(context).width,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: AppColors.plainWhite,
                borderRadius: const BorderRadius.all(
                  Radius.circular(23),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: screenSize(context).width - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: AppColors.blueGray,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    widget.notificationData.imageUrl ??
                                        "https://guardian.ng/wp-content/uploads/2017/12/rockconcert21-e1512298206255.jpg",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: screenSize(context).width - 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${widget.notificationData.fullname}',
                                      style: AppStyles.regularStringStyle(
                                        14,
                                        AppColors.fullBlack,
                                      ).copyWith(height: 1.3),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' requested for a leave, from ',
                                          style: AppStyles
                                              .floatingHintStringStyleColored(
                                            14,
                                            AppColors.darkGray,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${DateFormat.yMMMEd().format(widget.notificationData.leaveStart!)}",
                                          style: AppStyles.regularStringStyle(
                                            14,
                                            Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " to ",
                                          style: AppStyles
                                              .floatingHintStringStyleColored(
                                            14,
                                            AppColors.darkGray,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${DateFormat.yMMMEd().format(widget.notificationData.leaveEnd!)}.",
                                          style: AppStyles.regularStringStyle(
                                            14,
                                            Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              borderRadius: 20,
                              width: (screenSize(context).width - 180) * 0.35,
                              color: AppColors.blueGray,
                              height: 30,
                              child: widget.notificationData.seen == false
                                  ? Text(
                                      'Review',
                                      style: AppStyles.normalStringStyle(
                                        14,
                                        color: Colors.green.shade700,
                                      ),
                                    )
                                  : Text(
                                      "Reviewed",
                                      style: AppStyles.regularStringStyle(
                                        14,
                                        AppColors.darkGray,
                                      ),
                                    ),
                              onPressed: () {
                                HomepageController().updateNotificationStatus(
                                  context,
                                  widget.notificationData.username!,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
