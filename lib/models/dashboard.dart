// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    this.success,
    this.clientData,
    this.msg,
    this.empdetails,
    this.psCount,
    this.empActivities,
    this.dailyAttendance,
  });

  bool success;
  ClientData clientData;
  dynamic msg;
  Empdetails empdetails;
  PsCount psCount;
  List<EmpActivity> empActivities;
  DailyAttendance dailyAttendance;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        success: json['success'],
        clientData: ClientData.fromJson(json['clientData']),
        msg: json['msg'],
        empdetails: Empdetails.fromJson(json['empdetails']),
        psCount: PsCount.fromJson(json['psCount']),
        empActivities: List<EmpActivity>.from(
            json['empActivities'].map((x) => EmpActivity.fromJson(x))),
        dailyAttendance: DailyAttendance.fromJson(json['dailyAttendance']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'clientData': clientData.toJson(),
        'msg': msg,
        'empdetails': empdetails.toJson(),
        'psCount': psCount.toJson(),
        'empActivities':
            List<dynamic>.from(empActivities.map((x) => x.toJson())),
        'dailyAttendance': dailyAttendance.toJson(),
      };
}

class ClientData {
  ClientData({
    this.name,
    this.phone,
    this.emailId,
    this.address,
    this.isActive,
    this.otPayout,
    this.faceApi,
    this.latitude,
    this.longitude,
    this.maxCheckinDistance,
    this.unitIncharge,
    this.createdDateTime,
    this.updatedDateTime,
    this.id,
  });

