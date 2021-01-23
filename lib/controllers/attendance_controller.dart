import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AttendanceController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List clientList = [].obs;
  final List timings = [].obs;
  var shiftTime;
  // var selectedVal;
  var clientId;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), getClientTimings);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getClientTimings() async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getClientTimings();
      if (res != null) {
        isLoading(false);
        await pr.hide();
        // print('res valid: $res');
        if (res.success) {
          for (var i = 0; i < res.clientsandManpowerArrList.length; i++) {
            clientList.add(res.clientsandManpowerArrList[i]);
          }
          // selectedVal = json.encode(clientList.first.clientManpowerList);

          // var manpower = json.decode(selectedVal);
          // print('value: $manpower');
          // clientId = manpower.first['clientId'];
          timings.clear();
          // shiftTime = '';
          // for (var j = 0; j < manpower.length; j++) {
          // // print('manpower: ${manpower[j]}');
          // manpower[j]['shiftStartTime'] = manpower[j]['shiftStartTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftStartTime'] : manpower[j]['shiftStartTime'];
          // manpower[j]['shiftEndTime'] = manpower[j]['shiftEndTime'].split(':').first.length == 1 ? '0' + manpower[j]['shiftEndTime'] : manpower[j]['shiftEndTime'];
          // var sSTime = DateFormat('hh:mm')
          //         .format(
          //           DateTime.parse(
          //             '2020-12-20 ' + manpower[j]['shiftStartTime'],
          //           ),
          //         )
          //         .toString() +
          //     DateFormat('a')
          //         .format(
          //           DateTime.parse(
          //             '2020-12-20 ' + manpower[j]['shiftStartTime'],
          //           ),
          //         )
          //         .toString()
          //         .toLowerCase();
          // var sETime = DateFormat('hh:mm')
          //         .format(
          //           DateTime.parse(
          //             '2020-12-20 ' + manpower[j]['shiftEndTime'],
          //           ),
          //         )
          //         .toString() +
          //     DateFormat('a')
          //         .format(
          //           DateTime.parse(
          //             '2020-12-20 ' + manpower[j]['shiftEndTime'],
          //           ),
          //         )
          //         .toString()
          //         .toLowerCase();
          // var addTiming = {
          //   'shift': manpower[j]['shift'],
          //   'shiftStartTime': sSTime,
          //   'shiftEndTime': sETime,
          // };
          // print(timings.contains(addTiming));
          // if (!timings.contains(addTiming)) {
          //   timings.add(addTiming);
          // }
          // }

          // var timing = timings.first;
          // var shiftTimeCtrl = timing['shiftStartTime'] + ' - ' + timing['shiftEndTime'];
          // shiftTime = timing['shift'] + '#' + shiftTimeCtrl;

          // print('clientList: $clientList');
        } else {
          Get.snackbar(
            null,
            'Client not found',
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
            borderRadius: 5.0,
          );
        }
      }
    } catch (e) {
      print(e);
      isLoading(false);
      await pr.hide();
      Get.snackbar(
        null,
        'Something went wrong! Please try again later',
        colorText: Colors.white,
        backgroundColor: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 18.0,
        ),
        borderRadius: 5.0,
      );
    }
  }
}
