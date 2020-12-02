import 'dart:convert';

import '../views/welcome_page.dart';
import 'package:get/get.dart';

import '../models/profile.dart';

import '../models/signup.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/login.dart';

class RemoteServices {
  static var baseURL = 'http://13.232.255.84:8090/v1/api';
  static var client = http.Client();
  static var header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  var box = Hive.box('fame_pocket');

  void logout() {
    box.clear();
    Get.offAll(WelcomePage());
  }

  static Future<Login> login(username, empid, password) async {
    var response = await client.post(
      '$baseURL/user/login',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'userName': username,
          'empId': empid,
          'password': password,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return loginFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<Signup> signup(
    username,
    empid,
    password,
    mobile,
    fullname,
    email,
    companyname,
  ) async {
    var response = await client.post(
      '$baseURL/user/signup',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'userName': username,
          'empId': empid,
          'password': password,
          'mobileNo': mobile,
          'fullName': fullname,
          'emailId': email,
          'companyName': companyname,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return signupFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<Profile> getEmpDetails() async {
    var response = await client.post(
      '$baseURL/user/emp_details',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid'),
          'companyId': box.get('companyid'),
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return profileFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
