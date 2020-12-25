// To parse this JSON data, do
//
//     final support = supportFromJson(jsonString);

import 'dart:convert';

Support supportFromJson(String str) => Support.fromJson(json.decode(str));

String supportToJson(Support data) => json.encode(data.toJson());

class Support {
  Support({
    this.success,
    this.support,
    this.msg,
  });

  bool success;
  SupportClass support;
  dynamic msg;

  factory Support.fromJson(Map<String, dynamic> json) => Support(
        success: json['success'],
        support: SupportClass.fromJson(json['support']),
        msg: json['msg'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'support': support.toJson(),
        'msg': msg,
      };
}

class SupportClass {
  SupportClass({
    this.email,
    this.companyId,
    this.phone,
    this.supportId,
    this.whatsapp,
    this.url,
  });

  String email;
  String companyId;
  String phone;
  String supportId;
  String whatsapp;
  String url;

  factory SupportClass.fromJson(Map<String, dynamic> json) => SupportClass(
        email: json['email'],
        companyId: json['companyId'],
        phone: json['phone'],
        supportId: json['supportId'],
        whatsapp: json['whatsapp'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'companyId': companyId,
        'phone': phone,
        'supportId': supportId,
        'whatsapp': whatsapp,
        'url': url,
      };
}
