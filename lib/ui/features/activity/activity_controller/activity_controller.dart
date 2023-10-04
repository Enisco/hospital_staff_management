import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/activity/activity_model/activity_model.dart';

var log = getLogger('ActivityController');

class ActivityController extends GetxController {
  ActivityController();
  bool doneLoading = false;
  List<UserActivityModel> activityFeedData = [];

  getUserActivities() async {
    doneLoading = false;
    activityFeedData = [];
    update();

    log.w("getting users activities");
    await refreshUserActivities();
    update();
  }

  Future<void> refreshUserActivities() async {
    final activitiesFeedsRef = FirebaseDatabase.instance.ref("user_details");

    activitiesFeedsRef.onChildAdded.listen((event) {
      UserActivityModel activityFeed = userActivityModelFromJson(
          jsonEncode(event.snapshot.value).toString());

      activityFeedData.add(activityFeed);

      if (activityFeedData.length > 1) {
        activityFeedData
            .sort((a, b) => b.totalPoints!.compareTo(a.totalPoints!));
        doneLoading = true;
        update();
      }
      log.v(activityFeedData);

      log.wtf("Returned feeds: ${activityFeed.toJson()}");
      log.d("Going again");
    });
  }
}
