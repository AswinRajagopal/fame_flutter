// import 'dart:io';

// import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../connection/remote_services.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/dbcal_controller.dart';
import '../controllers/emprplan_controller.dart';
import '../utils/utils.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/custom_fab.dart';
import '../widgets/db_activity_tile.dart';
import '../widgets/db_empr_tile.dart';
import '../widgets/home_calendar.dart';
import '../widgets/loading_widget.dart';
import '../widgets/progress_indicator.dart';
import 'attendance_page.dart';
import 'checkin_page.dart';
import 'checkout_page.dart';
import 'notification.dart';
import 'pin_my_visit.dart';
import 'route_planning.dart';

class DashboardPage extends StatefulWidget {
  final String callController;

  DashboardPage({this.callController});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dbC = Get.put(DashboardController());
  final EmprplanController erpC = Get.put(EmprplanController());
  final DBCalController calC = Get.put(DBCalController());
  var liteMode = false;

  @override
  void initState() {
    super.initState();
    callBg();
    liteMode = RemoteServices().box.get('lite');
    Future.delayed(Duration(milliseconds: 100), () {
      dbC.init(context: context);
    });
    if (liteMode !=null && !liteMode) {
      Future.delayed(Duration(milliseconds: 100), () {
        erpC.init(fromWhere: 'db');
      });
      calC.calendarType = 'myCal';
      Future.delayed(Duration(milliseconds: 100), calC.init);
    }
  }

  void callBg() async {
    print('callBg()');
    // RemoteServices().saveLocationLogNew();
    // if (Platform.isAndroid) {
    //   var methodChannel = MethodChannel('in.androidfame.attendance');
    //   var result = await methodChannel.invokeMethod('startService');
    //   print('result: $result');
    // }
  }

  String convertTimeWithParse(time) {
    return DateFormat('h:mm')
            .format(DateFormat('HH:mm:ss').parse(time))
            .toString() +
        DateFormat('a')
            .format(DateFormat('HH:mm:ss').parse(time))
            .toString()
            .toLowerCase();
  }

  String convertTimeWithoutParse(time) {
    return DateFormat('h:mm').format(DateTime.parse(time)).toString() +
        DateFormat('a').format(DateTime.parse(time)).toString().toLowerCase();
  }

  String convertTimeForCheckedIn(time) {
    return DateFormat('dd').format(DateTime.parse(time)).toString() +
        '/' +
        DateFormat('MM').format(DateTime.parse(time)).toString() +
        ' @ ' +
        DateFormat().add_jm().format(DateTime.parse(time)).toString();
    // DateFormat('a').format(time).toString().toLowerCase();
  }
  final DateFormat formatter = DateFormat('jm');

