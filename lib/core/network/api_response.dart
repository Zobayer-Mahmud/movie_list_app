import 'package:dio/dio.dart';

class ApiResponse {
  final bool success;
  final Response? response;
  final dynamic error;

  ApiResponse(this.success, this.response, this.error);

  ApiResponse.withError(dynamic errorValue)
    : success = false,
      response = null,
      error = errorValue;

  ApiResponse.withSuccess(Response? responseValue)
    : success = true,
      response = responseValue,
      error = null;

  dynamic get data => response?.data;
  int? get statusCode => response?.statusCode;
  bool get isSuccess => success;
}
