import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/locationpath.dart';
import '../connection/remote_services.dart';
import '../utils/utils.dart';

class EmployeeReportController extends GetxController {
  var isLoading = true.obs;
  var isLoadingEmpReport = true.obs;
  var isLoadingEmpDetail = true.obs;
  var isLoadingTimeline = true.obs;
  var isLoadingFromToDate=true.obs;
  var isLoadingPitstopAttach = true.obs;
  var isLoadingLocation = true.obs;
  var isLoadingShortage = true.obs;
  var isLoadingDaily = true.obs;
  var isLoadingAtt = true.obs;
  var res;
  ProgressDialog pr;
  final List clientList = [].obs;
  final List timings = [].obs;
  var shiftTime;
  final List shift = [].obs;
  final List searchList = [].obs;
  final List designation = [].obs;
  final List onboardEmp = [].obs;
  final List locations = [].obs;
  final List dailySearch = [].obs;
  final List clientReport = [].obs;
  final List shortageReport = [].obs;
  var reportType = 'name';
  var getEmpReportRes;
  var getEmpOnboardRes;
  var getEmpDetailRes;
  var getEmpDetailRepRes;
  var getClientRepRes;
  var getPitstopAttachment;
  var getTimelineRes;
  var getPitstopByFromToDateRes;
  var getLocationRes;
  var shortageRes;
  var oB = AppUtils.NAME;
  final List pitsStops = [].obs;
  final List datePitsStop=[].obs;
  final List pitsStopsRoute = [].obs;
  double totalDistance = 0;
  var added = 0, approved = 0, rejected = 0, pending = 0;

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

