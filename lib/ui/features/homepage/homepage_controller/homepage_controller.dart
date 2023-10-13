// ignore_for_file: avoid_print

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hospital_staff_management/app/resources/app.logger.dart';
import 'package:hospital_staff_management/ui/features/create_account/create_account_model/staff_account_model.dart';

var log = getLogger('HomepageController');

class HomepageController extends GetxController {
  bool doneLoading = false;
  List<StaffAccountModel> staffsData = [];
  StaffAccountModel? myData;

  getAllStaffsData() {}

  getMyData() {}
}
