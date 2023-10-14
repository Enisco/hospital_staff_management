import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';
import 'package:intl/intl.dart';

var log = getLogger('StaffCard');

class StaffCard extends StatelessWidget {
  const StaffCard({super.key, required this.staffData});

  final StaffAccountModel staffData;

  String formatPeriod(
      {required DateTime startDate, required DateTime endDate}) {
    String formattedDateString =
        "${DateFormat.yMMMEd().format(startDate)} - ${DateFormat.yMMMEd().format(endDate)} ";
    return formattedDateString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.plainWhite,
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => log.w("Tapped card"),
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.blue.shade400),
                shape: BoxShape.circle,
                color: AppColors.blueGray,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    staffData.image ??
                        dummyAvatarUrl(staffData.image ?? 'male'),
                  ),
                ),
              ),
            ),
            title: Text(
              staffData.fullName ?? '',
              style: AppStyles.regularStringStyle(16, AppColors.fullBlack),
            ),
            subtitle: Text(
              staffData.department ?? '',
              style: AppStyles.hintStringStyle(13),
            ),
            trailing: staffData.offPeriod?.start == null
                ? Text(
                    "Duty Unknown",
                    style: AppStyles.hintStringStyle(13),
                  )
                : onDutyOrLeave(
                    leaveStart: staffData.offPeriod!.start!,
                    leaveEnd: staffData.offPeriod!.end!,
                    currentShift: staffData.currentShift!.shift!,
                  ),
          ),
          staffData.offPeriod?.start == null &&
                  staffData.currentShift?.start == null
              ? const SizedBox.shrink()
              : Container(
                  height: 100,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  margin: const EdgeInsets.only(bottom: 15),
                  width: screenSize(context).width,
                  color: AppColors.kPrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Current shift: ",
                            style: AppStyles.subStringStyle(
                                14, AppColors.plainWhite),
                            children: [
                              TextSpan(
                                text: staffData.currentShift?.shift ?? '',
                                style: AppStyles.keyStringStyle(
                                    14, AppColors.plainWhite),
                              ),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Shift Period: ",
                            style: AppStyles.subStringStyle(
                                14, AppColors.plainWhite),
                            children: [
                              TextSpan(
                                text: formatPeriod(
                                  startDate: staffData.currentShift!.start!,
                                  endDate: staffData.currentShift!.end!,
                                ),
                                style: AppStyles.keyStringStyle(
                                    14, AppColors.plainWhite),
                              ),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Next Off Period: ",
                            style: AppStyles.subStringStyle(
                                14, AppColors.plainWhite),
                            children: [
                              TextSpan(
                                text: formatPeriod(
                                  startDate: staffData.currentShift!.start!,
                                  endDate: staffData.currentShift!.end!,
                                ),
                                style: AppStyles.keyStringStyle(
                                    14, AppColors.plainWhite),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

String dummyAvatarUrl(String gender) => gender.toLowerCase() == 'male'
    ? 'https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'
    : 'https://cityofwilliamsport.org/wp-content/uploads/2021/03/femalePlaceholder.jpg';

Text onDutyOrLeave({
  required DateTime leaveStart,
  required DateTime leaveEnd,
  required String currentShift,
}) {
  if (DateTime.now().isAfter(leaveStart) && DateTime.now().isBefore(leaveEnd)) {
    return Text(
      "On Leave",
      style: AppStyles.regularStringStyle(13, AppColors.gold),
    );
  } else {
    return Text(
      currentShift,
      style: AppStyles.regularStringStyle(
        13,
        Colors.green.shade800,
      ),
    );
  }
}