  String name;
  String phone;
  String emailId;
  String address;
  bool isActive;
  bool otPayout;
  int faceApi;
  String latitude;
  String longitude;
  String maxCheckinDistance;
  String unitIncharge;
  dynamic createdDateTime;
  dynamic updatedDateTime;
  String id;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        name: json['name'],
        phone: json['phone'],
        emailId: json['emailId'],
        address: json['address'],
        isActive: json['isActive'],
        otPayout: json['otPayout'],
        faceApi: json['faceApi'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        maxCheckinDistance: json['maxCheckinDistance'],
        unitIncharge: json['unitIncharge'],
        createdDateTime: json['createdDateTime'],
        updatedDateTime: json['updatedDateTime'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'emailId': emailId,
        'address': address,
        'isActive': isActive,
        'otPayout': otPayout,
        'faceApi': faceApi,
        'latitude': latitude,
        'longitude': longitude,
        'maxCheckinDistance': maxCheckinDistance,
        'unitIncharge': unitIncharge,
        'createdDateTime': createdDateTime,
        'updatedDateTime': updatedDateTime,
        'id': id,
      };
}

class DailyAttendance {
  DailyAttendance({
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

  dynamic overTime;
  String createdBy;
  String checkInLongitude;
  dynamic modifiedBy;
  String checkinAddress;
  dynamic checkoutAddress;
  String remarks;
  String empId;
  DateTime checkInDateTime;
  dynamic checkOutLongitude;
  String clientId;
  dynamic checkOutDateTime;
  String checkInLatitude;
  String shift;
  dynamic attendanceAlias;
  dynamic checkOutLatitude;
  DateTime updatedDateTime;
  String id;
  DateTime createdDateTime;
  int status;
  int month;
  dynamic lt;

  factory DailyAttendance.fromJson(Map<String, dynamic> json) =>
      DailyAttendance(
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
        checkOutDateTime: json['checkOutDateTime'],
        checkInLatitude: json['checkInLatitude'],
        shift: json['shift'],
        attendanceAlias: json['attendanceAlias'],
        checkOutLatitude: json['checkOutLatitude'],
        updatedDateTime: DateTime.parse(json['updatedDateTime']),
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
        'checkOutDateTime': checkOutDateTime,
        'checkInLatitude': checkInLatitude,
        'shift': shift,
        'attendanceAlias': attendanceAlias,
        'checkOutLatitude': checkOutLatitude,
        'updatedDateTime': updatedDateTime.toIso8601String(),
        'id': id,
        'createdDateTime': createdDateTime.toIso8601String(),
        'status': status,
        'month': month,
        'lt': lt,
      };
}

class EmpActivity {
  EmpActivity({
    this.activityId,
    this.activity,
    this.empId,
    this.createdBy,
    this.createdOn,
  });

  int activityId;
  String activity;
  String empId;
  String createdBy;
  DateTime createdOn;

  factory EmpActivity.fromJson(Map<String, dynamic> json) => EmpActivity(
        activityId: json['activityId'],
        activity: json['activity'],
        empId: json['empId'],
        createdBy: json['createdBy'],
        createdOn: DateTime.parse(json['createdOn']),
      );

  Map<String, dynamic> toJson() => {
        'activityId': activityId,
        'activity': activity,
        'empId': empId,
        'createdBy': createdBy,
        'createdOn': createdOn.toIso8601String(),
      };
}

class Empdetails {
  Empdetails({
    this.sosNumber,
    this.empStatus,
    this.gpsTracking,
    this.name,
    this.address,
    this.gender,
    this.phone,
    this.empId,
    this.companyId,
    this.createdBy,
    this.roleId,
    this.shift,
    this.designation,
    this.shiftStartTime,
    this.shiftEndTime,
    this.sitePostedTo,
    this.emailId,
    this.dob,
    this.doj,
    this.area,
    this.isActive,
    this.modifiedBy,
    this.modifiedDateTime,
    this.createdDateTime,
  });

  String sosNumber;
  int empStatus;
  bool gpsTracking;
  String name;
  String address;
  String gender;
  String phone;
  String empId;
  String companyId;
  String createdBy;
  String roleId;
  String shift;
  int designation;
  String shiftStartTime;
  String shiftEndTime;
  String sitePostedTo;
  String emailId;
  DateTime dob;
  DateTime doj;
  String area;
  String isActive;
  dynamic modifiedBy;
  dynamic modifiedDateTime;
  DateTime createdDateTime;

  factory Empdetails.fromJson(Map<String, dynamic> json) => Empdetails(
        sosNumber: json['sosNumber'],
        empStatus: json['empStatus'],
        gpsTracking: json['gpsTracking'],
        name: json['name'],
        address: json['address'],
        gender: json['gender'],
        phone: json['phone'],
        empId: json['empId'],
        companyId: json['companyId'],
        createdBy: json['createdBy'],
        roleId: json['roleId'],
        shift: json['shift'],
        designation: json['designation'],
        shiftStartTime: json['shiftStartTime'],
        shiftEndTime: json['shiftEndTime'],
        sitePostedTo: json['sitePostedTo'],
        emailId: json['emailId'],
        dob: DateTime.parse(json['dob']),
        doj: DateTime.parse(json['doj']),
        area: json['area'],
        isActive: json['isActive'],
        modifiedBy: json['modifiedBy'],
        modifiedDateTime: json['modifiedDateTime'],
        createdDateTime: DateTime.parse(json['createdDateTime']),
      );

  Map<String, dynamic> toJson() => {
        'sosNumber': sosNumber,
        'empStatus': empStatus,
        'gpsTracking': gpsTracking,
        'name': name,
        'address': address,
        'gender': gender,
        'phone': phone,
        'empId': empId,
        'companyId': companyId,
        'createdBy': createdBy,
        'roleId': roleId,
        'shift': shift,
        'designation': designation,
        'shiftStartTime': shiftStartTime,
        'shiftEndTime': shiftEndTime,
        'sitePostedTo': sitePostedTo,
        'emailId': emailId,
        'dob': dob.toIso8601String(),
        'doj': doj.toIso8601String(),
        'area': area,
        'isActive': isActive,
        'modifiedBy': modifiedBy,
        'modifiedDateTime': modifiedDateTime,
        'createdDateTime': createdDateTime.toIso8601String(),
      };
}

class PsCount {
  PsCount({
    this.shifts,
    this.present,
    this.absent,
  });

  int shifts;
  int present;
  int absent;

  factory PsCount.fromJson(Map<String, dynamic> json) => PsCount(
        shifts: json['shifts'],
        present: json['present'],
        absent: json['absent'],
      );

  Map<String, dynamic> toJson() => {
        'shifts': shifts,
        'present': present,
        'absent': absent,
      };
}
