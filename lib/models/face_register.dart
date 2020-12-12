// To parse this JSON data, do
//
//     final faceReg = faceRegFromJson(jsonString);

import 'dart:convert';

FaceReg faceRegFromJson(String str) => FaceReg.fromJson(json.decode(str));

String faceRegToJson(FaceReg data) => json.encode(data.toJson());

class FaceReg {
  FaceReg({
    this.success,
    this.msg,
    this.response,
  });

  bool success;
  dynamic msg;
  String response;

  factory FaceReg.fromJson(Map<String, dynamic> json) => FaceReg(
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
