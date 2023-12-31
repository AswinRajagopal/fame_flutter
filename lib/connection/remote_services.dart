import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
// import 'package:background_locator/location_dto.dart';
// import 'package:background_locator/settings/android_settings.dart' as android;
// import 'package:background_locator/settings/android_settings.dart';
// import 'package:background_locator/settings/ios_settings.dart' as ios;
// import 'package:background_locator/settings/locator_settings.dart';
import 'package:dio/dio.dart' as mydio;
import 'package:dio/dio.dart';
import 'package:fame/utils/utils.dart';
import 'package:fame/views/offline.dart';
// import 'package:fame/connection/location_service_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/attendance.dart';
import '../models/checkin.dart';
import '../models/dashboard.dart';
import '../models/db_calendar.dart';
import '../models/emp_r_plan.dart';
import '../models/face_register.dart';
import '../models/forgot_password.dart';
import '../models/leave_list.dart';
import '../models/login.dart';
import '../models/otp.dart';
import '../models/save_route_plan.dart';
import '../models/signup.dart';
import '../models/support.dart';
import '../models/transfer_list.dart';
import '../views/welcome_page.dart';

// import 'package:background_locator/background_locator.dart' as bgl;
// import 'package:background_locator/settings/locator_settings.dart' as ls;

class RemoteServices {
  static var baseURL = 'http://52.66.61.207:8090/v1/api';

  // static var baseURL = 'http://10.0.19.27:8090/v1/api';
  // static var baseURL = 'http://androidapp.mydiyosfame.com:8090/v1/api';
  // static var baseURL = 'http://192.168.0.247:8090/v1/api';
  // static var baseURL = 'http://172.20.10.4:8090/v1/api'  ;
  // static var baseURL = 'http://10.0.52.40:8090/v1/api'  ;
  // static var baseURL = 'http://192.168.31.252:8090/v1/api';
  static var client = http.Client();
  var header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  var box = Hive.box('fame_pocket');
  static var accessKey = 'diyos2020';
  final FirebaseMessaging _fbm = FirebaseMessaging();
  StreamSubscription getPositionSubscription;
  var battery = Battery();

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

