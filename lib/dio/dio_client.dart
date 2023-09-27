import 'package:dio/dio.dart';

import 'api_constants.dart';

class DioClient {
  final Dio _dio = Dio();

// Headers
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'token': ApiConstants.token,
    'X-channel': 'M',
    'X-Mobile-Platform': ApiConstants.mobile_platform,
    'X-Mobile-Version': ApiConstants.version_code.toString(),
  };

  Future<dynamic> registerUser(
      String userId, String password, String deviceId, String mode) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.registeruser,
              data: {
                'userId': userId,
                'password': password,
                'deviceId': deviceId,
                'mode': mode,
              },
              options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> forgotPassword(
      String userId, String password, String deviceId, String mode) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.forgotmpin,
              data: {
                'userId': userId,
                'password': password,
                'deviceId': deviceId,
                'mode': mode,
              },
              options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> login(
      String userId, String password, String deviceId, String mode) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.login,
              data: {
                'userId': userId,
                'password': password,
                'deviceId': deviceId,
                'mode': mode,
              },
              options: Options(headers: headers));
      print(headers);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> setmpin(
      String userId, String password, String deviceId, String mode) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.setmpin,
              data: {
                'userId': userId,
                'password': password,
                'deviceId': deviceId,
                'mode': mode,
              },
              options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getloginotp(String userId) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.getotp,
              data: {
                'employeeId': userId,
              },
              options: Options(headers: headers));
      print(headers);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> logout() async {
    try {
      Response response = await _dio.post(
          ApiConstants.baseUrl + ApiConstants.logout,
          data: {},
          options: Options(headers: headers));
      print(headers);
      return response.data;
    } on DioError catch (e) {
      print(e.message);
      return e.response!.data;
    }
  }

  Future<dynamic> confirmmpin(
      String userId, String password, String deviceId, String mode) async {
    try {
      Response response =
          await _dio.post(ApiConstants.baseUrl + ApiConstants.confirmforgotmpin,
              data: {
                'userId': userId,
                'password': password,
                'deviceId': deviceId,
                'mode': mode,
              },
              options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
