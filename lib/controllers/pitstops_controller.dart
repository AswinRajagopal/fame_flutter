import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PitstopsController extends GetxController {
  var isLoading = true.obs;
  var res;
  ProgressDialog pr;
  final List pitsStops = [].obs;
  var todayString = (DateFormat().add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;
  var updateRes;
  var dis = 'Finding distance from site...'.obs;

  @override
  void onInit() {
    // getEmprPlan();
    updateTime();
    super.onInit();
  }

  void init() {
    print('init custom');
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat().add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation(pits) {
    currentAddress.value = 'Fetching your location...';
    dis.value = 'Finding distance from site...';
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      currentPosition = position;
      dis.value = Geolocator.distanceBetween(double.parse(pits['lat']), double.parse(pits['lng']), position.latitude, position.longitude).toStringAsFixed(2) + ' meter';
      // print('dis: ${dis.value}');
      getAddressFromLatLng();
      // ignore: unnecessary_lambdas
    }).catchError((e) {
      print(e);
    });
  }

  void getAddressFromLatLng() async {
    try {
      var placemark = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      var first = placemark.first;
      // print(first);
      currentAddress.value = '${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
      // print(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<bool> uploadImage(File imageFile) async {
    try {
      await pr.show();
      updateRes = await RemoteServices().checkinProcess(imageFile);
      if (updateRes != null) {
        await pr.hide();
        print('updateRes valid: ${updateRes.success}');
        if (updateRes.success) {
          var resDecode = jsonDecode(updateRes.response);
          if (!resDecode['face_found']) {
            Get.snackbar(
              null,
              'Face not detected. Please take a picture again',
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
            return false;
          } else if (resDecode['n_faces'] > 1) {
            Get.snackbar(
              null,
              'More then one face detected.',
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
            return false;
          } else if (resDecode['0']['clientID'].toString().toLowerCase() != RemoteServices().box.get('empid').toString().toLowerCase()) {
            Get.snackbar(
              null,
              "Face doesn't match.",
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
            return false;
          } else {
            return true;
          }
        } else {
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
          return false;
        }
      }
    } catch (e) {
      print(e);
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
      return false;
    } finally {
      await pr.hide();
      // return checkinResponse.success;
    }
  }

  void getPitstops(planId, companyId) async {
    try {
      isLoading(true);
      await pr.show();
      res = await RemoteServices().getPitstops(planId, companyId);
      if (res != null) {
        if (res['success']) {
          pitsStops.clear();
          for (var i = 0; i < res['pitstopList'].length; i++) {
            var pitstop = res['pitstopList'][i];
            pitstop['clientId'] = pitstop['clientId'] == null || pitstop['clientId'] == '' ? '' : pitstop['clientId'].toString();
            pitstop['clientName'] = pitstop['clientName'] == null || pitstop['clientName'] == '' ? 'N/A' : pitstop['clientName'].toString();
            if (pitstop['lat'] == null || pitstop['lat'] == '' || pitstop['lng'] == null || pitstop['lng'] == '') {
              pitstop['address'] = 'N/A';
            } else {
              var placemark = await placemarkFromCoordinates(
                double.parse(pitstop['lat']),
                double.parse(pitstop['lng']),
              );
              var first = placemark.first;
              // print(first);
              var address = '${first.street}, ${first.thoroughfare}, ${first.subLocality}, ${first.locality}, ${first.administrativeArea}, ${first.postalCode}, ${first.country}';
              pitstop['address'] = address;
            }
            pitsStops.add(pitstop);
          }
          // print(pitsStops);
          isLoading(false);
          await pr.hide();
        } else {
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
