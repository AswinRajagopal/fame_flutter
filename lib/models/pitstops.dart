// To parse this JSON data, do
//
//     final pitstops = pitstopsFromJson(jsonString);

import 'dart:convert';

Pitstops pitstopsFromJson(String str) => Pitstops.fromJson(json.decode(str));

String pitstopsToJson(Pitstops data) => json.encode(data.toJson());

class Pitstops {
  Pitstops({
    this.success,
    this.msg,
    this.pitstopList,
  });

  bool success;
  dynamic msg;
  List<PitstopList> pitstopList;

  factory Pitstops.fromJson(Map<String, dynamic> json) => Pitstops(
        success: json['success'],
        msg: json['msg'],
        pitstopList: json['pitstopList'] == null ? null : List<PitstopList>.from(json['pitstopList'].map((x) => PitstopList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'pitstopList': List<dynamic>.from(pitstopList.map((x) => x.toJson())),
      };
}

class PitstopList {
  PitstopList({
    this.empRemarks,
    this.lng,
    this.clientId,
    this.clientName,
    this.adminRemarks,
    this.routePlanId,
    this.updatedOn,
    this.checkinLat,
    this.checkinLng,
    this.pitstopId,
    this.lat,
    this.attachment,
  });

  dynamic empRemarks;
  String lng;
  String clientId;
  String clientName;
  dynamic adminRemarks;
  String routePlanId;
  dynamic updatedOn;
  dynamic checkinLat;
  dynamic checkinLng;
  int pitstopId;
  String lat;
  bool attachment;

  factory PitstopList.fromJson(Map<String, dynamic> json) => PitstopList(
        empRemarks: json['empRemarks'],
        lng: json['lng'],
        clientId: json['clientId'],
        clientName: json['clientName'],
        adminRemarks: json['adminRemarks'],
        routePlanId: json['routePlanId'],
        updatedOn: json['updatedOn'],
        checkinLat: json['checkinLat'],
        checkinLng: json['checkinLng'],
        pitstopId: json['pitstopId'],
        lat: json['lat'],
        attachment: json['attachment'],
      );

  Map<String, dynamic> toJson() => {
        'empRemarks': empRemarks,
        'lng': lng,
        'clientId': clientId,
        'clientName': clientName,
        'adminRemarks': adminRemarks,
        'routePlanId': routePlanId,
        'updatedOn': updatedOn,
        'checkinLat': checkinLat,
        'checkinLng': checkinLng,
        'pitstopId': pitstopId,
        'lat': lat,
        'attachment': attachment,
      };
}
