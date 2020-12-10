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
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dbC = Get.put(DashboardController());
  final EmprplanController erpC = Get.put(EmprplanController());
  final DBCalController calC = Get.put(DBCalController());

  var calendarType = 'myCal'; // myCal & myRos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils().sccaffoldBg,
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
                                backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png',
                                ),
                                radius: 20.0,
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                AppUtils().appName,
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
                                  return Text(
                                    dbC.response.clientData.name ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
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
                          return chkinDt != null && chkinDt != ''
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    10.0,
                                    33.0,
                                    10.0,
                                    33.0,
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
                                          Row(
                                            children: [
                                              Text(
                                                'Checked in at ',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              Text(
                                                DateFormat()
                                                    .add_jm()
                                                    .format(dbC
                                                        .response
                                                        .dailyAttendance
                                                        .checkInDateTime)
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
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
                                                DateFormat()
                                                    .add_jm()
                                                    .format(
                                                        DateFormat('HH:mm:ss')
                                                            .parse(dbC
                                                                .response
                                                                .empdetails
                                                                .shiftEndTime))
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Get.to(CheckinPage());
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
                                          borderRadius: BorderRadius.circular(
                                            25.0,
                                          ),
                                          side: BorderSide(
                                            color: Colors.orange[800],
                                          ),
                                        ),
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
                                          Row(
                                            children: [
                                              Text(
                                                'ABC Client ',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'in ',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                'Hitech City.',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
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
                                                'Duty Timings:',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                DateFormat()
                                                    .add_jm()
                                                    .format(DateFormat(
                                                            'HH:mm:ss')
                                                        .parse(dbC
                                                            .response
                                                            .empdetails
                                                            .shiftStartTime))
                                                    .toString(),
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
                                                DateFormat()
                                                    .add_jm()
                                                    .format(
                                                        DateFormat('HH:mm:ss')
                                                            .parse(dbC
                                                                .response
                                                                .empdetails
                                                                .shiftEndTime))
                                                    .toString(),
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
                                          Get.to(CheckinPage());
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
                        return Container(
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
                                child: Text(
                                  DateFormat.MMMM()
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomProgressIndicator(
                                    // '23',
                                    dbC.response.psCount.shifts.toString(),
                                    'Total Days',
                                    80.0,
                                    1,
                                  ),
                                  CustomProgressIndicator(
                                    dbC.response.psCount.present.toString(),
                                    'Present',
                                    80.0,
                                    dbC.response.psCount.present /
                                        dbC.response.psCount.shifts,
                                  ),
                                  CustomProgressIndicator(
                                    dbC.response.psCount.absent.toString(),
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
                        return Container(
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
                                var empAct = dbC.response.empActivities[index];
                                return DBActivityTile(
                                  empAct,
                                  index,
                                  dbC.response.empActivities.length,
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          'My Route Plan',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                          height: 210.0,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15.0,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: erpC.empRes.routePlanList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var empRoute = erpC.empRes.routePlanList[index];
                                return DBEmprTile(
                                  empRoute,
                                  index,
                                  erpC.empRes.routePlanList.length,
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
                                setState(() {
                                  calendarType = 'myCal';
                                });
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
                                setState(() {
                                  calendarType = 'myRos';
                                });
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
                      if (dbC.isDashboardLoading.value) {
                        return LoadingWidget(
                          containerHeight: 330.0,
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
