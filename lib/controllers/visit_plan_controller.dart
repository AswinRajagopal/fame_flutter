import 'package:fame/connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class VisitPlanController extends GetxController {
  var isLoadingFromToDate = true.obs;
  var getPitstopByFromToDateRes;

  ProgressDialog pr;
  final List datePitsStop = [].obs;

  void getPitstopByFromToDate(empId, fromDate, toDate) async {
    isLoadingFromToDate(true);
    datePitsStop.clear();
    try {
      await pr.show();
      getPitstopByFromToDateRes = await RemoteServices()
          .getPitstopByFromToDate(empId, fromDate, toDate);
      if (getPitstopByFromToDateRes != null) {
        if (getPitstopByFromToDateRes['success']) {
          print('getpitstopfromdatetodateres: $getPitstopByFromToDateRes');
          if (getPitstopByFromToDateRes != null) {
            for (var i = 0;
                i < getPitstopByFromToDateRes['pitstopList'].length;
                i++) {
              var pitstop = getPitstopByFromToDateRes['pitstopList'][i];
              var date = pitstop['updatedOn'];
              pitstop['datetime'] = DateFormat('dd')
                      .format(DateTime.parse(date))
                      .toString() +
                  '-' +
                  DateFormat('MM').format(DateTime.parse(date)).toString() +
                  '-' +
                  DateFormat.y().format(DateTime.parse(date)).toString() +
                  ', ' +
                  DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
                  '' +
                  DateFormat('a')
                      .format(DateTime.parse(date))
                      .toString()
                      .toLowerCase();
              if (pitstop['checkinLat'] == null ||
                  pitstop['checkinLat'] == '' ||
                  pitstop['checkinLng'] == null ||
                  pitstop['checkinLng'] == '') {
                pitstop['address'] = 'N/A';
              } else if (pitstop['address'] == null ||
                  pitstop['address'].toString().length == 0) {
                try {
                  var placemark = await placemarkFromCoordinates(
                    double.parse(pitstop['checkinLat']),
                    double.parse(pitstop['checkinLng']),
                  );
                  var first = placemark.first;
                  // print(first);

                  var address =
                      '${first.street}, ${first.thoroughfare}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}';
                  pitstop['address'] = address;
                } on Exception catch (_) {
                  var address = await new RemoteServices().getAddressFromLatLng(
                      double.parse(pitstop['checkinLat']),
                      double.parse(pitstop['checkinLng']));
                  pitstop['address'] = address;
                }
              }
              datePitsStop.add(pitstop);
              datePitsStop.sort((a,b)=>
              (DateTime.parse(a['updatedOn']).isAfter( DateTime.parse(b['updatedOn'])))?0:1);
            }
          }
          else {
            for (var i = 0;
                i < getPitstopByFromToDateRes['empTimelineList'].length;
                i++) {
              var pitstop = getPitstopByFromToDateRes['empTimelineList'][i];
              var date = pitstop['timeStamp'];

              pitstop['datetime'] = DateFormat('dd')
                      .format(DateTime.parse(date))
                      .toString() +
                  '-' +
                  DateFormat('MM').format(DateTime.parse(date)).toString() +
                  '-' +
                  DateFormat.y().format(DateTime.parse(date)).toString() +
                  ', ' +
                  DateFormat('hh:mm').format(DateTime.parse(date)).toString() +
                  '' +
                  DateFormat('a')
                      .format(DateTime.parse(date))
                      .toString()
                      .toLowerCase();
              if (pitstop['lat'] == null ||
                  pitstop['lat'] == '' ||
                  pitstop['lng'] == null ||
                  pitstop['lng'] == '') {
                pitstop['address'] = 'N/A';
              } else if (pitstop['address'] == null ||
                  pitstop['address'].toString().length == 0) {
                try {
                  var placemark = await placemarkFromCoordinates(
                    double.parse(pitstop['lat']),
                    double.parse(pitstop['lng']),
                  );
                  var first = placemark.first;
                  // print(first);
                  var address =
                      '${first.street}, ${first.thoroughfare}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}';
                  pitstop['address'] = address;
                } on Exception catch (_) {
                  var address = await new RemoteServices().getAddressFromLatLng(
                      double.parse(pitstop['lat']),
                      double.parse(pitstop['lng']));
                  pitstop['address'] = address;
                }
              }
              datePitsStop.add(pitstop);
            }
            // pitsStops.sort((a,b)=> DateTime.parse(b['timeStamp']).isAfter(DateTime.parse(b['timeStamp']))?1:-1);
          }
          isLoadingFromToDate(false);
          await pr.hide();
        } else {
          isLoadingFromToDate(false);
          await pr.hide();
        }
      }
    } catch (e) {
      print(e);
      isLoadingFromToDate(false);
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
