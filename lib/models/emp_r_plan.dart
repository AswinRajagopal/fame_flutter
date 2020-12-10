// To parse this JSON data, do
//
//     final empRPlan = empRPlanFromJson(jsonString);

import 'dart:convert';

EmpRPlan empRPlanFromJson(String str) => EmpRPlan.fromJson(json.decode(str));

String empRPlanToJson(EmpRPlan data) => json.encode(data.toJson());

class EmpRPlan {
  EmpRPlan({
    this.success,
    this.msg,
    this.routePlanList,
  });

  bool success;
  dynamic msg;
  List<RoutePlanList> routePlanList;

  factory EmpRPlan.fromJson(Map<String, dynamic> json) => EmpRPlan(
        success: json['success'],
        msg: json['msg'],
        routePlanList: List<RoutePlanList>.from(
            json['routePlanList'].map((x) => RoutePlanList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'msg': msg,
        'routePlanList':
            List<dynamic>.from(routePlanList.map((x) => x.toJson())),
      };
}

class RoutePlanList {
  RoutePlanList({
    this.assignedTo,
    this.month,
    this.totalCount,
    this.pendingCount,
    this.empRemarks,
    this.createdBy,
    this.companyId,
    this.planEndDate,
    this.adminRemarks,
    this.createdOn,
    this.routePlanId,
    this.planName,
    this.planStartDate,
    this.status,
  });

  String assignedTo;
  String month;
  int totalCount;
  int pendingCount;
  dynamic empRemarks;
  String createdBy;
  String companyId;
  DateTime planEndDate;
  String adminRemarks;
  DateTime createdOn;
  String routePlanId;
  String planName;
  DateTime planStartDate;
  int status;

  factory RoutePlanList.fromJson(Map<String, dynamic> json) => RoutePlanList(
        assignedTo: json['assignedTo'],
        month: json['month'],
        totalCount: json['totalCount'],
        pendingCount: json['pendingCount'],
        empRemarks: json['empRemarks'],
        createdBy: json['createdBy'],
        companyId: json['companyId'],
        planEndDate: DateTime.parse(json['planEndDate']),
        adminRemarks: json['adminRemarks'],
        createdOn: DateTime.parse(json['createdOn']),
        routePlanId: json['routePlanId'],
        planName: json['planName'],
        planStartDate: DateTime.parse(json['planStartDate']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'assignedTo': assignedTo,
        'month': month,
        'totalCount': totalCount,
        'pendingCount': pendingCount,
        'empRemarks': empRemarks,
        'createdBy': createdBy,
        'companyId': companyId,
        'planEndDate': planEndDate.toIso8601String(),
        'adminRemarks': adminRemarks,
        'createdOn': createdOn.toIso8601String(),
        'routePlanId': routePlanId,
        'planName': planName,
        'planStartDate': planStartDate.toIso8601String(),
        'status': status,
      };
}
