// To parse this JSON data, do
//
//     final checkin = checkinFromJson(jsonString);

import 'dart:convert';

Checkin checkinFromJson(String str) => Checkin.fromJson(json.decode(str));

String checkinToJson(Checkin data) => json.encode(data.toJson());

class Checkin {
  Checkin({
    this.success,
    this.msg,
    this.response,
  });

  bool success;
  dynamic msg;
  String response;

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        success: json['success'],
        msg: json['msg'],
        response: json['response'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'response': response,
      };
}
