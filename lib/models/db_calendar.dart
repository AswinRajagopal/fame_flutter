// To parse this JSON data, do
//
//     final dbCalendar = dbCalendarFromJson(jsonString);

import 'dart:convert';

DbCalendar dbCalendarFromJson(String str) =>
    DbCalendar.fromJson(json.decode(str));

String dbCalendarToJson(DbCalendar data) => json.encode(data.toJson());

class DbCalendar {
  DbCalendar({
    this.success,
    this.msg,
    this.calendarView,
    this.attendanceList,
    this.empRosterList,
  });

  bool success;
  dynamic msg;
  CalendarView calendarView;
  List<AttendanceList> attendanceList;
  List<dynamic> empRosterList;

  factory DbCalendar.fromJson(Map<String, dynamic> json) => DbCalendar(
        success: json['success'],
        msg: json['msg'],
        calendarView: CalendarView.fromJson(json['calendarView']),
        attendanceList: List<AttendanceList>.from(
            json['attendanceList'].map((x) => AttendanceList.fromJson(x))),
        empRosterList: List<dynamic>.from(json['empRosterList'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'calendarView': calendarView.toJson(),
        'attendanceList':
            List<dynamic>.from(attendanceList.map((x) => x.toJson())),
        'empRosterList': List<dynamic>.from(empRosterList.map((x) => x)),
      };
}

class AttendanceList {
  AttendanceList({
    this.overTime,
    this.createdBy,
    this.checkInLongitude,
    this.modifiedBy,
    this.checkinAddress,
    this.checkoutAddress,
    this.remarks,
    this.empId,
    this.checkInDateTime,
    this.checkOutLongitude,
    this.clientId,
    this.checkOutDateTime,
    this.checkInLatitude,
    this.shift,
    this.attendanceAlias,
    this.checkOutLatitude,
    this.updatedDateTime,
    this.id,
    this.createdDateTime,
    this.status,
    this.month,
    this.lt,
  });

  String overTime;
  String createdBy;
  String checkInLongitude;
  String modifiedBy;
  String checkinAddress;
  String checkoutAddress;
  String remarks;
  String empId;
  DateTime checkInDateTime;
  String checkOutLongitude;
  String clientId;
  DateTime checkOutDateTime;
  String checkInLatitude;
  String shift;
  String attendanceAlias;
  String checkOutLatitude;
  DateTime updatedDateTime;
  String id;
  DateTime createdDateTime;
  int status;
  int month;
  dynamic lt;

  factory AttendanceList.fromJson(Map<String, dynamic> json) => AttendanceList(
        overTime: json['overTime'],
        createdBy: json['createdBy'],
        checkInLongitude: json['checkInLongitude'],
        modifiedBy: json['modifiedBy'],
        checkinAddress: json['checkinAddress'],
        checkoutAddress: json['checkoutAddress'],
        remarks: json['remarks'],
        empId: json['empId'],
        checkInDateTime: DateTime.parse(json['checkInDateTime']),
        checkOutLongitude: json['checkOutLongitude'],
        clientId: json['clientId'],
        checkOutDateTime: json['checkOutDateTime'] == null
            ? null
            : DateTime.parse(json['checkOutDateTime']),
        checkInLatitude: json['checkInLatitude'],
        shift: json['shift'],
        attendanceAlias: json['attendanceAlias'],
        checkOutLatitude: json['checkOutLatitude'],
        updatedDateTime: json['updatedDateTime'] == null
            ? null
            : DateTime.parse(json['updatedDateTime']),
        id: json['id'],
        createdDateTime: DateTime.parse(json['createdDateTime']),
        status: json['status'],
        month: json['month'],
        lt: json['lt'],
      );

  Map<String, dynamic> toJson() => {
        'overTime': overTime,
        'createdBy': createdBy,
        'checkInLongitude': checkInLongitude,
        'modifiedBy': modifiedBy,
        'checkinAddress': checkinAddress,
        'checkoutAddress': checkoutAddress,
        'remarks': remarks,
        'empId': empId,
        'checkInDateTime': checkInDateTime.toIso8601String(),
        'checkOutLongitude': checkOutLongitude,
        'clientId': clientId,
        'checkOutDateTime': checkOutDateTime == null
            ? null
            : checkOutDateTime.toIso8601String(),
        'checkInLatitude': checkInLatitude,
        'shift': shift,
        'attendanceAlias': attendanceAlias,
        'checkOutLatitude': checkOutLatitude,
        'updatedDateTime':
            updatedDateTime == null ? null : updatedDateTime.toIso8601String(),
        'id': id,
        'createdDateTime': createdDateTime.toIso8601String(),
        'status': status,
        'month': month,
        'lt': lt,
      };
}

class CalendarView {
  CalendarView({
    this.present,
    this.leave,
    this.late,
    this.ot,
  });

  int present;
  int leave;
  int late;
  int ot;

  factory CalendarView.fromJson(Map<String, dynamic> json) => CalendarView(
        present: json['present'],
        leave: json['leave'],
        late: json['late'],
        ot: json['ot'],
      );

  Map<String, dynamic> toJson() => {
        'present': present,
        'leave': leave,
        'late': late,
        'ot': ot,
      };
}
