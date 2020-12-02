// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.success,
    this.msg,
    this.empdetails,
  });

  bool success;
  dynamic msg;
  Empdetails empdetails;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        success: json['success'],
        msg: json['msg'],
        empdetails: Empdetails.fromJson(json['empdetails']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'empdetails': empdetails.toJson(),
      };
}

class Empdetails {
  Empdetails({
    this.sosNumber,
    this.empStatus,
    this.gpsTracking,
    this.name,
    this.address,
    this.createdDateTime,
    this.gender,
    this.phone,
    this.dob,
    this.doj,
    this.area,
    this.isActive,
    this.modifiedBy,
    this.modifiedDateTime,
    this.designation,
    this.roleId,
    this.empId,
    this.companyId,
    this.createdBy,
    this.shift,
    this.shiftStartTime,
    this.shiftEndTime,
    this.sitePostedTo,
    this.emailId,
  });

  String sosNumber;
  int empStatus;
  bool gpsTracking;
  String name;
  String address;
  DateTime createdDateTime;
  String gender;
  String phone;
  DateTime dob;
  DateTime doj;
  String area;
  String isActive;
  dynamic modifiedBy;
  dynamic modifiedDateTime;
  int designation;
  String roleId;
  String empId;
  String companyId;
  String createdBy;
  String shift;
  String shiftStartTime;
  String shiftEndTime;
  String sitePostedTo;
  String emailId;

  factory Empdetails.fromJson(Map<String, dynamic> json) => Empdetails(
        sosNumber: json['sosNumber'],
        empStatus: json['empStatus'],
        gpsTracking: json['gpsTracking'],
        name: json['name'],
        address: json['address'],
        createdDateTime: DateTime.parse(json['createdDateTime']),
        gender: json['gender'],
        phone: json['phone'],
        dob: DateTime.parse(json['dob']),
        doj: DateTime.parse(json['doj']),
        area: json['area'],
        isActive: json['isActive'],
        modifiedBy: json['modifiedBy'],
        modifiedDateTime: json['modifiedDateTime'],
        designation: json['designation'],
        roleId: json['roleId'],
        empId: json['empId'],
        companyId: json['companyId'],
        createdBy: json['createdBy'],
        shift: json['shift'],
        shiftStartTime: json['shiftStartTime'],
        shiftEndTime: json['shiftEndTime'],
        sitePostedTo: json['sitePostedTo'],
        emailId: json['emailId'],
      );

  Map<String, dynamic> toJson() => {
        'sosNumber': sosNumber,
        'empStatus': empStatus,
        'gpsTracking': gpsTracking,
        'name': name,
        'address': address,
        'createdDateTime': createdDateTime.toIso8601String(),
        'gender': gender,
        'phone': phone,
        'dob': dob.toIso8601String(),
        'doj': doj.toIso8601String(),
        'area': area,
        'isActive': isActive,
        'modifiedBy': modifiedBy,
        'modifiedDateTime': modifiedDateTime,
        'designation': designation,
        'roleId': roleId,
        'empId': empId,
        'companyId': companyId,
        'createdBy': createdBy,
        'shift': shift,
        'shiftStartTime': shiftStartTime,
        'shiftEndTime': shiftEndTime,
        'sitePostedTo': sitePostedTo,
        'emailId': emailId,
      };
}
