// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/req_leave_model.dart';
import 'package:hospital_staff_management/ui/shared/custom_button.dart';
import 'package:hospital_staff_management/ui/shared/spacer.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: screenSize(context).width,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
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
            width: screenSize(context).width - 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: screenSize(context).width - 155,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.notificationData.fullname}',
                            style: AppStyles.floatingHintStringStyleColored(
                              14,
                              AppColors.fullBlack,
                            ),
                          ),
                          CustomSpacer(8),
                          RichText(
                            text: TextSpan(
                              text: 'requested for a leave, from',
                              style: AppStyles.floatingHintStringStyleColored(
                                14,
                                AppColors.darkGray,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      "${DateFormat.yMMMEd().format(widget.notificationData.leaveStart!)}",
                                  style:
                                      AppStyles.floatingHintStringStyleColored(
                                    14,
                                    AppColors.fullBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: " to ",
                                  style:
                                      AppStyles.floatingHintStringStyleColored(
                                    14,
                                    AppColors.darkGray,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${DateFormat.yMMMEd().format(widget.notificationData.leaveEnd!)}",
                                  style:
                                      AppStyles.floatingHintStringStyleColored(
                                    14,
                                    AppColors.fullBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomSpacer(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                borderRadius: 20,
                                width: (screenSize(context).width - 150) * 0.4,
                                color: AppColors.blueGray,
                                height: 30,
                                child: Text(
                                  'Grant',
                                  style: AppStyles.normalStringStyle(
                                    14,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              CustomButton(
                                borderRadius: 20,
                                width: (screenSize(context).width - 150) * 0.4,
                                color: AppColors.blueGray,
                                height: 40,
                                child: Text(
                                  'Decline',
                                  style: AppStyles.normalStringStyle(
                                    14,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 55,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: AppColors.blueGray,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            widget.notificationData.imageUrl ??
                                "https://guardian.ng/wp-content/uploads/2017/12/rockconcert21-e1512298206255.jpg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
