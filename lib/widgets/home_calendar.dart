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

class _HomeCalendarState extends State<HomeCalendar> with TickerProviderStateMixin {
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

  void _onVisibleDaysChanged(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {
    // print('CALLBACK: _onVisibleDaysChanged');
    // print('Month: ${first.month}');
    // print('Year: ${first.year.toString().substring(2)}');
    var month = '${first.month}${first.year.toString().substring(2)}';
    var chDtString = '${first.year}-${first.month < 10 ? '0' + first.month.toString() : first.month}-${first.day < 10 ? '0' + first.day.toString() : first.day}';
    calC.getCalendar(month: month, chDt: chDtString);
  }

  void _onCalendarCreated(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {
    // print('CALLBACK: _onCalendarCreated');
  }

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
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      initialSelectedDay: DateTime.parse(calC.changedDate.toString()),
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      rowHeight: 70.0,
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
          // print(date);
          return DateFormat.MMMM(locale).format(date).toString() + ', ' + DateFormat.y(locale).format(date).toString();
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
        selectedDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.only(top: 1.0, left: 18.0),
            width: 100,
            height: 300,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        dayBuilder: (context, date, events) {
          return Container(
            // margin: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.only(top: 1.0, left: 18.0),
            width: 100,
            height: 300,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
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
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    // print(events.first);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50.0,
      height: 30.0,
      child: Center(
        child: Text(
          events.first,
          style: TextStyle().copyWith(
            color: Colors.indigo[900],
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
