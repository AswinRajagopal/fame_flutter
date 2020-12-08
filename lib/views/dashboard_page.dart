import 'checkin_page.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/loading_widget.dart';
import 'package:get/get.dart';

import '../widgets/custom_fab.dart';
import '../widgets/home_calendar.dart';

import '../widgets/bottom_nav.dart';

import '../widgets/progress_indicator.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController dbController = Get.put(DashboardController());
  var todayString = DateFormat.E().format(DateTime.now()).toString() +
      ' ' +
      DateFormat.d().format(DateTime.now()).toString() +
      ' ' +
      DateFormat.MMM().format(DateTime.now()).toString() +
      ', ' +
      DateFormat().add_jm().format(DateTime.now()).toString();

  var calendarType = 'myCal'; // myCal & myRos

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    }
    if (hour < 17) {
      return 'afternoon';
    }
    return 'evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                                'Pocket FaME',
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
                          Row(
                            children: [
                              Icon(
                                Icons.wb_sunny,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                // 'Wed 21 Oct, 9:00am',
                                todayString,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
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
                                'Good ' + greeting() + ', ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                RemoteServices().box.get('userName') ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          10.0,
                          20.0,
                          10.0,
                          20.0,
                        ),
                        child: Obx(() {
                          if (dbController.isStatusLoading.value) {
                            return LoadingWidget(
                              containerHeight: 75.0,
                              loaderSize: 30.0,
                              loaderColor: Colors.black87,
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'You are posted in',
                                      style: TextStyle(
                                        fontSize: 16.0,
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
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'in ',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          'Hitech City.',
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
                                          'Duty Timings:',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          '9:30am ',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'to ',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          '6:30pm',
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
                            );
                          }
                        }),
                      ),
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
                      if (dbController.isStatusLoading.value) {
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
                                    '23',
                                    'Total Days',
                                    80.0,
                                    0.75,
                                  ),
                                  CustomProgressIndicator(
                                    '22',
                                    'Present',
                                    80.0,
                                    0.60,
                                  ),
                                  CustomProgressIndicator(
                                    '1',
                                    'Absent',
                                    80.0,
                                    0.10,
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
                      if (dbController.isLeaveStatusLoading.value) {
                        return LoadingWidget(
                          containerColor: Colors.grey[300],
                          containerHeight: 195.0,
                          loaderSize: 30.0,
                          loaderColor: Colors.black87,
                        );
                      } else {
                        return Container(
                          height: 195.0,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              bottom: 20.0,
                              // left: 20.0,
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 20.0,
                                ),
                                Container(
                                  width: 330.0,
                                  decoration: BoxDecoration(
                                    color: Colors.teal[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 18.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Leave Status',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Chip(
                                              label: Text(
                                                'Approved',
                                              ),
                                              backgroundColor: Colors.teal[200],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          'Your leave on 22 Oct 2020 is approved by Sandeep on 16 Oct 2020.',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  50.0,
                                                ),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Container(
                                  width: 330.0,
                                  decoration: BoxDecoration(
                                    color: Colors.teal[300],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 18.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Leave Status',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Chip(
                                              label: Text(
                                                'Approved',
                                              ),
                                              backgroundColor: Colors.teal[200],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          'Your leave on 22 Oct 2020 is approved by Sandeep on 16 Oct 2020.',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  50.0,
                                                ),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                              ),
                                            ),
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
                      }
                    }),
                    SizedBox(
                      width: 20.0,
                    ),
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
                                Text(
                                  'Create new route plan',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
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
                      if (dbController.isCalendarLoading.value) {
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