    return pushCode;
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        AppUtils.snackbarTitle,
        'Please connect to working internet connection',
        colorText: AppUtils.snackbarTextColor,
        backgroundColor: AppUtils.snackbarbackgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
      return false;
    }
    return false;
  }

  void showResponseCodeMsg({errorCode}) {
    if (errorCode != null && errorCode == 500) {
      Get.snackbar(
        AppUtils.snackbarTitle,
        'Internal Server Error',
        colorText: AppUtils.snackbarTextColor,
        backgroundColor: AppUtils.snackbarbackgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    } else if (errorCode != null && errorCode == 404) {
      Get.snackbar(
        AppUtils.snackbarTitle,
        'Services Not Found',
        colorText: AppUtils.snackbarTextColor,
        backgroundColor: AppUtils.snackbarbackgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    } else {
      Get.snackbar(
        AppUtils.snackbarTitle,
        AppUtils.snackbarErrorMessage,
        colorText: AppUtils.snackbarTextColor,
        backgroundColor: AppUtils.snackbarbackgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        borderRadius: 5.0,
      );
    }
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
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel('in.androidfame.attendance');
      var result = await methodChannel.invokeMethod('stopService');
      print('result: $result');
    }
    // ignore: unawaited_futures
    Get.offAll(WelcomePage());
  }

  Future validateMobile(mobile) async {
    var response = await client.post(
      '$baseURL/user/verify_phone',
      headers: header,
      body: jsonEncode(
        <String, String>{"phoneNumber": mobile.toString()},
      ),
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return jsonDecode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<Login> loginUsingPhoneNo(phoneNo) async {
    var pushCode = await setFirebaseNotification();
    var response = await client.post(
      '$baseURL/user/login',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "phoneNumber": phoneNo.toString(),
          'pushCode': pushCode
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

  Future<Login> login(username, empid, password) async {
    if (await checkInternet()) {
      var pushCode = await setFirebaseNotification();
      var response = await client.post(
        '$baseURL/user/login',
        headers: header,
        body: jsonEncode(
          <String, String>{
            'userName': username,
            'empId': empid,
            'password': password,
            'pushCode': pushCode,
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
    } else {
      return Get.to(OfflinePage());
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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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

  Future getChangePass(currentPass, newPass) async {
    var response = await client.post(
      '$baseURL/user/change_pass',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "empId": box.get('empid'),
          "companyId": box.get('companyid'),
          "currentpass": currentPass,
          "newpass": newPass,
        },
      ),
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return jsonDecode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getBulkAttendance(shift, clientId) async {
    var response = await client.post(
      '$baseURL/attendance/bulkatt_shift_client',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'shift': shift,
          'clientId': clientId,
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

  Future getEmpDetails() async {
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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
    var dio = mydio.Dio();
    var formData = mydio.FormData.fromMap({
      'companyID': box.get('companyid'),
      'empID': box.get('empid'),
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

    if (response.statusCode == 200) {
      var jsonString = response.data;
      return checkinFromJson(jsonEncode(jsonString));
    } else {
      return null;
    }
  }

  Future getNearestSite(double lat, double lng) async {
    var response = await client.post(
      '$baseURL/attendance/nearest_site',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'lat': lat.toString(),
          'lon': lng.toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return jsonDecode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<Dashboard> getDashboardDetails() async {
    if (await checkInternet()) {
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
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(response.body.runtimeType);
        print(jsonDecode(response.body)['empdetails']);
        // developer.log('jsonString: ${jsonString.toString()}');
        return dashboardFromJson(jsonString);
        // return jsonDecode(response.body);
      } else {
        //show error message
        return null;
      }
    } else {
      return Get.to(OfflinePage());
    }
  }

  Future getDbDetails() async {
    if (await checkInternet()) {
      var pushCode = await setFirebaseNotification();
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
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return jsonDecode(jsonString);
      } else {
        //show error message
        return null;
      }
    } else {
      return Get.to(OfflinePage());
    }
  }

  Future getDashboardList(param)async{
    if (await checkInternet()) {
      var response = await client.post(
        '$baseURL/attendance/get_dash_list',
        headers: header,
        body: jsonEncode(
          <String, String>{
            'companyId': box.get('companyid').toString(),
            "parameter": param.toString()
          },
        ),
      );
      if (response.statusCode == 200) {
        var jsonString = response.body;
        return jsonDecode(jsonString);
      } else {
        //show error message
        return null;
      }
    } else {
      return Get.to(OfflinePage());
    }
  }

  Future<EmpRPlan> getEmprPlan() async {
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
      return dbCalendarFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getEmpCalendarNew(month, empId) async {
    if (empId==null || empId == ''){
      empId = box.get('empid').toString();
    }
    var response = await client.post(
      '$baseURL/attendance/emp_calendar',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
          'month': month,
        },
      ),
    );
    var body =  <String, String>{
      'empId': empId,
      'companyId': box.get('companyid').toString(),
      'month': month,
    };
    print("emp");
    print(response.request);
    print(response.body);
    print(body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getStores()async{
    var response = await client.post(
      '$baseURL/transfer/get_stores',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
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

  Future getAddressFromLatLng(double lat, double lng) async {
    var _host = 'https://maps.googleapis.com/maps/api/geocode/json';
    final url =
        '$_host?key=AIzaSyADoNEFbFbgHCpu7mz7yLWhbbUMZqk4yHU&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data['results'][0]['formatted_address'];
        print('response ==== $_formattedAddress');
        return _formattedAddress;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future nearestCheckin(lat, lng, address, clientId) async {
    var response = await client.post(
      '$baseURL/attendance/checkin',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'shift': box.get('shift').toString(),
          'clientId': clientId.toString(),
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

    if (response.statusCode == 200) {
      var jsonString = response.data;
      return faceRegFromJson(jsonEncode(jsonString));
    } else {
      return null;
    }
  }

  Future uploadPolicyDoc(File imageFile, name) async {
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'companyId': box.get('companyid'),
      'empId': box.get('empid'),
      'label': name,
      'file': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    var response = await dio.post(
      '$baseURL/company/upload_policy',
      data: formData,
    );

    if (response.statusCode == 200) {
      var jsonString = response.data;
      return jsonString;
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

  Future leaveType(String empId) async {
    if (empId == "888") {
      empId = box.get('empid').toString();
    }
    var response = await client.post(
      '$baseURL/leave/leave_bal_type',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': empId,
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

  Future getLeaveBalance(String empId) async {
    if (empId == "888") {
      empId = box.get('empid').toString();
    }
    var response = await client.post(
      '$baseURL/leave/leave_balance',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': empId,
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

  Future applyLeave(frmDt, toDt, reason, dayType, leaveTypeId, empId) async {
    if (empId == "888") {
      empId = box.get('empid').toString();
    }
    var response = await client.post(
      '$baseURL/leave/leave_engine_apply',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'empId': empId,
          'appliedBy': box.get('empid').toString(),
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
      // return applyLeaveFromJson(jsonString);
      return json.decode(jsonString);
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
          'empId': box.get('empid').toString(),
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

  Future getActivityList() async {
    var response = await client.post(
      '$baseURL/company/get_activity_list',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future getMyClients() async {
    var response = await client.post(
      '$baseURL/attendance/all_clients',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future getTransferEmployees(empName) async {
    var response = await client.post(
      '$baseURL/transfer/get_suggest',
      headers: header,
      body: jsonEncode(
        <String, Object>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
          'transfer': true,
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
    var dt = date.toString().split('-')[2] +
        '-' +
        date.toString().split('-')[1] +
        '-' +
        date.toString().split('-')[0];
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
      print('jsonString: $jsonString');
      // return employeeNotationsFromJson(jsonString);
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmployeeBySearch(date, clientId, empName, allShifts) async {
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
            'allShifts': allShifts
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        print('jsonString: $jsonString');
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

  Future addRegularizeAtt(alias, checkIn, checkOut, attId, reason) async {
    var response = await client.post(
      '$baseURL/attendance/add_regularize_att',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "companyId": box.get('companyid').toString(),
          "empId": box.get('empid').toString(),
          "dailyAttId": attId.toString(),
          "checkInDateTime": checkIn.toString(),
          "checkOutDateTime": checkOut.toString(),
          "attendanceAlias": alias.toString(),
          "createdBy": box.get('empid').toString(),
          "reason": reason.toString()
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

  Future getAllRegNotations() async{
    var response = await client.post(
      '$baseURL/attendance/all_notations',
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
      // return pitstopsFromJson(jsonString);
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getRegularizeAtt() async {
    var response = await client.post(
      '$baseURL/attendance/get_regularize_att',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future updateRegAtt(
      checkInTime, checkOutTime,alias, status, adminRemarks, regAttId) async {
    var response = await client.post(
      '$baseURL/attendance/update_regularize_att',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "companyId": box.get('companyid').toString(),
          "checkInDateTime": checkInTime.toString(),
          "checkOutDateTime": checkOutTime.toString(),
          "attendanceAlias":alias.toString(),
          "status": status.toString(),
          "updatedBy": box.get('empid').toString(),
          "adminRemarks": adminRemarks.toString(),
          "regAttId": regAttId.toString()
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

  Future updatePitstops(
      {pitstopId,
      checkinLat,
      checkinLng,
      empRemarks,
      empId,
      attachment}) async {
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

  Future pinMyVisit(
      {checkinLat,
      checkinLng,
      empRemarks,
      empId,
      attachment,
      address,
      clientID,
      activity}) async {
    var response = await client.post(
      '$baseURL/location/update_pitstops',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'checkinLat': checkinLat,
          'checkinLng': checkinLng,
          'empRemarks': empRemarks,
          'address': address,
          'empId': empId,
          'companyId': box.get('companyid').toString(),
          'attachment':
              attachment == '' ? '' : 'data:image/jpeg;base64,$attachment',
          'clientID': clientID,
          'activity': activity,
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

  Future newTransfer(
      empId, fromPeriod, toPeriod, fromUnit, shift, toUnit,storeCode) async {
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
          'storeCode':storeCode
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

  Future newRoster(
      empId, fromPeriod, toPeriod, fromUnit, shift, toUnit,storeCode,clientID,design) async {
    var response = await client.post(
      '$baseURL/transfer/new_roster',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          // 'createdBy': box.get('empid').toString(),
          'empId': empId,
          'clientId':clientID,
          'design':design,
          'shift': shift,
          'storeCode':storeCode,
          'fromPeriod': fromPeriod,
          'toPeriod': toPeriod,

          // 'fromUnit': fromUnit,
          // 'toUnit': toUnit,
        },
      ),
    );
    var b =   <String, String>{
      'companyId': box.get('companyid').toString(),
      'createdBy': box.get('empid').toString(),
      'empId': empId,
      'clientId':clientID,
      'design':design,
      'shift': shift,
      'storeCode':storeCode,
      'fromPeriod': fromPeriod,
      'toPeriod': toPeriod,

      // 'fromUnit': fromUnit,
      // 'toUnit': toUnit,
    };
    print("res ${response.body}");
    print("url ${response.request}");
    print("body ${b}");
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
    var body =  <String, dynamic>{
      'empId': box.get('empid').toString(),
      'companyId': box.get('companyid').toString(),
    };

    print(response.statusCode);
    print(response.body);
    print(body);
    print(response.request);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return transferListFromJson(jsonString);
    } else {
      return null;
    }
  }

  Future aprRejTransfer(empId, clientId, orderId, status) async {
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

  Future aprRejExpense(
      adminRemarks, amount, empId, expenseEmpId, status) async {
    var response = await client.post(
      '$baseURL/expense/update_expenses',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          "companyId": box.get('companyid').toString(),
          "adminRemarks": adminRemarks.toString(),
          "amount": amount.toString(),
          "empId": empId.toString(),
          "expenseEmpId": expenseEmpId.toString(),
          "status": status.toString(),
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

  Future getNewEmpAdv(amount) async {
    var response = await client.post('$baseURL/expense/new_adv_exp',
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "companyId": box.get('companyid').toString(),
          "empId": box.get('empid').toString(),
          "amount": amount,
          "purpose": "expenses",
          'expenseTypeId': "2"
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getExpAdv() async {
    var response = await client.post('$baseURL/expense/get_emp_adv',
        headers: header,
        body: jsonEncode(<String, dynamic>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getExpAdvAdmin(empId) async {
    var response = await client.post('$baseURL/expense/get_emp_adv',
        headers: header,
        body: jsonEncode(<String, dynamic>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmpExpenses(param) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'parameter':param.toString()
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getExpensesAdmin(fromDate,toDate) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'fromDate': fromDate.toString(),
          'toDate': toDate.toString()
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getExpensesAdminFt(fromDate,toDate) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'fromDate': fromDate.toString(),
          'toDate': toDate.toString()
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmpExpensesAll(empId) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmpExpensesAdmin(empId, fromDate, toDate) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
          'fromDate': fromDate.toString(),
          'toDate': toDate.toString()
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmpExpense(status) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          "status": status
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getEmpExpenseAdmin(empId, status) async {
    var response = await client.post('$baseURL/expense/get_emp_expenses',
        headers: header,
        body: jsonEncode(<String, String>{
          'empId': empId,
          'companyId': box.get('companyid').toString(),
          "status": status
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getExpAttachments(expenseEmpId) async {
    var response = await client.post('$baseURL/expense/exp_attachments',
        headers: header,
        body: jsonEncode({
          "companyId": box.get('companyid').toString(),
          "expenseEmpId": expenseEmpId
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getBillAttachments(expenseBillId) async {
    var response = await client.post('$baseURL/expense/exp_attachments',
        headers: header,
        body: jsonEncode({
          "companyId": box.get('companyid').toString(),
          "expenseBillId": expenseBillId
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future getExpenses() async {
    var response = await client.post(
      '$baseURL/expense/expense_type',
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
      return null;
    }
  }

  Future getGrie() async {
    var response = await client.post(
      '$baseURL/company/get_grie',
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

  Future getPolicyDocs() async {
    var response = await client.post(
      '$baseURL/company/get_policy_docs',
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

  Future newExpenses(File imageFile, amount, expenseTypeId, remarks,
      File image1, File image2) async {
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'companyId': box.get('companyid').toString(),
      'empId': box.get('empid').toString(),
      'amount': amount,
      'expenseTypeId': expenseTypeId,
      'remarks': remarks,
      'attachment1': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: 'image1.jpg',
      ),
      'attachment2': image1 != null
          ? await mydio.MultipartFile.fromFile(
              image1.path,
              filename: 'image2.jpg',
            )
          : null,
      'attachment3': image2 != null
          ? await mydio.MultipartFile.fromFile(
              image2.path,
              filename: 'image3.jpg',
            )
          : null,
    });
    var response = await dio.post(
      '$baseURL/expense/expense_emp',
      data: formData,
    );
    if (response.statusCode == 200) {
      var jsonString = response.data;
      print(jsonString);
      return jsonString;
    } else {
      return null;
    }
  }

  Future newExpBills(File imageFile, amount, expenseTypeId, remarks,
      File image1, File image2) async {
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'companyId': box.get('companyid').toString(),
      'empId': box.get('empid').toString(),
      'amount': amount,
      'expenseTypeId': expenseTypeId,
      'remarks': remarks,
      'attachment1': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: 'image1.jpg',
      ),
      'attachment2': image1 != null
          ? await mydio.MultipartFile.fromFile(
              image1.path,
              filename: 'image2.jpg',
            )
          : null,
      'attachment3': image2 != null
          ? await mydio.MultipartFile.fromFile(
              image2.path,
              filename: 'image3.jpg',
            )
          : null,
    });
    var response = await dio.post(
      '$baseURL/expense/new_exp_bills',
      data: formData,
    );
    if (response.statusCode == 200) {
      var jsonString = response.data;
      // print(jsonString);
      return jsonString;
    } else {
      return null;
    }
  }

  Future editExpBills(amount, expenseTypeId, expenseBillId, remarks,
      File imageFile, File image1, File image2) async {
    var dio = mydio.Dio();
    var formData = mydio.FormData.fromMap({
      'companyId': box.get('companyid').toString(),
      'empId': box.get('empid').toString(),
      'amount': amount,
      'expenseTypeId': expenseTypeId,
      'expenseBillId': expenseBillId,
      'remarks': remarks,
      'attachment1': await mydio.MultipartFile.fromFile(
        imageFile.path,
        filename: 'image1.jpg',
      ),
      'attachment2': image1 != null
          ? await mydio.MultipartFile.fromFile(
              image1.path,
              filename: 'image2.jpg',
            )
          : null,
      'attachment3': image2 != null
          ? await mydio.MultipartFile.fromFile(
              image2.path,
              filename: 'image3.jpg',
            )
          : null,
    });
    var response = await dio.post(
      '$baseURL/expense/edit_exp_bills',
      data: formData,
    );
    if (response.statusCode == 200) {
      var jsonString = response.data;
      return jsonString;
    } else {
      return null;
    }
  }

  Future newBroadcast(clientId, broadcast) async {
    var response = await client.post(
      '$baseURL/broadcast/new_broadcast',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'clientId': clientId,
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

  Future getBillsByStatus() async {
    var response = await client.post(
      '$baseURL/expense/get_exp_bills',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "companyId": box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future getBillsToExpense(bills) async {
    var response = await client.post(
      '$baseURL/expense/bills_to_expense',
      headers: header,
      body: jsonEncode(<String, String>{
        "companyId": box.get('companyid').toString(),
        'empId': box.get('empid').toString(),
        "bills": bills
      }),
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

  Future getExpAdvBalance(empId) async {
    var response = await client.post(
      '$baseURL/expense/adv_exp_bal',
      headers: header,
      body: jsonEncode(<String, String>{
        "companyId": box.get('companyid').toString(),
        'empId': empId,
      }),
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

  Future newGrie(broadcast) async {
    var response = await client.post(
      '$baseURL/company/create_grie',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'empId': box.get('empid').toString(),
          'companyId': box.get('companyid').toString(),
          'report': broadcast,
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
          'empId': box.get('empid').toString()
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

  Future getOnboardEmpList(clientId, orderBy) async {
    var response = await client.post(
      '$baseURL/company/get_regemp_list',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future getPitstopAttch(pitstopId) async {
    var url = '$baseURL/location/pitstop_attach';
    var response = await client.post(
      url,
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'pitstopId': pitstopId,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(json.decode(jsonString));
      return json.decode(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future getVisitDownloads(empId, fromDate, toDate) async {
    Dio dio = Dio();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/myVisit.pdf';
    final file = File(filePath);
    print(file.path);

    var response = await dio.download('$baseURL/location/pitstops_by_empId', filePath,
            options: Options(
              headers: header,
              method: 'POST',
            ),
            data: jsonEncode(
              <String, String>{
                "fromDate": fromDate,
                "toDate": toDate,
                "empId": empId,
                "companyId" : box.get('companyid').toString()
              },
            ));
    if (response.statusCode == 200) {
      if (await file.exists()) {
        return filePath;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future getPitstopByFromToDate(empId, fromDate, toDate) async {
    var response = await client.post(
      '$baseURL/location/pitstops_by_date',
      headers: header,
      body: jsonEncode(
        <String, String>{
          "companyId": box.get('companyid').toString(),
          "fromDate": fromDate,
          "toDate": toDate,
          "empId": empId
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
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
      print(jsonString);
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

  Future getRepoManagerEmpAtt(date) async {
    var response = await client.post(
      '$baseURL/attendance/get_repo_empAtt',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'date': date,
          'empId': box.get('empid').toString(),

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

  Future getRepoManagerEmpDt() async {
    var response = await client.post(
      '$baseURL/attendance/get_repo_empAtt',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),

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
          'empId': box.get('empid').toString(),
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
    int timeInterval = jsonDecode(
            RemoteServices().box.get('appFeature'))['trackingInterval'] ??
        15;

    if (lat != null && lng != null) {
      var currDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString();
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
      print('herer it is');
      var listOfData = [];
      getPositionSubscription = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        intervalDuration: Duration(minutes: timeInterval),
        // intervalDuration: Duration(seconds: 15),
      ).listen((Position position) async {
        // print('herer it is position: $position');
        if (position == null) {
          print('Unknown');
        } else {
          // var currDate = DateTime.now();
          var currDate = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now())
              .toString();
          var _battery = Battery();
          var level = await _battery.batteryLevel;
          var connectivityResult = await Connectivity().checkConnectivity();
          var offline_location = await box.get('offline_location');
          // print('offline_location: $offline_location');
          if (connectivityResult == ConnectivityResult.none) {
            var dataToBeAdd = jsonEncode(
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
            );
            listOfData.add(dataToBeAdd);
            if (offline_location != null && offline_location != '') {
              var arr_offline_location = jsonDecode(offline_location);
              arr_offline_location.add(dataToBeAdd);
              await box.put(
                'offline_location',
                jsonEncode(arr_offline_location),
              );
            } else {
              await box.put(
                'offline_location',
                jsonEncode(listOfData),
              );
            }
          }
          if (offline_location != null && offline_location != '') {
            var list_offline_location = jsonDecode(offline_location);
            // print('list_offline_location: $list_offline_location');
            for (var i = 0; i < list_offline_location.length; i++) {
              var responseOffline = await client.post(
                '$baseURL/location/save_location_log',
                headers: header,
                body: list_offline_location[i],
              );
              var jsonString = responseOffline.body;
              print('Offline Data: ${json.decode(jsonString)}');
            }
            await box.put(
              'offline_location',
              '',
            );
            listOfData.clear();
          }
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
        print('cancel location');
        await getPositionSubscription.cancel();
      }
    }
  }

  Future getClientsSugg(unitName) async {
    var response = await client.post(
      '$baseURL/transfer/get_unit_suggest',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
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

  Future getBranchClientsSugg(unitName) async {
    var response = await client.post(
      '$baseURL/transfer/get_unit_suggest',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
          'branch': "1",
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

  Future getDesignSugg(unitName) async {
    var response = await client.post(
      '$baseURL/company/get_designations',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'desSugg': unitName,
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['designationsList'];
    } else {
      //show error message
      return null;
    }
  }

  Future getDeptSugg(unitName) async {
    var response = await client.post(
      '$baseURL/company/get_departments',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'depSugg': unitName,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString)['departmentList'];
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

  Future addEmployee(name, address, email, phone, empid, sitePostedTo, gender,
      dob, design, shift) async {
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

  Future getData() async {
    var response = await client.post(
      '$baseURL/company/get_recdata',
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

  Future getStates() async {
    var response = await client.post(
      '$baseURL/company/get_states',
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

  Future getCities(stateId) async {
    var response = await client.post(
      '$baseURL/company/get_cities',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'stateId': stateId,
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

  Future getObMandateFields() async {
    var response = await client.post(
      '$baseURL/company/get_mandate_fields',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
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

  Future newEmpRec(empdetails) async {
    var response = await client.post(
      '$baseURL/company/new_emprec',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'empId': box.get('empid').toString(),
          'empdetails': empdetails,
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

  Future newRecRel(empRelationshipList, empId) async {
    var response = await client.post(
      '$baseURL/company/new_rec_rel',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'empId': empId.toString(),
          'empRelationshipList': empRelationshipList,
        },
      ),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  Future newRecProof(proofDetails, empId) async {
    var response = await client.post(
      '$baseURL/company/new_rec_proof',
      headers: header,
      body: jsonEncode(
        <String, dynamic>{
          'companyId': box.get('companyid').toString(),
          'empId': empId.toString(),
          'proofDetails': proofDetails,
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

  Future newRecUploadProof(
      var empId,
      File aadharFront,
      File aadharBack,
      File passbookFront,
      File passbookBack,
      File proof3Front,
      File proof3Back,
      File profile) async {
    var dio = mydio.Dio();
    var proof3backvar = null,
        proof3frontvar = null,
        profilevar = null,
        passbookFrontVar,
        passbookBackVar;
    if (proof3Back != null) {
      proof3backvar = await mydio.MultipartFile.fromFile(
        proof3Back.path,
        filename: path.basename(proof3Back.path).toString(),
      );
    }
    if (proof3Front != null) {
      proof3frontvar = await mydio.MultipartFile.fromFile(
        proof3Front.path,
        filename: path.basename(proof3Front.path).toString(),
      );
    }
    if (profile != null) {
      profilevar = await mydio.MultipartFile.fromFile(
        profile.path,
        filename: path.basename(profile.path).toString(),
      );
    }
    if (passbookBack != null) {
      passbookBackVar = await mydio.MultipartFile.fromFile(
        passbookBack.path,
        filename: path.basename(passbookBack.path).toString(),
      );
    }
    if (passbookFront != null) {
      passbookFrontVar = await mydio.MultipartFile.fromFile(
        passbookFront.path,
        filename: path.basename(passbookFront.path).toString(),
      );
    }
    var formData = mydio.FormData.fromMap({
      'companyId': box.get('companyid').toString(),
      'empId': empId,
      'aadharFront': await mydio.MultipartFile.fromFile(
        aadharFront.path,
        filename: path.basename(aadharFront.path).toString(),
      ),
      'aadharBack': await mydio.MultipartFile.fromFile(
        aadharBack.path,
        filename: path.basename(aadharBack.path).toString(),
      ),
      'passbookFront': passbookFrontVar,
      'passbookBack': passbookBackVar,
      'profile': profilevar,
      'proof3Front': proof3frontvar,
      'proof3Back': proof3backvar,
    });
    var response = await dio.post(
      '$baseURL/company/upload_rec_proof',
      data: formData,
    );

    // print(response.data);
    if (response.statusCode == 200) {
      var jsonString = response.data;
      return jsonString;
    } else {
      return null;
    }
  }

  Future aprRejRoutePlan(id, status) async {
    var response = await client.post(
      '$baseURL/location/update_rplan',
      headers: header,
      body: jsonEncode(
        <String, String>{
          'companyId': box.get('companyid').toString(),
          'approvedBy': box.get('empid').toString(),
          'status': status,
          'rplanId': id,
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

  Future getAadharData(aadharNo) async {
    var dio = mydio.Dio();

    var formData = mydio.FormData.fromMap({
      'aadhaar_no': aadharNo,
    });
    var response = await dio.post(
      'http://52.66.61.207:5005/get_data',
      data: formData,
    );

    if (response.statusCode == 200) {
      var jsonString = response.data;
      return jsonString;
    } else {
      return null;
    }
  }
}
