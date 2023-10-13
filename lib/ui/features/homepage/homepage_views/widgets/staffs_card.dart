import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/app_constants/app_styles.dart';

class StaffCard extends StatelessWidget {
  const StaffCard({super.key, required this.staffData});

  final StaffAccountModel staffData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                staffData.image ?? dummyAvatarUrl(staffData.image ?? 'male'),
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
          style: AppStyles.hintStringStyle(16),
        ),
        trailing: Text(
          onDutyOrLeave(
            leaveStart: staffData.offPeriod!.start!,
            leaveEnd: staffData.offPeriod!.end!,
          ),
          style: AppStyles.hintStringStyle(16),
        ),
      ),
    );
  }
}

String dummyAvatarUrl(String gender) => gender.toLowerCase() == 'male'
    ? 'https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'
    : 'https://cityofwilliamsport.org/wp-content/uploads/2021/03/femalePlaceholder.jpg';

String onDutyOrLeave(
    {required DateTime leaveStart, required DateTime leaveEnd}) {
  if (DateTime.now().isAfter(leaveStart) && DateTime.now().isBefore(leaveEnd)) {
    return "On Leave";
  } else {
    return "On Duty";
  }
}
