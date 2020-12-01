import 'dart:convert';

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
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return loginFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
