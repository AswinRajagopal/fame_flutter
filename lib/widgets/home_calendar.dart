import 'package:fame/views/regularize_attendance.dart';
import 'package:get/get.dart';

import '../controllers/dbcal_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeCalendar extends StatefulWidget {
  final String calType;
  HomeCalendar(this.calType);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar>
    with TickerProviderStateMixin {
  final DBCalController calC = Get.put(DBCalController());
  // Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void showPopup(date, events) {
    var showDate =
        '${date.year}-${date.month <= 9 ? '0' + date.month.toString() : date.month}-${date.day <= 9 ? '0' + date.day.toString() : date.day}';
    if (calC.calendarType == 'myRos') {
      if (events != null) {
        var eveSplit = events.first.split(',');
        var eveLength = events.first.split(',').length;
        var clSplit = eveSplit.last.split('#');
        var client1;
        var client2;
        if (clSplit.length > 1) {
          client1 = clSplit[0];
          client2 = clSplit[1];
        } else {
          client1 = eveSplit.last;
        }
        // if (eveLength > 1) {
        var dtFormat = showDate.toString().split('-')[2] +
            '-' +
            showDate.toString().split('-')[1] +
            '-' +
            showDate.toString().split('-')[0];
        Get.defaultDialog(
          title: 'Roster on $dtFormat',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$client1 : ${eveSplit[0]}',
              ),
              eveLength > 1 && (eveSplit[1] != null && client2 != null)
                  ? Text(
                      '$client2 : ${eveSplit[1]}',
                    )
                  : SizedBox(),
            ],
          ),
          radius: 5.0,
        );
        // }
      }
    } else {
      var dtFormat = showDate.toString().split('-')[2] +
          '-' +
          showDate.toString().split('-')[1] +
          '-' +
          showDate.toString().split('-')[0];
      var calEvent = events == null ? [] : events.first.split('*');
      String dateString = dtFormat;
      List<String> dateParts = dateString.split('-');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);
      final regDate = DateTime(year, month, day);
      final curDate = DateTime.now();
      int difference = curDate.difference(regDate).inDays;
      if (calEvent.length > 1) {
        Get.defaultDialog(
          title: 'Employee Detail on $dtFormat',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              date.weekday == DateTime.sunday
                  ? Text(
                      'Checked In @ ${calEvent[1].split(',')[0]}',
                    )
                  : Text(
                      calEvent[0] == 'A'
                          ? 'Alias: A'
                          : 'Checked In @ ${calEvent[1].split(',')[0]}',
                    ),
              date.weekday == DateTime.sunday
                  ? Text(
                      'Checked Out @ ${calEvent[1].split(',')[1]}',
                    )
                  : Text(
                      calEvent[0] == 'A'
                          ? ''
                          : 'Checked Out @ ${calEvent[1].split(',')[1]}',
                    ),
              difference <= 2
                  ? RaisedButton(
                      onPressed: () {
                        Get.to(RegularizeAttendancePage(
                            dtFormat,
                            calEvent[0],
                            calEvent[0] == 'A'?'0':calEvent[1].split(',')[0],
                            calEvent[0] == 'A'?'0':calEvent[1].split(',')[1],
                            calEvent[1].split(',')[2]));
                      },
                      child: Text('Regularize'),
                    )
                  : Column()
            ],
          ),
          radius: 5.0,
        );
      }
    }
  }

  void _onVisibleDaysChanged(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {
    var month = '${first.month}${first.year.toString().substring(2)}';
    var chDtString =
        '${first.year}-${first.month < 10 ? '0' + first.month.toString() : first.month}-${first.day < 10 ? '0' + first.day.toString() : first.day}';
    calC.getCalendar(month: month, chDt: chDtString);
  }

  void _onCalendarCreated(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {}

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 300), calC.init);
    return Container(
      color: Colors.white,
      child: _buildTableCalendarWithBuilders(),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: calC.events,
      weekendDays: [DateTime.sunday],
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      initialSelectedDay: DateTime.parse(calC.changedDate.toString()),
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      rowHeight:90.0,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
        titleTextBuilder: (date, locale) {
          return DateFormat.MMMM(locale).format(date).toString() +
              ', ' +
              DateFormat.y(locale).format(date).toString();
        },
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
        weekdayStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) {
          return GestureDetector(
            // onTap: () {
            //   showPopup(date, events);
            // },
            child: Container(
              margin: const EdgeInsets.only(top: 4.0),
              padding: const EdgeInsets.only(top: 15.0, left: 28.0),
              width: 100,
              height: 400,
              // child: GestureDetector(
              //   onTap: () {
              //     showPopup(date, events);
              //   },
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              // ),
            ),
          );
        },
        dayBuilder: (context, date, events) {
          return Container(
            // margin: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.only(top: 15.0, left: 28.0),
            width: 100,
            height: 300,
            child: GestureDetector(
              onTap: () {
                showPopup(date, events);
              },
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
      onDaySelected: (date,events,holidays){
        showPopup(date, events);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    var showEvent;
    if (events.first.split(',').length > 1 &&
        !events.first.toString().contains('*')) {
      var eventSplit = events.first.split(',');
      showEvent = eventSplit[0];
    } else {
      showEvent = events.first.split('*').first;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50.0,
      height: 50.0,
      child: Center(
        child: showEvent == 'P'
            ? Text(
                showEvent,
                style: TextStyle().copyWith(
                  color: Colors.green,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              )
            : showEvent == 'LT'
                ? Text(
                    showEvent,
                    style: TextStyle().copyWith(
                      color: Colors.purple,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : showEvent == 'EE'
                    ? Text(
                        showEvent,
                        style: TextStyle().copyWith(
                          color: Colors.orange,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : showEvent == 'L'
                        ? Text(
                            showEvent,
                            style: TextStyle().copyWith(
                              color: Colors.red,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : showEvent == 'A'
                            ? Text(
                                showEvent,
                                style: TextStyle().copyWith(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            : Text(
                                showEvent,
                                style: TextStyle().copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
      ),
    );
  }
}
