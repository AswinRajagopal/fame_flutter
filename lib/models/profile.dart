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
    this.empDetails,
    this.loginDetails,
    this.profileImage,
  });

  bool success;
  dynamic msg;
  EmpDetails empDetails;
  LoginDetails loginDetails;
  ProfileImage profileImage;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        success: json['success'],
        msg: json['msg'],
        empDetails: EmpDetails.fromJson(json['empDetails']),
        loginDetails: LoginDetails.fromJson(json['loginDetails']),
        profileImage: json['profileImage'] == null ? null : ProfileImage.fromJson(json['profileImage']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'empDetails': empDetails.toJson(),
        'loginDetails': loginDetails.toJson(),
        'profileImage': profileImage.toJson(),
      };
}

class EmpDetails {
  EmpDetails({
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

  dynamic sosNumber;
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
  dynamic isActive;
  dynamic modifiedBy;
  dynamic modifiedDateTime;
  DateTime createdDateTime;

  factory EmpDetails.fromJson(Map<String, dynamic> json) => EmpDetails(
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

class ProfileImage {
  ProfileImage({
    this.empId,
    this.profileImageId,
    this.image,
    this.createdOn,
    this.status,
  });

  String empId;
  String profileImageId;
  String image;
  DateTime createdOn;
  bool status;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        empId: json['emp_id'],
        profileImageId: json['profile_image_id'],
        image: json['image'],
        createdOn: DateTime.parse(json['created_on']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'emp_id': empId,
        'profile_image_id': profileImageId,
        'image': image,
        'created_on': createdOn.toIso8601String(),
        'status': status,
      };
}
