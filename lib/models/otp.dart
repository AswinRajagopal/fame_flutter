// To parse this JSON data, do
//
//     final otp = otpFromJson(jsonString);

import 'dart:convert';

Otp otpFromJson(String str) => Otp.fromJson(json.decode(str));

String otpToJson(Otp data) => json.encode(data.toJson());

class Otp {
  Otp({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory Otp.fromJson(Map<String, dynamic> json) => Otp(
        success: json['success'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
