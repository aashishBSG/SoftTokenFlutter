

import 'package:dio/dio.dart';
import 'package:flutter_soft_token/dio/api_constants.dart';

enum CallType { get, post }

String token = "";

class MyHttpClient {
  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'token': token,
    // 'token': ApiConstants.token,
    'X-channel': 'M',
    'X-Mobile-Platform': ApiConstants.mobile_platform,
    'X-Mobile-Version': ApiConstants.version_code.toString(),
  };

  final Dio _dio = Dio();

  MyHttpClient() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = 5000; // 5 seconds
    _dio.options.receiveTimeout = 5000; // 5 seconds
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required String token,
    Function(bool isLoading)? onLoadingStateChanged,
  }) async {
    try {
      if (onLoadingStateChanged != null) {
        onLoadingStateChanged(true);
      }
      final response = await _dio.post(path,
          queryParameters: queryParameters, options: Options(headers: headers));

      if (onLoadingStateChanged != null) {
        onLoadingStateChanged(false);
      }
      return response.data;
    } on DioError catch (e) {
      if (onLoadingStateChanged != null) {
        onLoadingStateChanged(false);
      }
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioError error) {
    if (error.response != null) {
      final responseData = error.response!.data;

      throw Exception('API Error: ${responseData['message']}');
    } else {
      throw Exception('Network Error: ${error.message}');
    }
  }
}
