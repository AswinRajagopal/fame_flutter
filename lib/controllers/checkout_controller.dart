import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fame/utils/utils.dart';
import 'package:flutter_svg/svg.dart';

import '../connection/locationpath.dart';
import '../views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';

class CheckoutController extends GetxController {
  ProgressDialog pr;
  var checkoutResponse;
  var checkOutAlias;
  var todayString =
      (DateFormat('dd-MM-yy').add_jm().format(DateTime.now()).toString()).obs;
  Position currentPosition;
  var currentAddress = 'Fetching your location...'.obs;

  @override
  void onInit() {
    updateTime();
    print(
        'locationFetchTimeout: ${jsonDecode(RemoteServices().box.get('appFeature'))}');
    if (jsonDecode(RemoteServices().box.get('appFeature'))['locFetchTimeout'])
      latlngTimeout();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value =
          DateFormat('dd-MM-yy').add_jm().format(DateTime.now()).toString();
    });
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      currentPosition = position;
      getAddressFromLatLng();
      // ignore: unnecessary_lambdas
    }).catchError((e) {
      print(e);
    });
  }

  Future latlngTimeout() {
    new Timer(
        const Duration(seconds: 10),
        () => (currentAddress.value == 'Fetching your location...')
            ? currentAddress.value = 'Please checkout'
            : '');
    return null;
  }

  void getAddressFromLatLng() async {
    try {
      var placemark = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      var first;
      if (placemark != null) {
        first = placemark.first;
      }
      var maxDistance = RemoteServices().box.get('maxDist');
      var distance;
      if (maxDistance != '0') {
        distance = await Locationpath().calculateDistance(
            currentPosition.latitude,
            currentPosition.longitude,
            double.parse(RemoteServices().box.get('clientLat')),
            double.parse(RemoteServices().box.get('clientLng')));
      }
      if (maxDistance == '0' ||
          int.parse(maxDistance) > (distance * 1000).round()) {
        if (first != null) {
          currentAddress.value =
              '${first.street}, ${first.subLocality}, ${first.locality}, ${first.postalCode}, ${first.country}';
        } else {
          currentAddress.value = 'Please checkout';
        }
      } else {
        await showDialog(
          context: Get.context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Cannot Checkout'),
              content: Text(
                'Too long from Site Location ',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Get.offAll(DashboardPage());
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      }
      // print(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return
  Future<bool> uploadImage(File imageFile) async {
    try {
      await pr.show();
      checkoutResponse = await RemoteServices().checkinProcess(imageFile);
      if (checkoutResponse != null) {
        await pr.hide();
        print('checkoutResponse valid: ${checkoutResponse.success}');
        if (checkoutResponse.success) {
          var resDecode = jsonDecode(checkoutResponse.response);
          if (resDecode['msg'] == 'Please register before using.') {
            Get.snackbar(
              null,
              resDecode['msg'],
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
          } else if (!resDecode['face_found']) {
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
          } else if (resDecode['0']['clientID'].toString().toLowerCase() !=
              RemoteServices().box.get('empid').toString().toLowerCase()) {
            await showDialog(
              context: Get.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                  backgroundColor: Colors.transparent.withOpacity(0.5),
                  content: Container(
                    width: MediaQuery.of(context).size.height / 2.3,
                    height: MediaQuery.of(context).size.height / 1.0,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                    'assets/images/Back icon - 1.svg'))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/Rectangle.svg',
                                  width: 300,
                                ),
                                Positioned(
                                  top: 0.0,
                                  bottom: 110.0,
                                  left: 120.0,
                                  child: SvgPicture.asset(
                                    'assets/images/sad icon.svg',
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Positioned(
                                  top: 120.0,
                                  bottom: 24.0,
                                  left: 50.0,
                                  child: Text(
                                    'Face Doesn\'t Match \n        Try Again',
                                    style: TextStyle(
                                      color: Color(0xffbb0001),
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppUtils().greenColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  30.0,
                                ),
                              ),
                            ),
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            );
            return false;
          } else {
            var checkout = await RemoteServices().checkout(
              (currentPosition != null) ? currentPosition.latitude : '0.0',
              (currentPosition != null) ? currentPosition.longitude : '0.0',
              currentAddress.value,
            );
            if (checkout != null && checkout['success']) {
              checkOutAlias=checkout['attendanceAlias'];
              // await RemoteServices().saveLocationLog(cancel: true);
              if (Platform.isAndroid) {
                var methodChannel = MethodChannel('in.androidfame.attendance');
                var result = await methodChannel.invokeMethod('stopService');
                print('result: $result');
              } else if (Platform.isIOS) {
                // await LocationUpdates.stopLocationUpdates(Get.context);
              }
              return true;
            } else {
              var msg = 'Something went wrong! Please try again later';
              if (checkout['message'] != null) {
                msg = checkout['message'];
                showDialog(
                  context: Get.context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      msg,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Ok'),
                      )
                    ],
                  ),
                );
              } else {
                Get.snackbar(
                  null,
                  msg,
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
              return false;
            }
          }
        } else {
          await showDialog(
            context: Get.context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                backgroundColor: Colors.transparent.withOpacity(0.5),
                content: Container(
                  width: MediaQuery.of(context).size.height / 2.3,
                  height: MediaQuery.of(context).size.height / 1.0,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                  'assets/images/Back icon - 1.svg'))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Stack(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/images/Rectangle.svg',
                            width: 300,
                          ),
                          Positioned(
                            top: 0.0,
                            bottom: 110.0,
                            left: 120.0,
                            child: SvgPicture.asset(
                              'assets/images/exclamation mark icon.svg',
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Positioned(
                            top: 120.0,
                            bottom: 24.0,
                            left: 28.0,
                            child: Text(
                              'Something went wrong!\n           Try again',
                              style: TextStyle(
                                color: Color(0xffbb0001),
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppUtils().greenColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                30.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            },
          );
          return false;
        }
      }
    } catch (e) {
      print(e);
      await pr.hide();
      await showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
            backgroundColor: Colors.transparent.withOpacity(0.5),
            content: Container(
              width: MediaQuery.of(context).size.height / 2.3,
              height: MediaQuery.of(context).size.height / 1.0,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                              'assets/images/Back icon - 1.svg'))
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/images/Rectangle.svg',
                        width: 300,
                      ),
                      Positioned(
                        top: 0.0,
                        bottom: 110.0,
                        left: 120.0,
                        child: SvgPicture.asset(
                          'assets/images/exclamation mark icon.svg',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Positioned(
                        top: 120.0,
                        bottom: 24.0,
                        left: 28.0,
                        child: Text(
                          'Something went wrong!\n           Try again',
                          style: TextStyle(
                            color: Color(0xffbb0001),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 15.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppUtils().greenColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      );
      return false;
    }
  }

  Future<bool> justCheckout() async {
    await pr.show();
    var checkout = await RemoteServices().checkout(
      (currentPosition != null) ? currentPosition.latitude : '0.0',
      (currentPosition != null) ? currentPosition.longitude : '0.0',
      currentAddress.value,
    );
    // print(checkin);
    if (checkout != null && checkout['success']) {
      await pr.hide();
      var methodChannel = MethodChannel('in.androidfame.attendance');
      var result = await methodChannel.invokeMethod('stopService');
      print(result);
      return true;
    } else {
      await pr.hide();
      var msg = 'Something went wrong! Please try again later';
      if (checkout['message'] != null) {
        msg = checkout['message'];
      }
      Get.snackbar(
        null,
        msg,
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
}
