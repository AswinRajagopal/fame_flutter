// To parse this JSON data, do
//
//     final employeeNotations = employeeNotationsFromJson(jsonString);

import 'dart:convert';

EmployeeNotations employeeNotationsFromJson(String str) =>
    EmployeeNotations.fromJson(
      json.decode(str),
    );

String employeeNotationsToJson(EmployeeNotations data) => json.encode(
      data.toJson(),
    );

class EmployeeNotations {
  EmployeeNotations({
    this.success,
    this.msg,
    this.empdetailsList,
    this.empdetailsListChecked,
    this.empDailyAttView,
    this.designationsList,
    this.attendanceNotations,
  });

  bool success;
  dynamic msg;
  dynamic empdetailsList;
  dynamic empdetailsListChecked;
  List<EmpDailyAttView> empDailyAttView;
  List<DesignationsList> designationsList;
  List<AttendanceNotation> attendanceNotations;

  factory EmployeeNotations.fromJson(Map<String, dynamic> json) =>
      EmployeeNotations(
        success: json['success'],
        msg: json['msg'],
        empdetailsList: json['empdetailsList'],
        empdetailsListChecked: json['empdetailsListChecked'],
        empDailyAttView: json['empDailyAttView'] == null
            ? null
            : List<EmpDailyAttView>.from(
                json['empDailyAttView'].map(
                  (x) => EmpDailyAttView.fromJson(x),
                ),
              ),
        designationsList: json['designationsList'] == null
            ? null
            : List<DesignationsList>.from(
                json['designationsList'].map(
                  (x) => DesignationsList.fromJson(x),
                ),
              ),
        attendanceNotations: json['attendance_notations'] == null
            ? null
            : List<AttendanceNotation>.from(
                json['attendance_notations'].map(
                  (x) => AttendanceNotation.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'empdetailsList': empdetailsList,
        'empdetailsListChecked': empdetailsListChecked,
        'empDailyAttView': List<dynamic>.from(
          empDailyAttView.map(
            (x) => x.toJson(),
          ),
        ),
        'designationsList': List<dynamic>.from(
          designationsList.map(
            (x) => x.toJson(),
          ),
        ),
        'attendance_notations': List<dynamic>.from(
          attendanceNotations.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class AttendanceNotation {
  AttendanceNotation({
    this.id,
    this.notation,
    this.alias,
    this.status,
  });

  String id;
  String notation;
  String alias;
  bool status;

  factory AttendanceNotation.fromJson(Map<String, dynamic> json) =>
      AttendanceNotation(
        id: json['id'],
        notation: json['notation'],
        alias: json['alias'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'notation': notation,
        'alias': alias,
        'status': status,
      };
}

class DesignationsList {
  DesignationsList({
    this.designId,
    this.design,
  });

  String designId;
  String design;

  factory DesignationsList.fromJson(Map<String, dynamic> json) =>
      DesignationsList(
        designId: json['designId'],
        design: json['design'],
      );

  Map<String, dynamic> toJson() => {
        'designId': designId,
        'design': design,
      };
}

class EmpDailyAttView {
  EmpDailyAttView({
    this.empId,
    this.checkInDateTime,
    this.checkOutDateTime,
    this.checkInLatitude,
    this.attendanceAlias,
    this.id,
    this.status,
    this.overTime,
    this.name,
    this.address,
    this.createdDateTime,
    this.companyId,
    this.createdBy,
    this.roleId,
    this.shift,
    this.designation,
    this.shiftStartTime,
    this.shiftEndTime,
    this.sitePostedTo,
    this.emailId,
    this.gender,
    this.phone,
    this.dob,
    this.doj,
    this.area,
    this.isActive,
    this.modifiedBy,
    this.modifiedDateTime,
    this.lt,
  });

  String empId;
  dynamic checkInDateTime;
  dynamic checkOutDateTime;
  dynamic checkInLatitude;
  dynamic attendanceAlias;
  dynamic id;
  dynamic status;
  dynamic overTime;
  String name;
  String address;
  DateTime createdDateTime;
  String companyId;
  String createdBy;
  String roleId;
  String shift;
  int designation;
  String shiftStartTime;
  String shiftEndTime;
  String sitePostedTo;
  String emailId;
  String gender;
  String phone;
  DateTime dob;
  DateTime doj;
  String area;
  String isActive;
  dynamic modifiedBy;
  dynamic modifiedDateTime;
  dynamic lt;

  factory EmpDailyAttView.fromJson(Map<String, dynamic> json) =>
      EmpDailyAttView(
        empId: json['empId'],
        checkInDateTime: json['checkInDateTime'],
        checkOutDateTime: json['checkOutDateTime'],
        checkInLatitude: json['checkInLatitude'],
        attendanceAlias: json['attendanceAlias'],
        id: json['id'],
        status: json['status'],
        overTime: json['overTime'],
        name: json['name'],
        address: json['address'],
        createdDateTime: DateTime.parse(json['createdDateTime']),
        companyId: json['companyId'],
        createdBy: json['createdBy'],
        roleId: json['roleId'],
        shift: json['shift'],
        designation: json['designation'],
        shiftStartTime: json['shiftStartTime'],
        shiftEndTime: json['shiftEndTime'],
        sitePostedTo: json['sitePostedTo'],
        emailId: json['emailId'],
        gender: json['gender'],
        phone: json['phone'],
        dob: DateTime.parse(json['dob']),
        doj: DateTime.parse(json['doj']),
        area: json['area'],
        isActive: json['isActive'],
        modifiedBy: json['modifiedBy'],
        modifiedDateTime: json['modifiedDateTime'],
        lt: json['lt'],
      );

  Map<String, dynamic> toJson() => {
        'empId': empId,
        'checkInDateTime': checkInDateTime,
        'checkOutDateTime': checkOutDateTime,
        'checkInLatitude': checkInLatitude,
        'attendanceAlias': attendanceAlias,
        'id': id,
        'status': status,
        'overTime': overTime,
        'name': name,
        'address': address,
        'createdDateTime': createdDateTime.toIso8601String(),
        'companyId': companyId,
        'createdBy': createdBy,
        'roleId': roleId,
        'shift': shift,
        'designation': designation,
        'shiftStartTime': shiftStartTime,
        'shiftEndTime': shiftEndTime,
        'sitePostedTo': sitePostedTo,
        'emailId': emailId,
        'gender': gender,
        'phone': phone,
        'dob': dob.toIso8601String(),
        'doj': doj.toIso8601String(),
        'area': area,
        'isActive': isActive,
        'modifiedBy': modifiedBy,
        'modifiedDateTime': modifiedDateTime,
        'lt': lt,
      };
}
