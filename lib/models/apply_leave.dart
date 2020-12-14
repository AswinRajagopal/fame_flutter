// To parse this JSON data, do
//
//     final applyLeave = applyLeaveFromJson(jsonString);

import 'dart:convert';

ApplyLeave applyLeaveFromJson(String str) =>
    ApplyLeave.fromJson(json.decode(str));

String applyLeaveToJson(ApplyLeave data) => json.encode(data.toJson());

class ApplyLeave {
  ApplyLeave({
    this.success,
    this.msg,
  });

  bool success;
  dynamic msg;

  factory ApplyLeave.fromJson(Map<String, dynamic> json) => ApplyLeave(
        success: json['success'],
        msg: json['msg'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
      };
}
