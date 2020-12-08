import 'dart:async';

import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isStatusLoading = true.obs;
  var isAttendanceLoading = true.obs;
  var isLeaveStatusLoading = true.obs;
  var isCalendarLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Timer(Duration(seconds: 4), () {
      isStatusLoading(false);
      isAttendanceLoading(false);
      isLeaveStatusLoading(false);
      isCalendarLoading(false);
    });
  }
}
