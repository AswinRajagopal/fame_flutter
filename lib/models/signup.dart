// To parse this JSON data, do
//
//     final signup = signupFromJson(jsonString);

import 'dart:convert';

Signup signupFromJson(String str) => Signup.fromJson(json.decode(str));

String signupToJson(Signup data) => json.encode(data.toJson());

class Signup {
  Signup({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory Signup.fromJson(Map<String, dynamic> json) => Signup(
        success: json['success'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
