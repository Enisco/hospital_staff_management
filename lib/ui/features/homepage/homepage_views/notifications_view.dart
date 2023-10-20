import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_controller/homepage_controller.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_views/widgets/notification_card.dart';
import 'package:hospital_staff_management/ui/shared/custom_appbar.dart';
import 'package:hospital_staff_management/utils/app_constants/app_colors.dart';
import 'package:hospital_staff_management/utils/screen_util/screen_util.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final _controller = Get.put(HomepageController());

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
    return GetBuilder<HomepageController>(
        init: _controller,
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            extendBodyBehindAppBar: false,
            appBar: PreferredSize(
              preferredSize: Size(screenSize(context).width, 60),
              child: const CustomAppbar(
                title: "Notifications",
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
                      itemCount: _controller.notificationsData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NotificationCard(
                          notificationData:
                              _controller.notificationsData[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
