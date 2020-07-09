import 'dart:convert';
import 'package:unsplash_bloc/src/utils/Helper.dart';

ResponseData responseDataFromJson(String str) =>
    ResponseData.fromJson(json.decode(str));

String responseDataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
  Status code;
  String message;
  List<dynamic> data;

  ResponseData({
    this.code,
    this.message,
    this.data,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        code: json["code"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}

class ResponseSingleData {
  Status code;
  String message;
  dynamic data;

  ResponseSingleData({
    this.code,
    this.message,
    this.data,
  });

  factory ResponseSingleData.fromJson(Map<String, dynamic> json) =>
      ResponseSingleData(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
