// To parse this JSON data, do
//
//     final leaveList = leaveListFromJson(jsonString);

import 'dart:convert';

LeaveList leaveListFromJson(String str) => LeaveList.fromJson(json.decode(str));

String leaveListToJson(LeaveList data) => json.encode(data.toJson());

class LeaveList {
  LeaveList({
    this.success,
    this.msg,
    this.leaveList,
  });

  bool success;
  dynamic msg;
  List<Map<String, String>> leaveList;

  factory LeaveList.fromJson(Map<String, dynamic> json) => LeaveList(
        success: json['success'],
        msg: json['msg'],
        leaveList: json['leaveList'] == null
            ? null
            : List<Map<String, String>>.from(
                json['leaveList'].map(
                  (x) => Map.from(x).map(
                    (k, v) => MapEntry<String, String>(k, v),
                  ),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'leaveList': List<dynamic>.from(
          leaveList.map(
            (x) => Map.from(x).map(
              (k, v) => MapEntry<String, dynamic>(k, v),
            ),
          ),
        ),
      };
}
