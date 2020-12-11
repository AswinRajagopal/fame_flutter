import 'dart:convert';
import 'dart:io';

import 'dart:developer' as developer;

import 'package:dio/dio.dart' as mydio;
import '../models/db_calendar.dart';
import '../models/emp_r_plan.dart';
import '../models/dashboard.dart';

import '../models/checkin.dart';

import '../models/forgot_password.dart';

import '../models/otp.dart';

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
  static var accessKey = 'diyos2020';

  void logout() async {
    developer.log('logout');
    await box.clear();
    await box.deleteAll([
      'id',
      'empid',
      'email',
      'role',
      'companyid',
      'companyname',
      'userName',
      'appFeature',
      'shift',
      'clientId',
    ]);
    // ignore: unawaited_futures
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

  static Future<Otp> otpverify(mobile, otp) async {
    var response = await client.post(
      '$baseURL/user/verify_regotp',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'mobile': mobile,
          'otp': otp,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return otpFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<ForgotPassword> forgorPassword(email) async {
    var response = await client.post(
      '$baseURL/user/forgot_pass',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'emailId': email,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return forgotPasswordFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<Checkin> checkinProcess(File imageFile) async {
    // print('companyid: ${box.get('companyid')}');
    // print('empid: ${box.get('empid')}');
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'companyID': box.get('companyid'),
      'empID': box.get('empid'),
      // 'companyID': '6',
      // 'empID': 'dem000008',
      'access_key': accessKey,
      'image': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: 'image.jpg',
      ),
    });
    var response = await dio.post(
      '$baseURL/face_rec/verify',
      data: formData,
    );

    // print(response.data);
    // developer.log('jsonString: ${response.data.toString()}');
    if (response.statusCode == 200) {
      var jsonString = response.data;
      return checkinFromJson(jsonEncode(jsonString));
    } else {
      return null;
    }
  }

  Future<Dashboard> getDashboardDetails() async {
    // print('getDashboardDetails');
    // print(box.get('empid'));
    // print(box.get('companyid'));
    var response = await client.post(
      '$baseURL/attendance/dashboard_flut',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'pushCode': '',
        },
      ),
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print(response.body.runtimeType);
      // developer.log('jsonString: ${jsonString.toString()}');
      return dashboardFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<EmpRPlan> getEmprPlan() async {
    // print('getEmprPlan');
    // print(box.get('empid'));
    // print(box.get('companyid'));
    // print(box.get('role'));
    var response = await client.post(
      '$baseURL/location/get_emp_rplan',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'roleId': box.get('role').toString(),
          'pending': true,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return empRPlanFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<DbCalendar> getEmpCalendar(month) async {
    // print('getEmpCalendar');
    // print(box.get('empid'));
    // print(box.get('companyid'));
    var response = await client.post(
      '$baseURL/attendance/emp_calendar',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'month': month,
        },
      ),
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print(response.body.runtimeType);
      // developer.log('jsonString: ${jsonString.toString()}');
      return dbCalendarFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future checkin(lat, lng, address) async {
    var response = await client.post(
      '$baseURL/attendance/checkin',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'shift': box.get('shift').toString(),
          'clientId': box.get('clientId').toString(),
          'lat': lat.toString(),
          'lng': lng.toString(),
          'address': address.toString(),
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future checkout(lat, lng, address) async {
    var response = await client.post(
      '$baseURL/attendance/checkout',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'shift': box.get('shift').toString(),
          'clientId': box.get('clientId').toString(),
          'lat': lat.toString(),
          'lng': lng.toString(),
          'address': address.toString(),
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
