import 'attendance_page.dart';

import 'route_planning.dart';

import 'checkout_page.dart';

import '../connection/remote_services.dart';

import '../controllers/dbcal_controller.dart';

import '../widgets/db_empr_tile.dart';

import '../controllers/emprplan_controller.dart';

import '../widgets/db_activity_tile.dart';

import 'checkin_page.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/loading_widget.dart';
import '../utils/utils.dart';
import 'package:get/get.dart';

import '../widgets/custom_fab.dart';
import '../widgets/home_calendar.dart';

import '../widgets/bottom_nav.dart';

import '../widgets/progress_indicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';

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

  var calendarType = 'myCal'; // myCal & myRos

  @override
  void initState() {
    super.initState();
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
    return DateFormat('h:mm').format(time).toString() +
        DateFormat('a').format(time).toString().toLowerCase();
  }

  String convertTimeForCheckedIn(time) {
    return DateFormat('d').format(time).toString() +
        '/' +
        DateFormat('M').format(time).toString() +
        '/' +
        DateFormat('yyyy').format(time).toString() +
        ' @ ' +
        DateFormat().add_jm().format(time).toString();
    // DateFormat('a').format(time).toString().toLowerCase();
  }

  // ignore: missing_return
  bool checkCondition(dbRes, type) {
    var curDate = DateFormat('yyyy-M-d').format(DateTime.now()).toString();
    var chkDate = DateFormat('yyyy-M-d')
        .format(dbRes.dailyAttendance.checkInDateTime)
        .toString();
    if (dbRes.dailyAttendance != null) {
      if (dbRes.dailyAttendance.checkInDateTime != null &&
          dbRes.dailyAttendance.checkOutDateTime == null) {
        //allow checkout
        //on duty
        if (type == 'chkout') {
          return true;
        }
        return false;
      } else if (dbRes.dailyAttendance.checkInDateTime != null &&
          dbRes.dailyAttendance.checkOutDateTime != null) {
        if (dbRes.empdetails.shift == dbRes.dailyAttendance.shift &&
            dbRes.empdetails.sitePostedTo.toString().toLowerCase() ==
                dbRes.dailyAttendance.clientId.toString().toLowerCase() &&
            curDate == chkDate) {
          if (dbRes.dailyAttendance.attendanceAlias == 'L') {
            // On Leave
            // dont allow checkin
            Get.snackbar(
              'Error',
              'You cannot checkin when leave is approved',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else if (dbRes.dailyAttendance.attendanceAlias == 'WO') {
            // On Week Off
            // dont allow checkin
            Get.snackbar(
              'Error',
              'You cannot checkin on week off days',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          } else {
            // attendance given
            // dont allow checkin
            Get.snackbar(
              'Error',
              'Attendance already given by unit Incharge',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
            );
            return false;
          }
        } else {
          if (curDate == chkDate) {
            Get.snackbar(
              'Error',
              'You already checked in for today',
              colorText: Colors.white,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), dbC.init);
    Future.delayed(Duration(milliseconds: 100), erpC.init);
    Future.delayed(Duration(milliseconds: 100), calC.init);
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
                    color: Colors.blue,
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
                                // backgroundImage: NetworkImage(
                                //   'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                                // ),
                                radius: 20.0,
                                backgroundImage: AssetImage(
                                  'assets/images/tm_logo.png',
                                ),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                RemoteServices().box.get('companyname'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: () {},
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
                                      dbC.response.empdetails.name ?? 'N/A',
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 6.0,
                  margin: EdgeInsets.only(
                    top: 160.0,
                    right: 12.0,
                    left: 12.0,
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
                        } else {
                          var chkinDt =
                              dbC.response.dailyAttendance.checkInDateTime;
                          var chkoutDt =
                              dbC.response.dailyAttendance.checkOutDateTime;
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'On Duty',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            convertTimeForCheckedIn(
                                              chkinDt,
                                            ),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                        .response
                                                        .dailyAttendance
                                                        .checkInDateTime),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        .response
                                                        .empdetails
                                                        .shiftEndTime),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              //Check Condition
                                              var chk = checkCondition(
                                                dbC.response,
                                                'chkout',
                                              );
                                              if (chk) {
                                                Get.to(CheckoutPage());
                                              }
                                            },
                                            child: Text(
                                              'Check Out',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: Colors.orange[800],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25.0,
                                              ),
                                              side: BorderSide(
                                                color: Colors.orange[800],
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
                                              return Row(
                                                children: [
                                                  Text(
                                                    dbC.response.clientData
                                                            .name ??
                                                        'N/A',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' in ',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    dbC.response.empdetails
                                                            .area ??
                                                        'N/A',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                'Duty Timings:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                convertTimeWithParse(dbC
                                                    .response
                                                    .empdetails
                                                    .shiftStartTime),
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
                                                convertTimeWithParse(dbC
                                                    .response
                                                    .empdetails
                                                    .shiftEndTime),
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          //Check Condition
                                          var chk = checkCondition(
                                            dbC.response,
                                            'chkin',
                                          );
                                          if (chk) {
                                            Get.to(CheckinPage());
                                          }
                                        },
                                        child: Text(
                                          'Check In',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25.0,
                                          ),
                                          side: BorderSide(
                                            color: Colors.green,
                                          ),
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
              ),
            ),
            Positioned(
              top: 300.0,
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: SingleChildScrollView(
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
                        return dbC.response.psCount == null
                            ? Container()
                            : Container(
                                // height: 150.0,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        left: 20.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat.MMMM()
                                                .format(DateTime.now())
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          role == '2' || role == '3'
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
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        size: 25.0,
                                                        color: Colors.grey,
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
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomProgressIndicator(
                                          // '23',
                                          dbC.response.psCount.shifts
                                              .toString(),
                                          'Total Days',
                                          80.0,
                                          1,
                                        ),
                                        CustomProgressIndicator(
                                          dbC.response.psCount.present
                                              .toString(),
                                          'Present',
                                          80.0,
                                          dbC.response.psCount.present /
                                              dbC.response.psCount.shifts,
                                        ),
                                        CustomProgressIndicator(
                                          dbC.response.psCount.absent
                                              .toString(),
                                          'Absent',
                                          80.0,
                                          dbC.response.psCount.absent /
                                              dbC.response.psCount.shifts,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              );
                      }
                    }),
                    Obx(() {
                      if (dbC.isDashboardLoading.value) {
                        return LoadingWidget(
                          containerColor: Colors.grey[300],
                          containerHeight: 180.0,
                          loaderSize: 30.0,
                          loaderColor: Colors.black87,
                        );
                      } else {
                        return Visibility(
                          visible: dbC.response.empActivities == null ||
                                  dbC.response.empActivities.length == 0
                              ? false
                              : true,
                          child: Container(
                            height: 180.0,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                                // left: 20.0,
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dbC.response.empActivities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var empAct =
                                      dbC.response.empActivities[index];
                                  return DBActivityTile(
                                    empAct,
                                    index,
                                    dbC.response.empActivities.length,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(
                      width: 20.0,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20.0,
                    //     ),
                    //     child: Text(
                    //       'My Route Plan',
                    //       style: TextStyle(
                    //         fontSize: 20.0,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 18.0,
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
                                  width: 6.0,
                                ),
                                Text(
                                  'My Route Plan',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    // Get.offAll(RoutePlanning());
                                    Get.to(RoutePlanning());
                                  },
                                  child: Text(
                                    'Create New Route Plan',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Get.offAll(RoutePlanning());
                                    Get.to(RoutePlanning());
                                  },
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 35.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Obx(() {
                      if (erpC.isEmpLoading.value) {
                        return LoadingWidget(
                          containerColor: Colors.grey[300],
                          containerHeight: 210.0,
                          loaderSize: 30.0,
                          loaderColor: Colors.black87,
                        );
                      } else {
                        return Container(
                          height: erpC.empRes.routePlanList == null ||
                                  erpC.empRes.routePlanList.length == 0
                              ? 0.0
                              : 210.0,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15.0,
                            ),
                            child: erpC.empRes.routePlanList == null ||
                                    erpC.empRes.routePlanList.length == 0
                                ? Container()
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // itemCount: erpC.empRes.routePlanList.length,
                                    itemCount:
                                        erpC.empRes.routePlanList.length > 4
                                            ? 5
                                            : erpC.empRes.routePlanList.length,
                                    itemBuilder: (context, index) {
                                      var length =
                                          erpC.empRes.routePlanList.length;
                                      var empRoute =
                                          erpC.empRes.routePlanList[index];
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 1.3,
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
                                // setState(() {
                                //   calendarType = 'myCal';
                                // });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: calendarType == 'myCal'
                                      ? Colors.white
                                      : Colors.blue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      50.0,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7.0,
                                    horizontal: 25.0,
                                  ),
                                  child: Text(
                                    'My Calendar',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: calendarType == 'myCal'
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   calendarType = 'myRos';
                                // });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: calendarType == 'myRos'
                                      ? Colors.white
                                      : Colors.blue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      50.0,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7.0,
                                    horizontal: 25.0,
                                  ),
                                  child: Text(
                                    'My Roster',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: calendarType == 'myRos'
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Obx(() {
                      if (calC.isEventLoading.value) {
                        return LoadingWidget(
                          containerHeight: 420.0,
                          loaderSize: 30.0,
                          loaderColor: Colors.black87,
                        );
                      } else {
                        return HomeCalendar(
                          calendarType,
                        );
                      }
                    }),
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
