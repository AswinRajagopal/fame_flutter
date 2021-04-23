// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.msg,
    this.loginDetails,
    this.appFeature,
    this.companyDetails,
    this.valid,
  });

  dynamic msg;
  LoginDetails loginDetails;
  AppFeature appFeature;
  CompanyDetails companyDetails;
  bool valid;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        msg: json['msg'],
        loginDetails: json['valid'] ? LoginDetails.fromJson(json['loginDetails']) : null,
        appFeature: json['valid'] ? AppFeature.fromJson(json['appFeature']) : null,
        companyDetails: json['valid'] ? CompanyDetails.fromJson(json['companyDetails']) : null,
        valid: json['valid'],
      );

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'loginDetails': valid ? loginDetails.toJson() : null,
        'appFeature': valid ? appFeature.toJson() : null,
        'companyDetails': valid ? companyDetails.toJson() : null,
        'valid': valid,
      };
}

class AppFeature {
  bool attendance;

  bool autoApproval;
  AppFeature({
    this.attendance,
    this.autoApproval,
    this.companyId,
    this.gps,
    this.issueTracking,
    this.checkoutDial,
    this.appFeatureId,
    this.checkinDialTime,
    this.checkoutDialTime,
    this.trackingInterval,
    this.routePlan,
    this.pinMyVisit,
    this.onboarding,
    this.attendanceDaysPermitted,
    this.checkinLocation
  });
  String companyId;
  bool gps;
  bool issueTracking;
  bool checkoutDial;
  int appFeatureId;
  int checkinDialTime;
  int checkoutDialTime;
  int trackingInterval;
  bool onboarding;
  bool routePlan;
  bool pinMyVisit;
  bool checkinLocation;
  int attendanceDaysPermitted;

  factory AppFeature.fromJson(Map<String, dynamic> json) => AppFeature(
        attendance: json['attendance'],
        autoApproval: json['autoApproval'],
        companyId: json['companyId'],
        gps: json['gps'],
        issueTracking: json['issueTracking'],
        checkoutDial: json['checkoutDial'],
        appFeatureId: json['appFeatureId'],
        checkinDialTime: json['checkinDialTime'],
        checkoutDialTime: json['checkoutDialTime'],
        trackingInterval: json['trackingInterval'],
        routePlan: json['routePlan'],
        pinMyVisit: json['pinMyVisit'],
        onboarding: json['onboarding'],
        attendanceDaysPermitted: json['attendanceDaysPermitted'],
        checkinLocation: json['checkinLocation'],
      );

  Map<String, dynamic> toJson() => {
        'attendance': attendance,
        'autoApproval': autoApproval,
        'companyId': companyId,
        'gps': gps,
        'issueTracking': issueTracking,
        'checkoutDial': checkoutDial,
        'appFeatureId': appFeatureId,
        'checkinDialTime': checkinDialTime,
        'checkoutDialTime': checkoutDialTime,
        'trackingInterval': trackingInterval,
        'routePlan': routePlan,
        'pinMyVisit': pinMyVisit,
        'onboarding': onboarding,
        'checkinLocation': checkinLocation,
        'attendanceDaysPermitted': attendanceDaysPermitted,
      };
}

class CompanyDetails {
  CompanyDetails({
    this.companyId,
    this.companyName,
    this.createdDateTime,
    this.updatedDateTime,
    this.active,
    this.dbname,
  });

  String companyId;
  String companyName;
  String createdDateTime;
  dynamic updatedDateTime;
  bool active;
  String dbname;

  factory CompanyDetails.fromJson(Map<String, dynamic> json) => CompanyDetails(
        companyId: json['companyId'],
        companyName: json['companyName'],
        createdDateTime: json['createdDateTime'],
        updatedDateTime: json['updatedDateTime'],
        active: json['active'],
        dbname: json['dbname'],
      );

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'companyName': companyName,
        'createdDateTime': createdDateTime,
        'updatedDateTime': updatedDateTime,
        'active': active,
        'dbname': dbname,
      };
}

class LoginDetails {
  LoginDetails({
    this.id,
    this.empId,
    this.userName,
    this.password,
    this.createdDateTime,
    this.updatedDateTime,
    this.emailId,
    this.companyId,
    this.clientId,
    this.role,
    this.pushCode,
    this.rated,
  });

  String id;
  String empId;
  String userName;
  String password;
  String createdDateTime;
  dynamic updatedDateTime;
  String emailId;
  String companyId;
  dynamic clientId;
  String role;
  String pushCode;
  bool rated;

  factory LoginDetails.fromJson(Map<String, dynamic> json) => LoginDetails(
        id: json['id'],
        empId: json['empId'],
        userName: json['userName'],
        password: json['password'],
        createdDateTime: json['createdDateTime'],
        updatedDateTime: json['updatedDateTime'],
        emailId: json['emailId'],
        companyId: json['companyId'],
        clientId: json['clientId'],
        role: json['role'],
        pushCode: json['pushCode'],
        rated: json['rated'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'empId': empId,
        'userName': userName,
        'password': password,
        'createdDateTime': createdDateTime,
        'updatedDateTime': updatedDateTime,
        'emailId': emailId,
        'companyId': companyId,
        'clientId': clientId,
        'role': role,
        'pushCode': pushCode,
        'rated': rated,
      };
}
