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
  Map<DateTime, List> _events;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // final _selectedDay = DateTime.now();

    _events = {};

    _events[DateTime.parse('2020-12-05')] = ['EE'];

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
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        calendarController: _calendarController,
        // events: _events,
        // holidays: _holidays,
        availableGestures: AvailableGestures.all,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          selectedColor: Colors.pink[300],
          todayColor: Colors.blue,
          outsideDaysVisible: false,
          weekendStyle: TextStyle(
            color: Colors.black,
          ),
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
        initialCalendarFormat: CalendarFormat.month,
        daysOfWeekStyle: DaysOfWeekStyle(
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       width: 1.5,
          //       color: Colors.grey[300],
          //     ),
          //   ),
          // ),
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
        availableCalendarFormats: const {
          CalendarFormat.month: '',
        },
        // onDaySelected: _onDaySelected,
        onVisibleDaysChanged: _onVisibleDaysChanged,
        onCalendarCreated: _onCalendarCreated,
      ),
    );
  }
}