  void getClientTimingsShortage() async {
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

  void getClient() async {
    clientList.clear();
    try {
      isLoading(true);
      await pr.show();
      var getClientRes = await RemoteServices().getMyClients();
      if (getClientRes != null) {
        await pr.hide();
        isLoading(false);
        // print('getClientRes valid: $getClientRes');
        if (getClientRes['success']) {
          print(clientList);
          for (var i = 0; i < getClientRes['clientsList'].length; i++) {
            clientList.add(getClientRes['clientsList'][i]);
          }
          // print('clientsList: $clientList');
        } else {
          // Get.snackbar(
          //   null,
          //   'Client not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
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

  void getEmpReport(clientId, orderBy) async {
    isLoadingEmpReport(true);
    try {
      await pr.show();
      getEmpReportRes = await RemoteServices().getEmpReport(clientId, orderBy);
      if (getEmpReportRes != null) {
        await pr.hide();
        isLoadingEmpReport(false);
        // print('getEmpReportRes valid: $getEmpReportRes');
        if (getEmpReportRes['success']) {
          print('getEmpReportRes: $getEmpReportRes');
          designation.addAll(getEmpReportRes['designationsList']);
          // for (var i = 0; i < getEmpReportRes['designationsList'].length; i++) {
          //   designation.insert(
          //     int.parse(getEmpReportRes['designationsList'][i]['designId']),
          //     getEmpReportRes['designationsList'][i]['design'],
          //   );
          // }
        } else {
          // Get.snackbar(
          //   null,
          //   'Report not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoadingEmpReport(false);
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

  void getOnboardEmp(clientId, orderBy) async {
    isLoadingEmpReport(true);
    try {
      await pr.show();
      getEmpReportRes =
          await RemoteServices().getOnboardEmpList(clientId, orderBy);
      if (getEmpReportRes != null) {
        await pr.hide();
        isLoadingEmpReport(false);
        // print('getEmpReportRes valid: $getEmpReportRes');
        if (getEmpReportRes['success']) {
          added = getEmpReportRes['empList'].length;
          for (int i = 0; i < added; i++) {
            if (getEmpReportRes['empList'][i]['empstatus'] == '2') {
              rejected++;
            } else if (getEmpReportRes['empList'][i]['empstatus'] == '0') {
              pending++;
            }
          }
          approved = added - rejected - pending;
        }
      }
    } catch (e) {
      print(e);
      isLoadingEmpReport(false);
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

  void getEmpDetail(empId) async {
    isLoadingEmpDetail(true);
    try {
      await pr.show();
      getEmpDetailRes = await RemoteServices().getEmpDetailsReport(empId);
      if (getEmpDetailRes != null) {
        await pr.hide();
        isLoadingEmpDetail(false);
        if (getEmpDetailRes['success']) {
        } else {
          Get.snackbar(
            null,
            'Employee not found',
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
      isLoadingEmpDetail(false);
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

  void getTimelineReport(empId, searchDate, {type}) async {
    isLoadingTimeline(true);
    pitsStops.clear();
    try {
      await pr.show();
      getTimelineRes = await RemoteServices()
          .getTimelineReport(empId, searchDate, type: type);
      if (getTimelineRes != null) {
        if (getTimelineRes['success']) {
          print('getTimelineRes: $getTimelineRes');
          // print('type: $type');
          if (type != null && type == 'visit') {
            for (var i = 0; i < getTimelineRes['pitstopList'].length; i++) {
              var pitstop = getTimelineRes['pitstopList'][i];
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
              pitsStops.add(pitstop);
            }
          } else {
            for (var i = 0; i < getTimelineRes['empTimelineList'].length; i++) {
              var pitstop = getTimelineRes['empTimelineList'][i];
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
              pitsStops.add(pitstop);
            }
            // pitsStops.sort((a,b)=> DateTime.parse(b['timeStamp']).isAfter(DateTime.parse(b['timeStamp']))?1:-1);
          }
          isLoadingTimeline(false);
          await pr.hide();
        } else {
          isLoadingTimeline(false);
          await pr.hide();
        }
      }
    } catch (e) {
      print(e);
      isLoadingTimeline(false);
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

  void getPitstopByFromToDate(empId, fromDate, toDate) async {
    isLoadingFromToDate(true);
    datePitsStop.clear();
    try {
      await pr.show();
      getPitstopByFromToDateRes= await RemoteServices()
          .getPitstopByFromToDate(empId, fromDate, toDate);
      if (getPitstopByFromToDateRes != null) {
        if (getPitstopByFromToDateRes['success']) {
          print('getpitstopfromdatetodateres: $getPitstopByFromToDateRes');
          if (getPitstopByFromToDateRes != null) {
            for (var i = 0; i < getPitstopByFromToDateRes['pitstopList'].length; i++) {
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
            }
          } else {
            for (var i = 0; i < getPitstopByFromToDateRes['empTimelineList'].length; i++) {
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

  Future getPitstopAtt(pitstopId) async {
    // isLoadingTimeline(true);
    pitsStops.clear();
    try {
      await pr.show();
      getPitstopAttachment = await RemoteServices().getPitstopAttch(pitstopId);
      if (getPitstopAttachment != null) {
        if (getPitstopAttachment['success']) {
          print("pitstop : " + getPitstopAttachment);
          return getPitstopAttachment;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void getVisitPlanRoute(empId, searchDate, {type}) async {
    isLoadingTimeline(true);
    pitsStopsRoute.clear();
    totalDistance = 0;
    try {
      await pr.show();
      getTimelineRes = await RemoteServices()
          .getTimelineReport(empId, searchDate, type: type);
      if (getTimelineRes != null) {
        if (getTimelineRes['success']) {
          print('getTimelineRes: $getTimelineRes');
          // print('type: $type');
          if (type != null && type == 'timeline') {
            for (var i = 0; i < getTimelineRes['empTimelineList'].length; i++) {
              var pitstop = getTimelineRes['empTimelineList'][i];
              pitstop['pitstopId'] = pitstop['emptlnId'];
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
                pitstop['checkinLat'] = '';
                pitstop['checkinLng'] = '';
              } else if (pitstop['address'] == null ||
                  pitstop['address'].toString().length == 0) {
                pitstop['checkinLat'] = pitstop['lat'];
                pitstop['checkinLng'] = pitstop['lng'];
                var placemark = await placemarkFromCoordinates(
                  double.parse(pitstop['lat']),
                  double.parse(pitstop['lng']),
                );
                var first = placemark.first;
                // print(first);
                var address =
                    '${first.street}, ${first.thoroughfare}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}';
                if (address.isNullOrBlank) {
                  pitstop['address'] = address;
                } else {
                  pitstop['address'] = address;
                }
              }
              pitsStopsRoute.add(pitstop);
            }
            for (var d = 0; d < pitsStopsRoute.length - 1; d++) {
              totalDistance += await Locationpath().getDistance(
                LatLng(double.parse(pitsStopsRoute[d]['lat']),
                    double.parse(pitsStopsRoute[d]['lng'])),
                LatLng(double.parse(pitsStopsRoute[d + 1]['lat']),
                    double.parse(pitsStopsRoute[d + 1]['lng'])),
              );
            }
            isLoadingTimeline(false);
            await pr.hide();
          } else {
            for (var i = 0; i < getTimelineRes['pitstopList'].length; i++) {
              var pitstop = getTimelineRes['pitstopList'][i];
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
                var placemark = await placemarkFromCoordinates(
                  double.parse(pitstop['checkinLat']),
                  double.parse(pitstop['checkinLng']),
                );
                var first = placemark.first;
                // print(first);
                var address =
                    '${first.street}, ${first.thoroughfare}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}';
                pitstop['address'] = address;
              }
              pitsStopsRoute.add(pitstop);
            }
            for (var d = 0; d < pitsStopsRoute.length - 1; d++) {
              totalDistance += await Locationpath().getDistance(
                LatLng(double.parse(pitsStopsRoute[d]['checkinLat']),
                    double.parse(pitsStopsRoute[d]['checkinLng'])),
                LatLng(double.parse(pitsStopsRoute[d + 1]['checkinLat']),
                    double.parse(pitsStopsRoute[d + 1]['checkinLng'])),
              );
            }
            isLoadingTimeline(false);
            await pr.hide();
          }
        } else {
          isLoadingTimeline(false);
          await pr.hide();
          // Get.snackbar(
          //   null,
          //   'Timeline report not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoadingTimeline(false);
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

  void getLocationReport(empId) async {
    isLoadingLocation(true);
    locations.clear();
    try {
      await pr.show();
      getLocationRes = await RemoteServices().getLocationReport(empId);
      if (getLocationRes != null) {
        print('getEmpReportRes valid: $getEmpReportRes');
        if (getLocationRes['success']) {
          print('getLocationRes: $getLocationRes');
          for (var i = 0; i < getLocationRes['empDetailsTlnList'].length; i++) {
            var location = getLocationRes['empDetailsTlnList'][i];
            var date = location['timeStamp'];

            location['datetime'] = DateFormat('dd-MM-yyyy hh:mm')
                    .format(DateTime.parse(date))
                    .toString() +
                '' +
                DateFormat('a')
                    .format(DateTime.parse(date))
                    .toString()
                    .toLowerCase();
            locations.add(location);
          }
          isLoadingLocation(false);
          await pr.hide();
        } else {
          isLoadingLocation(false);
          await pr.hide();
          // Get.snackbar(
          //   null,
          //   'Location report not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoadingLocation(false);
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

  void getDailyEmployeeReport(empId, fdate, tdate, orderBy) async {
    isLoadingDaily(true);
    dailySearch.clear();
    try {
      await pr.show();
      getEmpDetailRepRes = await RemoteServices()
          .getDailyEmployeeReport(empId, fdate, tdate, orderBy);
      if (getEmpDetailRepRes != null) {
        // print('getEmpReportRes valid: $getEmpReportRes');
        if (getEmpDetailRepRes['success']) {
          print('getEmpDetailRepRes: $getEmpDetailRepRes');
          for (var i = 0;
              i < getEmpDetailRepRes['empDailyAttView'].length;
              i++) {
            var daily = getEmpDetailRepRes['empDailyAttView'][i];
            var chkIn = daily['checkInDateTime'];
            var chkout = daily['checkOutDateTime'];

            if (chkIn == null ||
                chkout == null ||
                chkIn == '' ||
                chkout == '') {
              if (chkIn != null && chkIn != '') {
                daily['date'] = DateFormat('dd')
                        .format(DateTime.parse(chkIn))
                        .toString() +
                    ' ' +
                    DateFormat.MMM().format(DateTime.parse(chkIn)).toString() +
                    ' ' +
                    DateFormat.y().format(DateTime.parse(chkIn)).toString();
                daily['time'] = DateFormat('hh:mm')
                        .format(DateTime.parse(chkIn))
                        .toString() +
                    '' +
                    DateFormat('a')
                        .format(DateTime.parse(chkIn))
                        .toString()
                        .toLowerCase();
              } else {
                daily['date'] = 'N/A';
                daily['time'] = 'N/A';
              }
            } else {
              daily['date'] = DateFormat('dd')
                      .format(DateTime.parse(chkIn))
                      .toString() +
                  ' ' +
                  DateFormat.MMM().format(DateTime.parse(chkIn)).toString() +
                  ' ' +
                  DateFormat.y().format(DateTime.parse(chkIn)).toString();
              daily['time'] =
                  DateFormat('hh:mm').format(DateTime.parse(chkIn)).toString() +
                      '' +
                      DateFormat('a')
                          .format(DateTime.parse(chkIn))
                          .toString()
                          .toLowerCase() +
                      ' to ' +
                      DateFormat('hh:mm')
                          .format(DateTime.parse(chkout))
                          .toString() +
                      '' +
                      DateFormat('a')
                          .format(DateTime.parse(chkout))
                          .toString()
                          .toLowerCase();
            }

            dailySearch.add(daily);
          }
          isLoadingDaily(false);
          await pr.hide();
        } else {
          isLoadingDaily(false);
          await pr.hide();
          // Get.snackbar(
          //   null,
          //   'Daily employee report not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoadingDaily(false);
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

  void getClientReport(clientId, date, shift, orderBy) async {
    isLoadingAtt(true);
    clientReport.clear();
    try {
      await pr.show();
      getClientRepRes = await RemoteServices()
          .getClientReport(clientId, date, shift, orderBy);
      if (getClientRepRes != null) {
        // print('getEmpReportRes valid: $getEmpReportRes');
        if (getClientRepRes['success']) {
          print('getClientRepRes: $getClientRepRes');
          designation.addAll(getClientRepRes['designationsList']);
          // for (var i = 0; i < getClientRepRes['designationsList'].length; i++) {
          //   designation.insert(
          //     int.parse(getClientRepRes['designationsList'][i]['designId']),
          //     getClientRepRes['designationsList'][i]['design'],
          //   );
          // }
          for (var i = 0; i < getClientRepRes['empDailyAttView'].length; i++) {
            var client = getClientRepRes['empDailyAttView'][i];
            var chkIn = client['checkInDateTime'];
            var chkout = client['checkOutDateTime'];

            if (chkIn == null ||
                chkout == null ||
                chkIn == '' ||
                chkout == '') {
              if (chkIn != null && chkIn != '') {
                client['showtime'] = DateFormat('hh:mm')
                        .format(DateTime.parse(chkIn))
                        .toString() +
                    '' +
                    DateFormat('a')
                        .format(DateTime.parse(chkIn))
                        .toString()
                        .toLowerCase();
              } else {
                client['showtime'] = 'N/A';
              }
            } else {
              client['showtime'] =
                  DateFormat('hh:mm').format(DateTime.parse(chkIn)).toString() +
                      '' +
                      DateFormat('a')
                          .format(DateTime.parse(chkIn))
                          .toString()
                          .toLowerCase() +
                      ' to ' +
                      DateFormat('hh:mm')
                          .format(DateTime.parse(chkout))
                          .toString() +
                      '' +
                      DateFormat('a')
                          .format(DateTime.parse(chkout))
                          .toString()
                          .toLowerCase();
            }

            clientReport.add(client);
          }
          isLoadingAtt(false);
          await pr.hide();
        } else {
          isLoadingAtt(false);
          await pr.hide();
          // Get.snackbar(
          //   null,
          //   'Client report not found',
          //   colorText: Colors.white,
          //   backgroundColor: Colors.black87,
          //   snackPosition: SnackPosition.BOTTOM,
          //   margin: EdgeInsets.symmetric(
          //     horizontal: 8.0,
          //     vertical: 10.0,
          //   ),
          // );
        }
      }
    } catch (e) {
      print(e);
      isLoadingAtt(false);
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

  void getShortageReport(clientId, date, shift) async {
    isLoadingShortage(true);
    shortageReport.clear();
    try {
      await pr.show();
      shortageRes =
          await RemoteServices().getShortageReport(clientId, date, shift);
      if (shortageRes != null) {
        // print('getEmpReportRes valid: $getEmpReportRes');
        isLoadingShortage(false);
        await pr.hide();
      }
    } catch (e) {
      print(e);
      isLoadingShortage(false);
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
