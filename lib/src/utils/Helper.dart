import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:unsplash_bloc/src/models/ResponseData.dart';
import 'package:unsplash_bloc/src/utils/Constants.dart';

enum Status { success, unauthorized, error, notfound }

class ServiceHelper {
  Future<ResponseData> handleErrorRequest(Response response) async {
    switch (response.statusCode) {
      case 401:
        return ResponseData(
            code: Status.unauthorized, message: "Unauthorized", data: []);
        break;
      case 500:
        return ResponseData(
            code: Status.error, message: "Internal Server Error", data: []);
        break;
      case 404:
        return ResponseData(
            code: Status.notfound, message: "Request Not Found", data: []);
        break;
      default:
        debugPrint("Statuscode : ${response.statusCode}");
        debugPrint("status Message : ${response.statusMessage}");
        return ResponseData(
            code: Status.error, message: "an error has occured!", data: []);
        break;
    }
  }

  Future<ResponseSingleData> handleSingleErrorRequest(Response response) async {
    switch (response.statusCode) {
      case 401:
        return ResponseSingleData(
            code: Status.unauthorized, message: "Unauthorized", data: []);
        break;
      case 500:
        return ResponseSingleData(
            code: Status.error, message: "Internal Server Error", data: []);
        break;
      case 404:
        return ResponseSingleData(
            code: Status.notfound, message: "Request Not Found", data: []);
        break;
      default:
        debugPrint("Statuscode : ${response.statusCode}");
        debugPrint("status Message : ${response.statusMessage}");
        return ResponseSingleData(
            code: Status.error, message: "an error has occured!", data: []);
        break;
    }
  }

  Future<Options> auth() async {
    final header = {
      "Content-Type": "application/json",
      "Authorization": "Client-ID " + Constants.apiKey
    };

    return Options(
        headers: header,
        followRedirects: false,
        validateStatus: (status) {
          return status < 501;
        });
  }
}
