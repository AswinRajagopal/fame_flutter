// To parse this JSON data, do
//
//     final saveRPlan = saveRPlanFromJson(jsonString);

import 'dart:convert';

SaveRPlan saveRPlanFromJson(String str) => SaveRPlan.fromJson(json.decode(str));

String saveRPlanToJson(SaveRPlan data) => json.encode(data.toJson());

class SaveRPlan {
  SaveRPlan({
    this.success,
    this.message,
  });

  bool success;
  dynamic message;

  factory SaveRPlan.fromJson(Map<String, dynamic> json) => SaveRPlan(
        success: json['success'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
