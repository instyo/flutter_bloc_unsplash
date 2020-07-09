import 'package:dio/dio.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/models/ResponseData.dart';
import 'package:unsplash_bloc/src/utils/Constants.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class UnsplashService {
  var _client = Dio(BaseOptions(baseUrl: Constants.baseUrl));
  var _helper = ServiceHelper();

  Future<ResponseData> photoList(String order, int page) async {
    try {
      Response response = await _client
          .get("/photos?page=$page&per_page=15&order_by=$order",
              options: await _helper.auth())
          .timeout(Duration(seconds: 30));
      // success response
      if (response.statusCode == 200) {
        return ResponseData(
          code: Status.success,
          message: "Success",
          data: (response.data as List)
              .map<Photo>((json) => Photo.fromJson(json))
              .toList(),
        );
      } else {
        // error response
        return await _helper.handleErrorRequest(response);
      }
    } on DioError catch (error) {
      return ResponseData(
        code: Status.error,
        message: error.message,
        data: [],
      );
    }
  }

  Future<ResponseSingleData> photoDetail(String id) async {
    try {
      Response response = await _client
          .get("/photos/$id", options: await _helper.auth())
          .timeout(Duration(seconds: 30));
      // success response
      print(response.request.path);
      var data = Photo.fromJson(response.data);
      print(data.toJson().toString());
      if (response.statusCode == 200) {
        return ResponseSingleData(
          code: Status.success,
          message: "Success",
          data: Photo.fromJson(response.data),
        );
      } else {
        // error response
        return await _helper.handleSingleErrorRequest(response);
      }
    } on DioError catch (error) {
      return ResponseSingleData(
        code: Status.error,
        message: error.message,
        data: [],
      );
    }
  }

  Future<ResponseSingleData> userProfile(String username) async {
    try {
      Response response = await _client
          .get("/users/${username == null ? 'heysupersimi' : username}",
              options: await _helper.auth())
          .timeout(Duration(seconds: 30));
      // success response
      if (response.statusCode == 200) {
        return ResponseSingleData(
          code: Status.success,
          message: "Success",
          data: User.fromJson(response.data),
        );
      } else {
        // error response
        return await _helper.handleSingleErrorRequest(response);
      }
    } on DioError catch (error) {
      return ResponseSingleData(
        code: Status.error,
        message: error.message,
        data: [],
      );
    }
  }

  Future<ResponseData> userPhotoList(String username, int page) async {
    try {
      Response response = await _client
          .get(
              "/users/${username == null ? 'heysupersimi' : username}/photos?page=$page&per_page=15&order_by=latest",
              options: await _helper.auth())
          .timeout(Duration(seconds: 30));
      // success response
      if (response.statusCode == 200) {
        return ResponseData(
          code: Status.success,
          message: "Success",
          data: (response.data as List)
              .map<Photo>((json) => Photo.fromJson(json))
              .toList(),
        );
      } else {
        // error response
        return await _helper.handleErrorRequest(response);
      }
    } on DioError catch (error) {
      return ResponseData(
        code: Status.error,
        message: error.message,
        data: [],
      );
    }
  }
}
