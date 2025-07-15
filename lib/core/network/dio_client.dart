import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'api_response.dart';

typedef MapData = Map<String, dynamic>;

class DioClient extends g.GetxService {
  late Dio _dio;
  Map<String, String?>? _header;
  final Connectivity _connectivity = Connectivity();

  static DioClient get to => g.Get.find();

  Future<DioClient> init() async {
    // Get environment variables with fallbacks
    final baseUrl =
        dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
    final bearerToken =
        dotenv.env['TMDB_BEARER_TOKEN'] ??
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNWM3MzllZjQyMmIxZTgzYWU0NTE1MmNhZmJhMDA0NyIsIm5iZiI6MTc1MjYwMjQ5MC4yODksInN1YiI6IjY4NzY5NzdhODQzNzZiOGE5ODg5NjI2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.hoxnMardhsWUqGUdJ7PFAjXBOO1RK0TsgLj8_J-2hSo';

    _header = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    };

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: _header,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Check network connectivity
          final connectivityResult = await _connectivity.checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          // Update headers
          _dio.options.headers = _header;

          // Log request
          if (kDebugMode) {
            print('🚀 REQUEST: ${options.method} ${options.uri}');
            if (options.data != null) {
              print('📦 DATA: ${options.data}');
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          if (kDebugMode) {
            print(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          if (kDebugMode) {
            print('❌ ERROR: ${error.message}');
            print('🔗 URL: ${error.requestOptions.uri}');
          }

          handler.next(error);
        },
      ),
    );

    return this;
  }

  // GET request
  Future<ApiResponse> get({
    required String endpoint,
    MapData? queryParams,
  }) async {
    queryParams?.removeWhere((key, value) => value == "null" || value == null);

    if (kDebugMode) {
      final uri = Uri(
        scheme: _dio.options.baseUrl.startsWith('https') ? 'https' : 'http',
        host: Uri.parse(_dio.options.baseUrl).host,
        path: endpoint,
        queryParameters: queryParams?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
      print('➡️ Hitting GET: ${uri.toString()}');
    }

    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (e is DioException) {
        _handleDioError(e);
      }
      return ApiResponse.withError(e);
    }
  }

  // POST request
  Future<ApiResponse> post({
    required String endpoint,
    MapData? data,
    MapData? queryParams,
  }) async {
    queryParams?.removeWhere((key, value) => value == "null" || value == null);
    data?.removeWhere((key, value) => value == "null" || value == null);

    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (e is DioException) {
        _handleDioError(e);
      }
      return ApiResponse.withError(e);
    }
  }

  // PUT request
  Future<ApiResponse> put({required String endpoint, MapData? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (e is DioException) {
        _handleDioError(e);
      }
      return ApiResponse.withError(e);
    }
  }

  // DELETE request
  Future<ApiResponse> delete({required String endpoint, MapData? data}) async {
    data?.removeWhere((key, value) => value == "null" || value == null);

    try {
      final response = await _dio.delete(endpoint, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (e is DioException) {
        _handleDioError(e);
      }
      return ApiResponse.withError(e);
    }
  }

  // PATCH request
  Future<ApiResponse> patch({required String endpoint, MapData? data}) async {
    data?.removeWhere((key, value) => value == "null" || value == null);

    try {
      final response = await _dio.patch(endpoint, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      if (e is DioException) {
        _handleDioError(e);
      }
      return ApiResponse.withError(e);
    }
  }

  void _handleDioError(DioException error) {
    if (kDebugMode) {
      print('DioException Type: ${error.type}');
      print('DioException Message: ${error.message}');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _showErrorSnackbar('Connection Timeout');
        break;
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          _showErrorSnackbar('Unauthorized access');
        } else if (error.response?.data != null) {
          final message = error.response?.data['message'] ?? 'Bad Request';
          _showErrorSnackbar(message);
        } else {
          _showErrorSnackbar('Bad Request');
        }
        break;
      case DioExceptionType.cancel:
        _showErrorSnackbar('Request Cancelled');
        break;
      case DioExceptionType.connectionError:
        _showErrorSnackbar('No internet connection');
        break;
      default:
        _showErrorSnackbar('Something went wrong');
    }
  }

  void _showErrorSnackbar(String message) {
    g.Get.snackbar(
      'Error',
      message,
      snackPosition: g.SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
