// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

Attendance attendanceFromJson(String str) =>
    Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  Attendance({
    this.success,
    this.message,
    this.clientsandManpowerArrList,
    this.companyDetailsCentralDb,
  });

  bool success;
  dynamic message;
  List<ClientsandManpowerArrList> clientsandManpowerArrList;
  CompanyDetailsCentralDb companyDetailsCentralDb;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        success: json['success'],
        message: json['message'],
        clientsandManpowerArrList: List<ClientsandManpowerArrList>.from(
          json['clientsandManpowerArrList'].map(
            (x) => ClientsandManpowerArrList.fromJson(x),
          ),
        ),
        companyDetailsCentralDb: CompanyDetailsCentralDb.fromJson(
          json['companyDetails_centralDB'],
        ),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'clientsandManpowerArrList': List<dynamic>.from(
          clientsandManpowerArrList.map(
            (x) => x.toJson(),
          ),
        ),
        'companyDetails_centralDB': companyDetailsCentralDb.toJson(),
      };
}

class ClientsandManpowerArrList {
  ClientsandManpowerArrList({
    this.client,
    this.clientManpowerList,
  });

  Client client;
  List<ClientManpowerList> clientManpowerList;

  factory ClientsandManpowerArrList.fromJson(Map<String, dynamic> json) =>
      ClientsandManpowerArrList(
        client: Client.fromJson(json['client']),
        clientManpowerList: List<ClientManpowerList>.from(
          json['clientManpowerList'].map(
            (x) => ClientManpowerList.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'client': client.toJson(),
        'clientManpowerList': List<dynamic>.from(
          clientManpowerList.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Client {
  Client({
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

  factory Client.fromJson(Map<String, dynamic> json) => Client(
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

class ClientManpowerList {
  ClientManpowerList({
    this.createdOn,
    this.createdBy,
    this.design,
    this.clientId,
    this.shift,
    this.shiftStartTime,
    this.shiftEndTime,
    this.qty,
    this.modifiedBy,
    this.contractId,
    this.modifiedOn,
  });

  dynamic createdOn;
  dynamic createdBy;
  String design;
  String clientId;
  String shift;
  String shiftStartTime;
  String shiftEndTime;
  String qty;
  dynamic modifiedBy;
  dynamic contractId;
  dynamic modifiedOn;

  factory ClientManpowerList.fromJson(Map<String, dynamic> json) =>
      ClientManpowerList(
        createdOn: json['createdOn'],
        createdBy: json['createdBy'],
        design: json['design'],
        clientId: json['clientId'],
        shift: json['shift'],
        shiftStartTime: json['shiftStartTime'],
        shiftEndTime: json['shiftEndTime'],
        qty: json['qty'],
        modifiedBy: json['modifiedBy'],
        contractId: json['contractID'],
        modifiedOn: json['modifiedOn'],
      );

  Map<String, dynamic> toJson() => {
        'createdOn': createdOn,
        'createdBy': createdBy,
        'design': design,
        'clientId': clientId,
        'shift': shift,
        'shiftStartTime': shiftStartTime,
        'shiftEndTime': shiftEndTime,
        'qty': qty,
        'modifiedBy': modifiedBy,
        'contractID': contractId,
        'modifiedOn': modifiedOn,
      };
}

class CompanyDetailsCentralDb {
  CompanyDetailsCentralDb({
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

  factory CompanyDetailsCentralDb.fromJson(Map<String, dynamic> json) =>
      CompanyDetailsCentralDb(
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
