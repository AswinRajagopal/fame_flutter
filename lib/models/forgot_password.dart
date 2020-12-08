// To parse this JSON data, do
//
//     final forgotPassword = forgotPasswordFromJson(jsonString);

import 'dart:convert';

ForgotPassword forgotPasswordFromJson(String str) =>
    ForgotPassword.fromJson(json.decode(str));

String forgotPasswordToJson(ForgotPassword data) => json.encode(data.toJson());

class ForgotPassword {
  ForgotPassword({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory ForgotPassword.fromJson(Map<String, dynamic> json) => ForgotPassword(
        success: json['success'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
