// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/homepage/homepage_model/feed_model.dart';

var log = getLogger('HomepageController');

class HomepageController extends GetxController {
  bool doneLoading = false;

  List<FeedModel> feedData = [
    // sampleFeedData2,
    // sampleFeedData3,
    // sampleFeedData0,
    // sampleFeedData1,
    // sampleFeedData4
  ];

  getFeeds() async {
    log.w("getting feeds");
    await refreshFeeds();
    update();
  }

  /// Format date string to datetime format
  String formatToDateTime(String dateString) {
    DateTime tempDate =
        DateFormat("EEE, MMM d, yyyy hh:mm aaa").parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);
    print('formattedDate = $formattedDate');
    return formattedDate;
  }

  Future<void> refreshFeeds() async {
    final toponysFeedsRef = FirebaseDatabase.instance.ref("toponym_data");

    toponysFeedsRef.onChildAdded.listen(
      (event) {
        FeedModel toponysFeed =
            feedModelFromJson(jsonEncode(event.snapshot.value).toString());
        feedData.add(toponysFeed);

        if (feedData.length > 1) {
          feedData.sort((a, b) => formatToDateTime(b.dateCreated)
              .compareTo(formatToDateTime(a.dateCreated)));

          doneLoading = true;
          update();
        }

        log.wtf("returned feeds: ${toponysFeed.toJson()}");
        log.d("Going again");
      },
    );
  }
}