  // ignore: missing_return
  bool checkCondition(dbRes, type) {
    var curDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var chkDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(dbRes['dailyAttendance']['checkInDateTime']))
        .toString();
    if (dbRes['dailyAttendance'] != null) {
      if (dbRes['dailyAttendance']['checkInDateTime'] != null &&
          dbRes['dailyAttendance']['checkOutDateTime'] == null) {
        //allow checkout
        //on duty
        if (type == 'chkout') {
          return true;
        }
        return false;
      } else if (dbRes['dailyAttendance']['checkInDateTime'] != null &&
          dbRes['dailyAttendance']['checkOutDateTime'] != null) {
        if (dbRes['empdetails']['shift'] == dbRes['dailyAttendance']['shift'] &&
            dbRes['empdetails']['sitePostedTo'].toString().toLowerCase() ==
                dbRes['dailyAttendance']['clientId'].toString().toLowerCase() &&
            curDate == chkDate) {
          if (dbRes['dailyAttendance']['attendanceAlias'] == 'L') {
            // On Leave
            // dont allow checkin
            Get.snackbar(
              null,
              'You cannot checkin when leave is approved',
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
          } else if (dbRes['dailyAttendance']['attendanceAlias'] == 'WO') {
            // On Week Off
            // dont allow checkin
            Get.snackbar(
              null,
              'You cannot checkin on week off days',
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
            // attendance given
            // dont allow checkin
            Get.snackbar(
              null,
              'Attendance already given by unit Incharge',
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
        } else {
          if (curDate == chkDate) {
            Get.snackbar(
              null,
              'You already checked in for today',
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
          return true;
        }
      }
    } else {
      return true;
    }
  }

  // ignore: missing_return
  bool conditionForMsg(dbRes, type) {
    var curDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    var chkDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(dbRes['dailyAttendance']['checkInDateTime']))
        .toString();
    if (dbRes['dailyAttendance'] != null) {
      if (dbRes['dailyAttendance']['checkInDateTime'] != null &&
          dbRes['dailyAttendance']['checkOutDateTime'] == null) {
        //allow checkout
        //on duty
        if (type == 'chkout') {
          return true;
        }
        return false;
      } else if (dbRes['dailyAttendance']['checkInDateTime'] != null &&
          dbRes['dailyAttendance']['checkOutDateTime'] != null) {
        if (dbRes['empdetails']['shift'] == dbRes['dailyAttendance']['shift'] &&
            dbRes['empdetails']['sitePostedTo'].toString().toLowerCase() ==
                dbRes['dailyAttendance']['clientId'].toString().toLowerCase() &&
            curDate == chkDate) {
          if (dbRes['dailyAttendance']['attendanceAlias'] == 'L') {
            // On Leave
            // dont allow checkin
            return false;
          } else if (dbRes['dailyAttendance']['attendanceAlias'] == 'WO') {
            // On Week Off
            // dont allow checkin
            return false;
          } else {
            // attendance given
            // dont allow checkin
            return false;
          }
        } else {
          if (curDate == chkDate) {
            return false;
          }
          return true;
        }
      }
    } else {
      return true;
    }
  }

  var appFeatures;

  @override
  Widget build(BuildContext context) {
    // print('width: ${MediaQuery.of(context).size.width}');
    appFeatures = jsonDecode(RemoteServices().box.get('appFeature'));
    var liteMode = RemoteServices().box.get('lite');
    if (appFeatures['routePlan'] == null) {
      appFeatures['routePlan'] = false;
      appFeatures['pinMyVisit'] = false;
    }
    if (liteMode != null && liteMode) {
      return Scaffold(
        backgroundColor: AppUtils().greyScaffoldBg,
        floatingActionButton: CustomFab('dashboard'),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNav('dashboard'),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: AssetImage(
                                    'assets/images/tm_logo.png',
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                SizedBox(
                                  width: 266.0,
                                  child: Text(
                                    RemoteServices().box.get('companyname'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  // icon: Icon(
                                  //   Icons.notifications_none_outlined,
                                  //   color: Colors.white,
                                  //   size: 30.0,
                                  // ),
                                  icon: Image.asset(
                                    'assets/images/bell_icon.png',
                                    height: 22.0,
                                  ),
                                  onPressed: () {
                                    Get.to(NotificationPage());
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    dbC.todayString.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Obx(() {
                                  return Text(
                                    'Good ' + dbC.greetings.value + ', ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  );
                                }),
                                Obx(() {
                                  if (dbC.isDashboardLoading.value) {
                                    return Text(
                                      '...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return Flexible(
                                      child: Text(
                                        // dbC.response.empdetails.name ?? 'N/A',
                                        dbC.response['empdetails']['name'] ??
                                            'N/A',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 160.0,
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //CHANGED
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 6.0,
                          margin: EdgeInsets.only(
                            // top: 00.0,
                            right: 12.0,
                            left: 12.0,
                            bottom: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Wrap(
                            children: [
                              Obx(() {
                                if (dbC.isDashboardLoading.value) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10.0,
                                      20.0,
                                      10.0,
                                      20.0,
                                    ),
                                    child: LoadingWidget(
                                      containerHeight: 75.0,
                                      loaderSize: 30.0,
                                      loaderColor: Colors.black87,
                                    ),
                                  );
                                } else if (dbC.response['dailyAttendance'] ==
                                    null) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10.0,
                                      25.0,
                                      10.0,
                                      25.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'You are posted in',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Obx(() {
                                              if (dbC
                                                  .isDashboardLoading.value) {
                                                return Text(
                                                  '...',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              } else {
                                                // print('Length: ${dbC.response['clientData']['name'].length}');
                                                var clientName =
                                                    dbC.response['clientData']
                                                            ['name'] ??
                                                        'N/A';
                                                var areaName =
                                                    dbC.response['clientData']
                                                            ['address'] ??
                                                        'N/A';
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 240.0,
                                                      child: Text(
                                                        '$clientName at $areaName',
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Duty Timings : ',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  convertTimeWithParse(
                                                      dbC.response['empdetails']
                                                          ['shiftStartTime']),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  ' to ',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  convertTimeWithParse(
                                                      dbC.response['empdetails']
                                                          ['shiftEndTime']),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          child: RaisedButton(
                                            onPressed: () {
                                              print(RemoteServices()
                                                  .box
                                                  .get('faceApi'));
                                              Get.to(CheckinPage(
                                                  RemoteServices()
                                                      .box
                                                      .get('faceApi'),
                                                  appFeatures[
                                                      'checkinLocation']));
                                            },
                                            child: Text(
                                              'Check In',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: AppUtils().greenColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              side: BorderSide(
                                                color: AppUtils().greenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  var chkinDt = dbC.response['dailyAttendance']
                                      ['checkInDateTime'];
                                  var chkoutDt = dbC.response['dailyAttendance']
                                      ['checkOutDateTime'];
                                  return (chkinDt != null && chkinDt != '') &&
                                          (chkoutDt == null || chkoutDt == '')
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10.0,
                                            10.0,
                                            10.0,
                                            10.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Current Status: ',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'On Duty',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppUtils()
                                                          .orangeColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Checked in on ',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    convertTimeForCheckedIn(
                                                      chkinDt,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    // maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Checked in at ',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithoutParse(dbC
                                                                        .response[
                                                                    'dailyAttendance']
                                                                [
                                                                'checkInDateTime']),
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Shift ends at ',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftEndTime']),
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        //Check Condition
                                                        var chk =
                                                            checkCondition(
                                                          dbC.response,
                                                          'chkout',
                                                        );
                                                        if (chk) {
                                                          Get.to(CheckoutPage(
                                                              RemoteServices()
                                                                  .box
                                                                  .get(
                                                                      'faceApi'),
                                                              appFeatures[
                                                                  'checkinLocation']));
                                                          // Get.to(CheckoutPage(0));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Check Out',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color: AppUtils()
                                                          .orangeColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25.0,
                                                        ),
                                                        side: BorderSide(
                                                          color: AppUtils()
                                                              .orangeColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10.0,
                                            25.0,
                                            10.0,
                                            25.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: !conditionForMsg(
                                                        dbC.response,
                                                        'chkin') &&
                                                    RemoteServices()
                                                            .box
                                                            .get('role') !=
                                                        '4',
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Attendance already given\nTiming : '+
                                                          formatter.format(DateTime.parse(dbC.response['dailyAttendance']['checkInDateTime']))+' to '+
                                                              formatter.format(DateTime.parse(dbC.response['dailyAttendance']['checkOutDateTime'])),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppUtils()
                                                            .orangeColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'You are posted in',
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Obx(() {
                                                        if (dbC
                                                            .isDashboardLoading
                                                            .value) {
                                                          return Text(
                                                            '...',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        } else {
                                                          // print('Length: ${dbC.response['clientData']['name'].length}');
                                                          var clientName = dbC
                                                                          .response[
                                                                      'clientData']
                                                                  ['name'] ??
                                                              'N/A';
                                                          var areaName = dbC
                                                                          .response[
                                                                      'clientData']
                                                                  ['address'] ??
                                                              'N/A';
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 240.0,
                                                                child: Text(
                                                                  '$clientName at $areaName',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   ' in ',
                                                              //   style: TextStyle(
                                                              //     fontSize: 15.0,
                                                              //   ),
                                                              // ),
                                                              // SizedBox(
                                                              //   width: 40.0,
                                                              //   child: Text(
                                                              //     // dbC.response['empdetails']['area'] ?? 'N/A',
                                                              //     'asdasd asdasd asdasdasd',
                                                              //     style: TextStyle(
                                                              //       fontSize: 15.0,
                                                              //       fontWeight: FontWeight.bold,
                                                              //     ),
                                                              //     overflow: TextOverflow.ellipsis,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          );
                                                        }
                                                      }),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Duty Timings : ',
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftStartTime']),
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' to ',
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftEndTime']),
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        //Check Condition
                                                        var chk =
                                                            checkCondition(
                                                          dbC.response,
                                                          'chkin',
                                                        );
                                                        if (chk) {
                                                          print(RemoteServices()
                                                              .box
                                                              .get('faceApi'));
                                                          Get.to(CheckinPage(
                                                              RemoteServices()
                                                                  .box
                                                                  .get(
                                                                      'faceApi'),
                                                              appFeatures[
                                                                  'checkinLocation']));
                                                          // Get.to(CheckinPage(0));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Check In',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color:
                                                          AppUtils().greenColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25.0,
                                                        ),
                                                        side: BorderSide(
                                                          color: AppUtils()
                                                              .greenColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   color: AppUtils().greyScaffoldBg,
                      //   height: 16.0,
                      // ),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        child: Column(
                          children: [
                            Obx(() {
                              if (dbC.isDashboardLoading.value) {
                                return LoadingWidget(
                                  containerHeight: 185.0,
                                  loaderSize: 30.0,
                                  loaderColor: Colors.black87,
                                );
                              } else {
                                var role = RemoteServices().box.get('role');
                                return dbC.response['psCount'] == null &&
                                        role != '4'
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                                left: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat.MMMM()
                                                        .format(DateTime.now())
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  role != '1'&& appFeatures[
                                                  'attendance']
                                                      ? FlatButton(
                                                          onPressed: () {
                                                            Get.offAll(
                                                              AttendancePage(),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Enter Attendance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 25.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No data to show',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        // height: 150.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  role != '1'&& appFeatures[
                                                  'attendance']
                                                      ? FlatButton(
                                                          onPressed: () {
                                                            Get.offAll(
                                                              AttendancePage(),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Enter Attendance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 25.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: AppUtils().greyScaffoldBg,
        floatingActionButton: CustomFab('dashboard'),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNav('dashboard'),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: AssetImage(
                                    'assets/images/tm_logo.png',
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                SizedBox(
                                  width: 266.0,
                                  child: Text(
                                    RemoteServices().box.get('companyname'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  // icon: Icon(
                                  //   Icons.notifications_none_outlined,
                                  //   color: Colors.white,
                                  //   size: 30.0,
                                  // ),
                                  icon: Image.asset(
                                    'assets/images/bell_icon.png',
                                    height: 22.0,
                                  ),
                                  onPressed: () {
                                    Get.to(NotificationPage());
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    dbC.todayString.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Obx(() {
                                  return Text(
                                    'Good ' + dbC.greetings.value + ', ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  );
                                }),
                                Obx(() {
                                  if (dbC.isDashboardLoading.value) {
                                    return Text(
                                      '...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return Flexible(
                                      child: Text(
                                        // dbC.response.empdetails.name ?? 'N/A',
                                        dbC.response['empdetails']['name'] ??
                                            'N/A',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 160.0,
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //CHANGED
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 6.0,
                          margin: EdgeInsets.only(
                            // top: 00.0,
                            right: 12.0,
                            left: 12.0,
                            bottom: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Wrap(
                            children: [
                              Obx(() {
                                if (dbC.isDashboardLoading.value) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10.0,
                                      20.0,
                                      10.0,
                                      20.0,
                                    ),
                                    child: LoadingWidget(
                                      containerHeight: 75.0,
                                      loaderSize: 30.0,
                                      loaderColor: Colors.black87,
                                    ),
                                  );
                                } else if (dbC.response['dailyAttendance'] ==
                                    null) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10.0,
                                      25.0,
                                      10.0,
                                      25.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'You are posted in',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Obx(() {
                                              if (dbC
                                                  .isDashboardLoading.value) {
                                                return Text(
                                                  '...',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              } else {
                                                // print('Length: ${dbC.response['clientData']['name'].length}');
                                                var clientName =
                                                    dbC.response['clientData']
                                                            ['name'] ??
                                                        'N/A';
                                                var areaName =
                                                    dbC.response['clientData']
                                                            ['address'] ??
                                                        'N/A';
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 240.0,
                                                      child: Text(
                                                        '$clientName at $areaName',
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Duty Timings : ',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  convertTimeWithParse(
                                                      dbC.response['empdetails']
                                                          ['shiftStartTime']),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  ' to ',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  convertTimeWithParse(
                                                      dbC.response['empdetails']
                                                          ['shiftEndTime']),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          child: RaisedButton(
                                            onPressed: () {
                                              print(RemoteServices()
                                                  .box
                                                  .get('faceApi'));
                                              Get.to(CheckinPage(
                                                  RemoteServices()
                                                      .box
                                                      .get('faceApi'),
                                                  appFeatures[
                                                      'checkinLocation']));
                                            },
                                            child: Text(
                                              'Check In',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: AppUtils().greenColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              side: BorderSide(
                                                color: AppUtils().greenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  var chkinDt = dbC.response['dailyAttendance']
                                      ['checkInDateTime'];
                                  var chkoutDt = dbC.response['dailyAttendance']
                                      ['checkOutDateTime'];
                                  return (chkinDt != null && chkinDt != '') &&
                                          (chkoutDt == null || chkoutDt == '')
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10.0,
                                            10.0,
                                            10.0,
                                            10.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Current Status: ',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'On Duty',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppUtils()
                                                          .orangeColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Checked in on ',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    convertTimeForCheckedIn(
                                                      chkinDt,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    // maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Checked in at ',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithoutParse(dbC
                                                                        .response[
                                                                    'dailyAttendance']
                                                                [
                                                                'checkInDateTime']),
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Shift ends at ',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftEndTime']),
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        //Check Condition
                                                        var chk =
                                                            checkCondition(
                                                          dbC.response,
                                                          'chkout',
                                                        );
                                                        if (chk) {
                                                          Get.to(CheckoutPage(
                                                              RemoteServices()
                                                                  .box
                                                                  .get(
                                                                      'faceApi'),
                                                              appFeatures[
                                                                  'checkinLocation']));
                                                          // Get.to(CheckoutPage(0));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Check Out',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color: AppUtils()
                                                          .orangeColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25.0,
                                                        ),
                                                        side: BorderSide(
                                                          color: AppUtils()
                                                              .orangeColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10.0,
                                            25.0,
                                            10.0,
                                            25.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: !conditionForMsg(
                                                        dbC.response,
                                                        'chkin') &&
                                                    RemoteServices()
                                                            .box
                                                            .get('role') !=
                                                        '4',
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Attendance already given\nTiming : '+
                                                          formatter.format(DateTime.parse(dbC.response['dailyAttendance']['checkInDateTime']))+' to '+
                                                          formatter.format(DateTime.parse(dbC.response['dailyAttendance']['checkOutDateTime'])),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: AppUtils()
                                                            .orangeColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'You are posted in',
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Obx(() {
                                                        if (dbC
                                                            .isDashboardLoading
                                                            .value) {
                                                          return Text(
                                                            '...',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          );
                                                        } else {
                                                          // print('Length: ${dbC.response['clientData']['name'].length}');
                                                          var clientName = dbC
                                                                          .response[
                                                                      'clientData']
                                                                  ['name'] ??
                                                              'N/A';
                                                          var areaName = dbC
                                                                          .response[
                                                                      'clientData']
                                                                  ['address'] ??
                                                              'N/A';
                                                          return Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 240.0,
                                                                child: Text(
                                                                  '$clientName at $areaName',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   ' in ',
                                                              //   style: TextStyle(
                                                              //     fontSize: 15.0,
                                                              //   ),
                                                              // ),
                                                              // SizedBox(
                                                              //   width: 40.0,
                                                              //   child: Text(
                                                              //     // dbC.response['empdetails']['area'] ?? 'N/A',
                                                              //     'asdasd asdasd asdasdasd',
                                                              //     style: TextStyle(
                                                              //       fontSize: 15.0,
                                                              //       fontWeight: FontWeight.bold,
                                                              //     ),
                                                              //     overflow: TextOverflow.ellipsis,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          );
                                                        }
                                                      }),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Duty Timings : ',
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftStartTime']),
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' to ',
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            convertTimeWithParse(dbC
                                                                        .response[
                                                                    'empdetails']
                                                                [
                                                                'shiftEndTime']),
                                                            style: TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        //Check Condition
                                                        var chk =
                                                            checkCondition(
                                                          dbC.response,
                                                          'chkin',
                                                        );
                                                        if (chk) {
                                                          print(RemoteServices()
                                                              .box
                                                              .get('faceApi'));
                                                          Get.to(CheckinPage(
                                                              RemoteServices()
                                                                  .box
                                                                  .get(
                                                                      'faceApi'),
                                                              appFeatures[
                                                                  'checkinLocation']));
                                                          // Get.to(CheckinPage(0));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Check In',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      color:
                                                          AppUtils().greenColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          25.0,
                                                        ),
                                                        side: BorderSide(
                                                          color: AppUtils()
                                                              .greenColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   color: AppUtils().greyScaffoldBg,
                      //   height: 16.0,
                      // ),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        child: Column(
                          children: [
                            Obx(() {
                              if (dbC.isDashboardLoading.value) {
                                return LoadingWidget(
                                  containerHeight: 185.0,
                                  loaderSize: 30.0,
                                  loaderColor: Colors.black87,
                                );
                              } else {
                                var role = RemoteServices().box.get('role');
                                return dbC.response['psCount'] == null &&
                                        role != '4'
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                                left: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat.MMMM()
                                                        .format(DateTime.now())
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  role != '1' && appFeatures[
                                                  'attendance']
                                                      ? FlatButton(
                                                          onPressed: () {
                                                            Get.offAll(
                                                              AttendancePage(),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Enter Attendance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 25.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No data to show',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        // height: 150.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    DateFormat.MMMM()
                                                        .format(DateTime.now())
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  role != '1' && appFeatures[
                                                  'attendance']
                                                      ? FlatButton(
                                                          onPressed: () {
                                                            Get.offAll(
                                                              AttendancePage(),
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'Enter Attendance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 25.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            role != '4'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomProgressIndicator(
                                                        // '23',
                                                        dbC.response['psCount']
                                                                ['shifts']
                                                            .toString(),
                                                        'Total Days',
                                                        75.0,
                                                        1,
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response['psCount']
                                                                ['present']
                                                            .toString(),
                                                        'Present',
                                                        75.0,
                                                        dbC.response['psCount']
                                                                ['present'] /
                                                            dbC.response[
                                                                    'psCount']
                                                                ['shifts'],
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response['psCount']
                                                                ['absent']
                                                            .toString(),
                                                        'Absent',
                                                        75.0,
                                                        dbC.response['psCount']
                                                                ['absent'] /
                                                            dbC.response[
                                                                    'psCount']
                                                                ['shifts'],
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response['psCount']
                                                                ['wo']
                                                            .toString(),
                                                        'Week Off',
                                                        75.0,
                                                        dbC.response['psCount']
                                                                ['wo'] /
                                                            dbC.response[
                                                                    'psCount']
                                                                ['shifts'],
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            role == '2' || role == '3'
                                                ? Column(children: [
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 1,
                                                      indent: 30.0,
                                                      endIndent: 30.0,
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    )
                                                  ])
                                                : Container(),
                                            role != '1'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomProgressIndicator(
                                                        // '23',
                                                        dbC.response[
                                                                'adminCount']
                                                                ['emps']
                                                            .toString(),
                                                        'Employees',
                                                        75.0,
                                                        1,
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response[
                                                                'adminCount']
                                                                ['present']
                                                            .toString(),
                                                        'Present',
                                                        75.0,
                                                        dbC.response[
                                                                    'adminCount']
                                                                ['present'] /
                                                            dbC.response[
                                                                    'adminCount']
                                                                ['emps'],
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response[
                                                                'adminCount']
                                                                ['absent']
                                                            .toString(),
                                                        'Absent',
                                                        75.0,
                                                        dbC.response[
                                                                    'adminCount']
                                                                ['absent'] /
                                                            dbC.response[
                                                                    'adminCount']
                                                                ['emps'],
                                                      ),
                                                      CustomProgressIndicator(
                                                        dbC.response[
                                                                'adminCount']
                                                                ['wo']
                                                            .toString(),
                                                        'Week Off',
                                                        75.0,
                                                        dbC.response[
                                                                    'adminCount']
                                                                ['wo'] /
                                                            dbC.response[
                                                                    'adminCount']
                                                                ['emps'],
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      );
                              }
                            }),
                          ],
                        ),
                      ),
                      Obx(() {
                        if (!dbC.isDashboardLoading.value) {
                          return Container(
                            color: AppUtils().greyScaffoldBg,
                            height: dbC.response['empActivities'] == null ||
                                    dbC.response['empActivities'].length == 0
                                ? 30.0
                                : 0.0,
                          );
                        }
                        return Container();
                      }),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        child: Obx(() {
                          if (dbC.isDashboardLoading.value) {
                            return LoadingWidget(
                              containerColor: Colors.grey[300],
                              containerHeight: 190.0,
                              loaderSize: 30.0,
                              loaderColor: Colors.black87,
                            );
                          } else {
                            return Visibility(
                              visible: dbC.response['empActivities'] == null ||
                                      dbC.response['empActivities'].length == 0
                                  ? false
                                  : true,
                              child: Container(
                                height: 190.0,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0,
                                    // left: 20.0,
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dbC.response['empActivities'] ==
                                            null
                                        ? 0
                                        : dbC.response['empActivities'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var empAct =
                                          dbC.response['empActivities'][index];
                                      return DBActivityTile(
                                        empAct,
                                        index,
                                        dbC.response['empActivities'].length,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Visibility(
                        visible: appFeatures['routePlan'] ?? true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/dummy_location.png',
                                      height: 40.0,
                                      width: 40.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'My Route Plan',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: appFeatures['gps'] ?? true,
                        child: Container(
                          color: AppUtils().greyScaffoldBg,
                          height: 20.0,
                        ),
                      ),
                      Visibility(
                        visible:
                            appFeatures['gps'] && appFeatures['routePlan'] ??
                                true,
                        child: Container(
                          color: AppUtils().greyScaffoldBg,
                          child: Obx(() {
                            if (erpC.isEmpLoading.value) {
                              return LoadingWidget(
                                containerColor: Colors.grey[300],
                                containerHeight: 210.0,
                                loaderSize: 30.0,
                                loaderColor: Colors.black87,
                              );
                            } else {
                              return Container(
                                color: AppUtils().greyScaffoldBg,
                                height: erpC.empRes.routePlanList == null ||
                                        erpC.empRes.routePlanList.length == 0
                                    ? 0.0
                                    : 220.0,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 20.0,
                                  ),
                                  child: erpC.empRes.routePlanList == null ||
                                          erpC.empRes.routePlanList.length == 0
                                      ? Container()
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          // itemCount: erpC.empRes.routePlanList.length,
                                          itemCount:
                                              erpC.empRes.routePlanList.length >
                                                      4
                                                  ? 5
                                                  : erpC.empRes.routePlanList
                                                      .length,
                                          itemBuilder: (context, index) {
                                            var length = erpC
                                                .empRes.routePlanList.length;
                                            var empRoute = erpC
                                                .empRes.routePlanList[index];
                                            // print('index: $index');
                                            return DBEmprTile(
                                              empRoute,
                                              index,
                                              // erpC.empRes.routePlanList.length,
                                              length > 4 ? 4 : length,
                                            );
                                          },
                                        ),
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                      Visibility(
                        visible: appFeatures['routePlan'] ||
                                appFeatures['pinMyVisit'] ??
                            true,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Image.asset(
                                    //   'assets/images/dummy_location.png',
                                    //   height: 40.0,
                                    //   width: 40.0,
                                    // ),
                                    Visibility(
                                        visible:
                                            appFeatures['routePlan'] ?? true,
                                        child: Icon(
                                          Icons.map,
                                          size: 25.0,
                                          color: Colors.grey,
                                        )),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Visibility(
                                      visible: appFeatures['routePlan'] ?? true,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(RoutePlanning());
                                        },
                                        child: Text(
                                          'Create New Route Plan',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Visibility(
                                      visible:
                                          appFeatures['pinMyVisit'] ?? true,
                                      child: Icon(
                                        Icons.pin_drop,
                                        size: 25.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Visibility(
                                        visible:
                                            appFeatures['pinMyVisit'] ?? true,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(PinMyVisit());
                                          },
                                          child: Text(
                                            'Pin My Visit',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: appFeatures['gps'] ?? true,
                        child: Container(
                          color: AppUtils().greyScaffoldBg,
                          height: 20.0,
                        ),
                      ),
                      // DotsIndicator(
                      //   dotsCount: erpC.empRes.routePlanList.length,
                      //   position: 0,
                      //   decorator: DotsDecorator(
                      //     activeColor: Colors.grey,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 45.0,
                          ),
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  50.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (calC.calendarType != 'myCal') {
                                      calC.calendarType = 'myCal';
                                      var dateParse =
                                          DateTime.parse(calC.changedDate);
                                      var formattedDate =
                                          '${dateParse.month}${dateParse.year.toString().substring(2)}';
                                      calC.getCalendar(month: formattedDate);
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: calC.calendarType == 'myCal'
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9.0,
                                        horizontal: 33.0,
                                      ),
                                      child: SizedBox(
                                        width: 122.0,
                                        height: 23.0,
                                        child: Center(
                                          child: Text(
                                            'My Calendar',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  calC.calendarType == 'myCal'
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (calC.calendarType != 'myRos') {
                                      calC.calendarType = 'myRos';
                                      var dateParse =
                                          DateTime.parse(calC.changedDate);
                                      var formattedDate =
                                          '${dateParse.month}${dateParse.year.toString().substring(2)}';
                                      calC.getCalendar(month: formattedDate);
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: calC.calendarType == 'myRos'
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9.0,
                                        horizontal: 33.0,
                                      ),
                                      child: SizedBox(
                                        width: 122.0,
                                        height: 23.0,
                                        child: Center(
                                          child: Text(
                                            'My Roster',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  calC.calendarType == 'myRos'
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        height: 20.0,
                      ),
                      Container(
                        color: AppUtils().greyScaffoldBg,
                        child: Obx(() {
                          if (calC.isEventLoading.value) {
                            return LoadingWidget(
                              containerHeight: 420.0,
                              loaderSize: 30.0,
                              loaderColor: Colors.black87,
                            );
                          } else {
                            return HomeCalendar(
                              calC.calendarType,
                            );
                          }
                        }),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

}
