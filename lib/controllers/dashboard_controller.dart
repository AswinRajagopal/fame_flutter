import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../connection/remote_services.dart';
import '../models/login.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;
  var isDashboardLoading = true.obs;
  List dashboardList=[].obs;
  List empDetailsList=[].obs;
  ProgressDialog pr;
  var response;
  var newBroadcast;
  var todayString = (DateFormat.E().format(DateTime.now()).toString() + ' ' + DateFormat.d().format(DateTime.now()).toString() + ' ' + DateFormat.MMM().format(DateTime.now()).toString() + ', ' + DateFormat('h:mm').format(DateTime.now()).toString() + '' + DateFormat('a').format(DateTime.now()).toString().toLowerCase()).obs;
  var greetings = '...'.obs;
  bool isDisposed = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettings;
  var initializationSettingsAndroid;
  var initializationSettingsIOS;

  @override
  void onInit() async {
    print('dbc onInit');
    super.onInit();
  }

  void init({context}) {
    // if (isDisposed) return;
    print('init custom');
    getDashboardDetails(context: context);
    updateTime();
    setupNotification();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  void setupNotification() {
    // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //       alert: true,
    //       badge: true,
    //       sound: true,
    //     );
    initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );
    initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      todayString.value = DateFormat.E().format(DateTime.now()).toString() + ' ' + DateFormat.d().format(DateTime.now()).toString() + ' ' + DateFormat.MMM().format(DateTime.now()).toString() + ', ' + DateFormat('h:mm').format(DateTime.now()).toString() + '' + DateFormat('a').format(DateTime.now()).toString().toLowerCase();

      var hour = DateTime.now().hour;
      if (hour < 12) {
        greetings.value = 'Morning';
      } else if (hour < 17) {
        greetings.value = 'Afternoon';
      } else {
        greetings.value = 'Evening';
      }
    });
  }

  String convertTimeWithParse(time) {
    return DateFormat('h:mm').format(DateFormat('HH:mm:ss').parse(time)).toString() + DateFormat('a').format(DateFormat('HH:mm:ss').parse(time)).toString().toLowerCase();
  }

  Future<void> scheduleNotification(type, time, addTime) async {
    print('type: $type');
    var todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var reminderDate = DateTime.parse('$todayDate $time');
    var currentDate = DateTime.now();
    if (currentDate.isAfter(reminderDate)) {
      todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))).toString();
    }
    var body = '';
    var scheduleNotificationDateTime = DateTime.parse('$todayDate $time').add(Duration(minutes: addTime));
    await cancelNotification();
    if (type == 'setupcheckout') {
      // Reminder for checkout
      body = "Hey ${RemoteServices().box.get('empName')}, your shift ended at ${convertTimeWithParse(time)}. Seems you haven't checked out yet. Please checkout";
    } else {
      // Reminder for checkin
      body = "Hey ${RemoteServices().box.get('empName')}, your shift time is ${convertTimeWithParse(time)}. Seems you haven't checked in yet. Please check-in to FaME to avoid Late Check In";
    }
    print('scheduleNotificationDateTime: $scheduleNotificationDateTime');
    var androidChannelSpecifics = AndroidNotificationDetails(
      'FaME',
      'FaME Channel',
      'Send notification for checkin and checkout',
      enableLights: true,
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      iosChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'FaME',
      body,
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: type,
    );
  }

  void getDashboardDetails({context}) async {
    try {
      isDashboardLoading(true);
      response = await RemoteServices().getDbDetails();
      // print('response: $response');
      if (response != null) {
        newBroadcast=response['newBroadcastMsg'];
        if (response['success']) {
          if (response['dailyAttendance'] != null) {
            await RemoteServices().box.put('shift', response['dailyAttendance']['shift']);
            await RemoteServices().box.put('clientId', response['dailyAttendance']['clientId']);
          } else {
            await RemoteServices().box.put('shift', response['empdetails']['shift']);
            await RemoteServices().box.put('clientId', response['clientData']['id']);
          }
          await RemoteServices().box.put('empName', response['empdetails']['name']);
          await RemoteServices().box.put('gender', response['empdetails']['gender']);
          if (response['empdetails']['reportView'] != null) {
            await RemoteServices().box.put('reportView', response['empdetails']['reportView']);
          } else {
            await RemoteServices().box.put('reportView', true);
          }
          await RemoteServices().box.put('faceApi', response['clientData']['faceApi']);
          await RemoteServices().box.delete('appFeature');
          print(response['appFeature']);
          await RemoteServices().box.put('appFeature', jsonEncode(AppFeature.fromJson(response['appFeature'])));
          await RemoteServices().box.put('clientLat', response['clientData']['latitude']);
          await RemoteServices().box.put('clientLng', response['clientData']['longitude']);
          await RemoteServices().box.put('maxDist', response['clientData']['maxCheckinDistance']);
          if (response['empdetails']['empStatus'] != 1 || response['companyActive'] != true) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text('Error'),
                  content: Text(
                    'Your account is de-active. Please contact your Admin',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        RemoteServices().logout();
                      },
                      child: Text('OKAY'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            isDashboardLoading(false);
            /*if (Platform.isAndroid) {
              var methodChannel = MethodChannel('in.androidfame.attendance');
              var result = await methodChannel.invokeMethod('startService',
                  {"empId":RemoteServices().box.get('empid'),
                    // "trackingInterval":RemoteServices().box.get('appFeature')['trackingInterval'],
                    "companyId":RemoteServices().box.get('companyid')});
              print('result: $result');
            }*/
            var dA = response['dailyAttendance'];
            if (response['empdetails']['gpsTracking'] != null && response['empdetails']['gpsTracking'] == true && RemoteServices().box.get('role') != '3') {
              if (dA != null && (dA['checkInDateTime'] != null && dA['checkInDateTime'] != '') && (dA['checkOutDateTime'] == null || dA['checkOutDateTime'] == '')) {
                print('tracking');
                await RemoteServices().box.put('gpsTracking', response['empdetails']['gpsTracking']);
                // RemoteServices().saveLocationLog();
                /* await Geolocator.getPositionStream(
                  desiredAccuracy: LocationAccuracy.bestForNavigation,
                ).listen((Position position) async {});*/
                if (Platform.isAndroid) {
                  var methodChannel = MethodChannel('in.androidfame.attendance');
                  var result = await methodChannel.invokeMethod('startService', {'empId': RemoteServices().box.get('empid'), 'companyId': RemoteServices().box.get('companyid')});
                  print('result: $result');
                } else if (Platform.isIOS) {
                  // await LocationUpdates.initiateLocationUpdates(Get.context);
                }
              } else {
                print('not tracking');
                // await RemoteServices().saveLocationLog(cancel: true);
                // if (Platform.isAndroid) {
                //   var methodChannel = MethodChannel('in.androidfame.attendance');
                //   var result = await methodChannel.invokeMethod('startService');
                //   print('result: $result');
                // }
              }
            }

            if (jsonDecode(RemoteServices().box.get('appFeature'))['checkoutDial'] != null && jsonDecode(RemoteServices().box.get('appFeature'))['checkoutDial'] && RemoteServices().box.get('role') != '3') {
              if (dA != null && (dA['checkInDateTime'] != null && dA['checkInDateTime'] != '') && (dA['checkOutDateTime'] == null || dA['checkOutDateTime'] == '')) {
                // checked in
                await scheduleNotification('setupcheckout', response['empdetails']['shiftEndTime'], jsonDecode(RemoteServices().box.get('appFeature'))['checkoutDialTime'] ?? 30);
              } else {
                // checked out
                await scheduleNotification('setupcheckin', response['empdetails']['shiftStartTime'], jsonDecode(RemoteServices().box.get('appFeature'))['checkinDialTime'] ?? 15);
              }
            } else {
              await cancelNotification();
            }
          }
        } else {
          isDashboardLoading(false);
          if (response['msg'].length > 0) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text('Error'),
                      content: Text(
                        response['msg'],
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            RemoteServices().logout();
                          },
                          child: Text('OKAY'),
                        ),
                      ],
                    ),
                  ),
            );
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
      }
    } catch (e) {
      print(e);
      isDashboardLoading(false);
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

  void getDashboardList(param)async{
    try {
      isLoading(true);
      await pr.show();
      var res = await RemoteServices().getDashboardList(param);
      if (res != null) {
        isLoading(false);
        await pr.hide();
        if (res['success']) {
          if (res['dashboardLists'] != null) {
            for (var i = 0; i < res['dashboardLists'].length; i++) {
              dashboardList.add(res['dashboardLists'][i]);
            }
          }else if(param=='Employees'){
            if(res['empdetails']!=null){
              for(var i=0; i < res['empdetails'].length; i++){
                empDetailsList.add(res['empdetails'][i]);
              }
            }
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
