// To parse this JSON data, do
//
//     final storeCode = storeCodeFromJson(jsonString);

import 'dart:convert';

StoreCodeModel storeCodeFromJson(String str) => StoreCodeModel.fromJson(json.decode(str));

String storeCodeToJson(StoreCodeModel data) => json.encode(data.toJson());

class StoreCodeModel {
  List<StoreName> storeNames;

  StoreCodeModel({
    this.storeNames,
  });

  factory StoreCodeModel.fromJson(Map<String, dynamic> json) => StoreCodeModel(
    storeNames: List<StoreName>.from(json["storeNames"].map((x) => StoreName.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "storeNames": List<dynamic>.from(storeNames.map((x) => x.toJson())),
  };
}

class StoreName {
  String storeCode;
  String storeName;
  String clientId;

  StoreName({
    this.storeCode,
    this.storeName,
    this.clientId,
  });

  factory StoreName.fromJson(Map<String, dynamic> json) => StoreName(
    storeCode: json["storeCode"],
    storeName: json["storeName"],
    clientId: json["clientId"],
  );

  Map<String, dynamic> toJson() => {
    "storeCode": storeCode,
    "storeName": storeName,
    "clientId": clientId,
  };
}
