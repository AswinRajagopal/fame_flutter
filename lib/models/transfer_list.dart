// To parse this JSON data, do
//
//     final transferList = transferListFromJson(jsonString);

import 'dart:convert';

TransferList transferListFromJson(String str) => TransferList.fromJson(json.decode(str));

String transferListToJson(TransferList data) => json.encode(data.toJson());

class TransferList {
  TransferList({
    this.success,
    this.transferList,
    this.msg,
  });

  bool success;
  List<TransferListElement> transferList;
  dynamic msg;

  factory TransferList.fromJson(Map<String, dynamic> json) => TransferList(
        success: json['success'],
        transferList: json['transferList'] == null
            ? null
            : List<TransferListElement>.from(
                json['transferList'].map(
                  (x) => TransferListElement.fromJson(x),
                ),
              ),
        msg: json['msg'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'transferList': List<dynamic>.from(
          transferList.map(
            (x) => x.toJson(),
          ),
        ),
        'msg': msg,
      };
}

class TransferListElement {
  TransferListElement({
    this.createdByName,
    this.toUnitName,
    this.toPeriod,
    this.fromUnitName,
    this.createdBy,
    this.fromPeriod,
    this.createdOn,
    this.orderId,
    this.empId,
    this.empName,
    this.toUnit,
    this.shift,
  });

  String createdByName;
  String toUnitName;
  DateTime toPeriod;
  String fromUnitName;
  String createdBy;
  DateTime fromPeriod;
  DateTime createdOn;
  String orderId;
  String empId;
  String empName;
  String toUnit;
  String shift;

  factory TransferListElement.fromJson(Map<String, dynamic> json) => TransferListElement(
        createdByName: json['createdByName'],
        toUnitName: json['toUnitName'],
        toPeriod: DateTime.parse(json['toPeriod']),
        fromUnitName: json['fromUnitName'],
        createdBy: json['createdBy'],
        fromPeriod: DateTime.parse(json['fromPeriod']),
        createdOn: DateTime.parse(json['createdOn']),
        orderId: json['orderId'],
        empId: json['empId'],
        empName: json['empName'],
        toUnit: json['toUnit'],
        shift: json['shift'],
      );

  Map<String, dynamic> toJson() => {
        'createdByName': createdByName,
        'toUnitName': toUnitName,
        'toPeriod': toPeriod.toIso8601String(),
        'fromUnitName': fromUnitName,
        'createdBy': createdBy,
        'fromPeriod': fromPeriod.toIso8601String(),
        'createdOn': createdOn.toIso8601String(),
        'orderId': orderId,
        'empId': empId,
        'empName': empName,
        'toUnit': toUnit,
        'shift': shift,
      };
}
