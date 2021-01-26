import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:developer' as developer;

import 'package:dio/dio.dart' as mydio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/support.dart';
import '../models/transfer_list.dart';
import '../models/attendance.dart';
import '../models/leave_list.dart';
import '../models/save_route_plan.dart';
import '../models/apply_leave.dart';
import '../models/face_register.dart';
import '../models/db_calendar.dart';
import '../models/emp_r_plan.dart';
import '../models/dashboard.dart';

import '../models/checkin.dart';

import '../models/forgot_password.dart';

import '../models/otp.dart';

import '../views/welcome_page.dart';
import 'package:get/get.dart';

import '../models/signup.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/login.dart';
import 'package:battery/battery.dart';

class RemoteServices {
  // static var baseURL = 'http://13.232.255.84:8090/v1/api';
  static var baseURL = 'http://52.66.61.207:8090/v1/api';
  static var client = http.Client();
  static var header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  var box = Hive.box('fame_pocket');
  static var accessKey = 'diyos2020';
  final FirebaseMessaging _fbm = FirebaseMessaging();
  StreamSubscription getPositionSubscription;

  Future<String> setFirebaseNotification() async {
    var pushCode = '';
    await _fbm.setAutoInitEnabled(false);
    await _fbm.getToken().then((String _deviceToken) async {
      print('_deviceToken');
      print(_deviceToken);
      if (_deviceToken != null) {
        pushCode = _deviceToken;
      }
    });
    _fbm.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );
    _fbm.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print('Settings registered: $settings');
      },
    );
    // _firebaseMessaging.autoInitEnabled().then((value) {
    //   print('auto Init - $value');
    // });
    return pushCode;
  }

  void logout() async {
    await _fbm.deleteInstanceID();
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
    empNo,
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
          'empNo': empNo,
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

  Future getEmpDetails() async {
    print('getEmpDetails');
    print(box.get('empid'));
    print(box.get('companyid'));
    var response = await client.post(
      '$baseURL/user/profile',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid'),
          'companyId': box.get('companyid'),
        },
      ),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // return profileFromJson(jsonString);
      return jsonDecode(jsonString);
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

  Future forgotOtpVerify(email, otp) async {
    var response = await client.post(
      '$baseURL/user/verify_otp',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'emailId': email,
          'otp': otp,
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
    print('getDashboardDetails');
    print(box.get('empid'));
    print(box.get('companyid'));
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
      print(response.body.runtimeType);
      // print(response.body);
      print(jsonDecode(response.body)['empdetails']);
      // developer.log('jsonString: ${jsonString.toString()}');
      return dashboardFromJson(jsonString);
      // return jsonDecode(response.body);
    } else {
      //show error message
      return null;
    }
  }

  Future getDbDetails() async {
    var pushCode = await setFirebaseNotification();
    // print('getDashboardDetails');
    // print(box.get('empid'));
    print(box.get('companyid'));
    var response = await client.post(
      '$baseURL/attendance/dashboard_flut',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'pushCode': pushCode,
        },
      ),
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print(response.body.runtimeType);
      // print(response.body);
      // print(jsonDecode(response.body)['empdetails']);
      // developer.log('jsonString: ${jsonString.toString()}');
      return jsonDecode(jsonString);
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

  Future getEmpCalendarNew(month) async {
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
      return json.decode(jsonString);
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

  Future<FaceReg> registerFace(File imageFile, endPoint) async {
    // print('companyid: ${box.get('companyid')}');
    // print('empid: ${box.get('empid')}');
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'companyID': box.get('companyid'),
      'client_ID': box.get('empid'),
      'name': box.get('empName'),
      'access_key': accessKey,
      'source': 'app',
      'endPoint': endPoint,
      'image1': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: 'image.jpg',
      ),
    });
    var response = await dio.post(
      '$baseURL/face_rec/register',
      data: formData,
    );

    // print(response.data);
    // developer.log('jsonString: ${response.data.toString()}');
    if (response.statusCode == 200) {
      var jsonString = response.data;
      return faceRegFromJson(jsonEncode(jsonString));
    } else {
      return null;
    }
  }

  Future registerImage(empId, companyId, image) async {
    var response = await client.post(
      '$baseURL/user/register_image',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'image': 'data:image/jpeg;base64,$image',
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

  Future leaveType() async {
    var response = await client.post(
      '$baseURL/leave/leave_bal_type',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
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

  Future getShift(clientId) async {
    var response = await client.post(
      '$baseURL/transfer/client_shifts',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
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

  Future<ApplyLeave> applyLeave(
    frmDt,
    toDt,
    reason,
    dayType,
    leaveTypeId,
  ) async {
    var response = await client.post(
      '$baseURL/leave/apply_leave',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'fromDate': frmDt.toString(),
          'toDate': toDt.toString(),
          'reason': reason.toString(),
          'dayType': dayType.toString(),
          'leaveTypeId': leaveTypeId.toString(),
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return applyLeaveFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future getClients() async {
    var response = await client.post(
      '$baseURL/attendance/all_clients',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
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

  Future<SaveRPlan> saveRoutePlan(
    assignedTo,
    planName,
    date,
    pitstops,
  ) async {
    var response = await client.post(
      '$baseURL/location/save_rplan',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'assignedTo': assignedTo,
          'planName': planName,
          'date': date,
          'companyId': box.get('companyid').toString(),
          'pitstops': pitstops,
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return saveRPlanFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future getEmployees(empName) async {
    // print('empName: $empName');
    var response = await client.post(
      '$baseURL/transfer/get_suggest',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
          'empName': empName,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['empSuggest'];
    } else {
      //show error message
      return null;
    }
  }

  Future getUnits(unitName) async {
    // print('empName: $empName');
    var response = await client.post(
      '$baseURL/transfer/get_unit_suggest',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'unitName': unitName,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['clientsSuggest'];
    } else {
      //show error message
      return null;
    }
  }

  Future<LeaveList> getLeaveList() async {
    var response = await client.post(
      '$baseURL/leave/leave_list',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'roleId': box.get('role').toString(),
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      // var jsonString = response.body;
      return leaveListFromJson(utf8.decode(response.bodyBytes));
    } else {
      return null;
    }
  }

  Future aprRejLeave(id, status) async {
    // print('empName: $empName');
    var response = await client.post(
      '$baseURL/leave/approve_leave',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'approvedBy': box.get('empid').toString(),
          'status': status,
          'id': id,
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

  Future<Attendance> getClientTimings() async {
    print(
      jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'roleId': box.get('role').toString(),
        },
      ),
    );
    var response = await client.post(
      '$baseURL/attendance/clients_timing',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'roleId': box.get('role').toString(),
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return attendanceFromJson(jsonString);
    } else {
      return null;
    }
  }

  // Future<EmployeeNotations> getNotations(
  Future getNotations(
    date,
    shift,
    clientId,
    orderBy,
    checkFilter,
  ) async {
    var dt = date.toString().split('-')[2] + '-' + date.toString().split('-')[1] + '-' + date.toString().split('-')[0];
    var response = await client.post(
      '$baseURL/attendance/notations_emps',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'date': dt,
          'shift': shift,
          'clientId': clientId,
          'orderBy': orderBy,
          'checkFilter': checkFilter,
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // return employeeNotationsFromJson(jsonString);
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getNotationsBySearch(date, clientId, empName) async {
    // var dt = date.toString().split('-')[2] + '-' + date.toString().split('-')[1] + '-' + date.toString().split('-')[0];
    var response = await client.post(
      '$baseURL/attendance/get_att_suggest',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'date': date,
          'clientId': clientId,
          'empName': empName,
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // return employeeNotationsFromJson(jsonString);
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future giveAttendance(
    date,
    shift,
    clientId,
    alies,
    empId,
    designation,
    remarks,
    startTime,
    endTime, {
    extraName,
    extraParam,
  }) async {
    var fullDt = date.toString().split('-');
    var dt = fullDt[2];
    var month = fullDt[1] + fullDt[0].substring(2);
    print(
      jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'inchargeId': box.get('empid').toString(),
          'date': dt,
          'shift': shift,
          'clientId': clientId,
          'alies': alies,
          'empId': empId,
          'designation': designation,
          'remarks': remarks,
          'startTime': startTime.toString(),
          'endTime': endTime.toString(),
          'month': month,
          'extraName': extraName ?? '',
          'extraParam': extraParam ?? '',
        },
      ),
    );
    var response = await client.post(
      '$baseURL/attendance/incharge_attendance',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'inchargeId': box.get('empid').toString(),
          'date': dt,
          'shift': shift,
          'clientId': clientId,
          'alies': alies,
          'empId': empId,
          'designation': designation,
          'remarks': remarks,
          'startTime': startTime.toString(),
          'endTime': endTime.toString(),
          'month': month,
          'extraName': extraName ?? '',
          'extraParam': extraParam ?? '',
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getPitstops(rplanId, companyId) async {
    var response = await client.post(
      '$baseURL/location/get_rplan_details',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'rplanId': rplanId,
          'companyId': companyId,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // return pitstopsFromJson(jsonString);
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future updatePitstops({pitstopId, checkinLat, checkinLng, empRemarks, empId, attachment}) async {
    // print('companyid: ${box.get('companyid')}');
    // print('empid: ${box.get('empid')}');
    var response = await client.post(
      '$baseURL/location/update_pitstops',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'pitstopId': pitstopId,
          'checkinLat': checkinLat,
          'checkinLng': checkinLng,
          'empRemarks': empRemarks,
          'empId': empId,
          'image': attachment == '' ? '' : 'data:image/jpeg;base64,$attachment',
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

  Future pinMyVisit({checkinLat, checkinLng, empRemarks, empId, attachment}) async {
    // print('companyid: ${box.get('companyid')}');
    // print('empid: ${box.get('empid')}');
    var response = await client.post(
      '$baseURL/location/update_pitstops',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'checkinLat': checkinLat,
          'checkinLng': checkinLng,
          'empRemarks': empRemarks,
          'empId': empId,
          'image': attachment == '' ? '' : 'data:image/jpeg;base64,$attachment',
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

  Future newTransfer(empId, fromPeriod, toPeriod, fromUnit, shift, toUnit) async {
    var response = await client.post(
      '$baseURL/transfer/transfer_entry',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'createdBy': box.get('empid').toString(),
          'empId': empId,
          'fromPeriod': fromPeriod,
          'fromUnit': fromUnit,
          'shift': shift,
          'toPeriod': toPeriod,
          'toUnit': toUnit,
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

  Future<TransferList> getTransferList() async {
    var response = await client.post(
      '$baseURL/transfer/get_transfer_list',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return transferListFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future aprRejTransfer(empId, clientId, orderId, status) async {
    // print('status: $status');
    // print(jsonEncode(
    //     <String, dynamic>{
    //       'companyId': box.get('companyid').toString(),
    //       'rejected': status == '0' ? true : false,
    //       'orderId': orderId,
    //       'empId': empId,
    //       'clientId': clientId,
    //     },
    //   ),);
    var response = await client.post(
      '$baseURL/transfer/approve_transfer',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'rejected': status == '0' ? true : false,
          'orderId': orderId,
          'empId': empId,
          'clientId': clientId,
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

  Future<Support> getSupport() async {
    var response = await client.post(
      '$baseURL/user/get_support',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return supportFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getBroadcast() async {
    var response = await client.post(
      '$baseURL/broadcast/get_broadcast',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
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

  Future newBroadcast(empId, broadcast) async {
    var response = await client.post(
      '$baseURL/broadcast/new_broadcast',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
          'clientId': 'all',
          'roleId': 'all',
          'broadcast': broadcast,
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

  Future updateSOS(sosNumber) async {
    var response = await client.post(
      '$baseURL/user/update_sos',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'sosNumber': sosNumber,
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

  Future getEmpReport(clientId, orderBy) async {
    var response = await client.post(
      '$baseURL/attendance/emp_report',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
          'orderBy': orderBy,
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

  Future getEmpDetailsReport(empId) async {
    var response = await client.post(
      '$baseURL/user/profile',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': empId,
          'companyId': box.get('companyid'),
        },
      ),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getTimelineReport(empId, date, {type}) async {
    var url = '$baseURL/location/get_timeline';
    if (type != null && type == 'visit') {
      url = '$baseURL/location/get_emp_visits';
    }
    var response = await client.post(
      url,
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': empId,
          'date': date,
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

  Future getLocationReport(empId) async {
    var response = await client.post(
      '$baseURL/location/get_clocation',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': empId,
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

  Future getDailyEmployeeReport(empId, fdate, tdate, orderBy) async {
    var response = await client.post(
      '$baseURL/attendance/emp_att_report',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': empId,
          'fdate': fdate,
          'tdate': tdate,
          'orderBy': orderBy,
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

  Future getClientReport(clientId, date, shift, orderBy) async {
    print(
      jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
          'date': date,
          'shift': shift,
          'orderBy': orderBy,
        },
      ),
    );
    var response = await client.post(
      '$baseURL/attendance/daily_emp_report',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
          'date': date,
          'shift': shift,
          'orderBy': orderBy,
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

  Future getShortageReport(clientId, date, shift) async {
    var response = await client.post(
      '$baseURL/attendance/shortage_report',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
          'date': date,
          'shift': shift,
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

  Future sendFeedback(feedback) async {
    var response = await client.post(
      '$baseURL/user/new_query',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
          'query': feedback,
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

  Future resetPassword(emailId, newPass) async {
    var response = await client.post(
      '$baseURL/user/reset_pass',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'emailId': emailId,
          'newPass': newPass,
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

  Future getNotification() async {
    var response = await client.post(
      '$baseURL/user/get_notifications',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
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

  Future addShift(shiftName, startTime, endTime) async {
    var response = await client.post(
      '$baseURL/trial/create_shift',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'shiftName': shiftName,
          'startTime': startTime,
          'endTime': endTime,
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

  Future addClient(name, phone, clientId, inchargeId, address, lat, lng) async {
    var response = await client.post(
      '$baseURL/trial/create_client',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'address': address,
          'name': name,
          'lat': lat,
          'lng': lng,
          'phone': phone,
          'clientId': clientId,
          'inchargeId': inchargeId,
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

  void saveLocationLog({lat, lng, cancel}) async {
    int timeInterval = jsonDecode(RemoteServices().box.get('appFeature'))['trackingInterval'] ?? 15;

    if (lat != null && lng != null) {
      var currDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
      var _battery = Battery();
      var level = await _battery.batteryLevel;
      print(lat.toString());
      print(lng.toString());
      var response = await client.post(
        '$baseURL/location/save_location_log',
        headers: header,
        body: jsonEncode(
          <String, dynamic>{
            'empId': box.get('empid').toString(),
            'companyId': box.get('companyid').toString(),
            'empTimelineList': [
              {
                'lat': lat.toString(),
                'lng': lng.toString(),
                'battery': level.toString(),
                'timeStamp': currDate.toString(),
              },
            ],
          },
        ),
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(json.decode(jsonString));
      } else {
        print('error');
      }
    } else {
      getPositionSubscription = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        // distanceFilter: 10,
        intervalDuration: Duration(minutes: timeInterval),
      ).listen((Position position) async {
        if (position == null) {
          print('Unknown');
        } else {
          // var currDate = DateTime.now();
          var currDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()).toString();
          var _battery = Battery();
          var level = await _battery.batteryLevel;
          // print(position.latitude.toString());
          // print(position.longitude.toString());
          var response = await client.post(
            '$baseURL/location/save_location_log',
            headers: header,
            body: jsonEncode(
              <String, dynamic>{
                'empId': box.get('empid').toString(),
                'companyId': box.get('companyid').toString(),
                'empTimelineList': [
                  {
                    'lat': position.latitude.toString(),
                    'lng': position.longitude.toString(),
                    'battery': level.toString(),
                    'timeStamp': currDate.toString(),
                  },
                ],
              },
            ),
          );
          if (response.statusCode == 200) {
            var jsonString = response.body;
            print(json.decode(jsonString));
          } else {
            print('error');
          }
        }
      });
      if (cancel != null) {
        await getPositionSubscription.cancel();
      }
    }
  }

  Future getClientsSugg(unitName) async {
    // print('empName: $empName');
    var response = await client.post(
      '$baseURL/transfer/get_unit_suggest',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'unitName': unitName,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['clientsSuggest'];
    } else {
      //show error message
      return null;
    }
  }

  Future getDesignation() async {
    var response = await client.post(
      '$baseURL/company/get_designations',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
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

  Future getShiftByClient(clientId) async {
    var response = await client.post(
      '$baseURL/transfer/client_shifts',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
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

  Future addEmployee(name, address, email, phone, empid, sitePostedTo, gender, dob, design, shift) async {
    var response = await client.post(
      '$baseURL/trial/create_employee',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'inchargeId': box.get('empid').toString(),
          'address': address,
          'name': name,
          'mail': email,
          'phone': phone,
          'empId': empid,
          'sitePostedTo': sitePostedTo,
          'gender': gender,
          'design': design,
          'shift': shift,
          'dob': dob,
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

  Future getRPlanSugg(rplanName) async {
    // print('empName: $empName');
    var response = await client.post(
      '$baseURL/location/get_rplan_sugg',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'rplanName': rplanName,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['routePlanList'];
    } else {
      //show error message
      return null;
    }
  }
}
