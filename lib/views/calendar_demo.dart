import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDemo extends StatefulWidget {
  @override
  _CalendarDemoState createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<CalendarDemo> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  // List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {};

    // _events[DateTime.parse('2020-12-04')] = ['EE'];

    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['EE'],
      _selectedDay.subtract(Duration(days: 27)): ['EE'],
      _selectedDay.subtract(Duration(days: 20)): [
        'L',
      ],
      _selectedDay.subtract(Duration(days: 16)): ['LT'],
      _selectedDay.subtract(Duration(days: 10)): ['P'],
      _selectedDay.subtract(Duration(days: 4)): ['WO'],
      _selectedDay.subtract(Duration(days: 2)): ['S'],
      _selectedDay: ['P'],
      _selectedDay.add(Duration(days: 1)): [
        'EE',
      ],
      _selectedDay.add(Duration(days: 3)): ['LT'],
      _selectedDay.add(Duration(days: 7)): ['EE'],
      _selectedDay.add(Duration(days: 11)): ['EE'],
      _selectedDay.add(Duration(days: 17)): [
        'EE',
      ],
      _selectedDay.add(Duration(days: 22)): ['EE'],
      _selectedDay.add(Duration(days: 26)): ['EE'],
    };

    // _selectedEvents = _events[_selectedDay] ?? [];
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

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    // setState(() {
    //   _selectedEvents = events;
    // });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calendar demo'),
      ),
      // body: Column(
      //   mainAxisSize: MainAxisSize.max,
      //   children: <Widget>[
      //     // Switch out 2 lines below to play with TableCalendar's settings
      //     //-----------------------
      //     // _buildTableCalendar(),
      //     _buildTableCalendarWithBuilders(),
      //     // const SizedBox(height: 8.0),
      //     // _buildButtons(),
      //     // const SizedBox(height: 8.0),
      //     // Expanded(child: _buildEventList()),
      //   ],
      // ),
      body: _buildTableCalendarWithBuilders(),
    );
  }

// Simple TableCalendar configuration (using Styles)
  // Widget _buildTableCalendar() {
  //   return TableCalendar(
  //     calendarController: _calendarController,
  //     // events: _events,
  //     // holidays: _holidays,
  //     startingDayOfWeek: StartingDayOfWeek.sunday,
  //     calendarStyle: CalendarStyle(
  //       selectedColor: Colors.deepOrange[400],
  //       todayColor: Colors.deepOrange[200],
  //       markersColor: Colors.brown[700],
  //       outsideDaysVisible: false,
  //     ),
  //     headerStyle: HeaderStyle(
  //       formatButtonTextStyle:
  //           TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
  //       formatButtonDecoration: BoxDecoration(
  //         color: Colors.deepOrange[400],
  //         borderRadius: BorderRadius.circular(16.0),
  //       ),
  //     ),
  //     onDaySelected: _onDaySelected,
  //     onVisibleDaysChanged: _onVisibleDaysChanged,
  //     onCalendarCreated: _onCalendarCreated,
  //   );
  // }

// More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      // holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      rowHeight: 70.0,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
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
            // margin: const EdgeInsets.all(4.0),
            // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            // padding: const EdgeInsets.only(left: 18.0),
            margin: const EdgeInsets.only(top: 4.0),
            padding: const EdgeInsets.only(top: 1.0, left: 18.0),
            width: 100,
            height: 300,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
          // return FadeTransition(
          //   opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
          //   child: Container(
          //     // margin: const EdgeInsets.all(4.0),
          //     // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          //     // padding: const EdgeInsets.only(left: 18.0),
          //     margin: const EdgeInsets.only(top: 4.0),
          //     padding: const EdgeInsets.only(top: 1.0, left: 18.0),
          //     width: 100,
          //     height: 300,
          //     child: Text(
          //       '${date.day}',
          //       style: TextStyle().copyWith(fontSize: 16.0),
          //     ),
          //   ),
          // );
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
        // todayDayBuilder: (context, date, _) {
        //   return Container(
        //     margin: const EdgeInsets.all(4.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     color: Colors.amber[400],
        //     width: 100,
        //     height: 300,
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0),
        //     ),
        //   );
        // },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                // right: 1,
                bottom: 1,
                // top: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
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
