import 'package:percent_indicator/percent_indicator.dart';

import '../connection/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var todayString = DateFormat.E().format(DateTime.now()).toString() +
      ' ' +
      DateFormat.d().format(DateTime.now()).toString() +
      ' ' +
      DateFormat.MMM().format(DateTime.now()).toString() +
      ', ' +
      DateFormat().add_jm().format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 6.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.widgets_sharp,
                size: 32.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        fixedColor: Colors.blue,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        selectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        unselectedFontSize: 14.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.date_range,
              size: 30.0,
            ),
            label: 'Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30.0,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Visibility(
              visible: false,
              child: Icon(
                Icons.widgets_sharp,
                size: 30.0,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              size: 30.0,
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_vert,
              size: 30.0,
            ),
            label: 'More',
          ),
        ],
      ),
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
                                'Good morning, ',
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
                        child: Row(
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
                              onPressed: () {},
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
                    Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                center: Text(
                                  '23',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                radius: 80.0,
                                percent: 0.75,
                                animation: true,
                                animationDuration: 2000,
                                curve: Curves.easeInOut,
                                backgroundColor: Colors.grey[350],
                                progressColor: Colors.blue,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'Total Days',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                center: Text(
                                  '22',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                radius: 80.0,
                                percent: 0.60,
                                animation: true,
                                animationDuration: 2000,
                                curve: Curves.easeInOut,
                                backgroundColor: Colors.grey[350],
                                progressColor: Colors.blue,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'Present',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                center: Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                radius: 80.0,
                                percent: 0.10,
                                animation: true,
                                animationDuration: 2000,
                                curve: Curves.easeInOut,
                                backgroundColor: Colors.grey[350],
                                progressColor: Colors.blue,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'Absent',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                            SizedBox(
                              width: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Working on...',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
