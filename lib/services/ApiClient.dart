import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../core/network/api_config.dart';
import '../core/network/mentee_endpoints.dart';
import '../utils/CrashlyticsDioInterceptor.dart';
import '../utils/constants.dart';
import 'AuthService.dart';
import 'NotificationService.dart';

class ApiClient {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      /// Accept EVERY status so response never throws automatically.
      validateStatus: (_) => true,
    ),
  );

  static void setupInterceptors() {
    _dio.interceptors.clear();

    // ---------------------------
    // 1) Logging (debug only)
    // ---------------------------
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    // ---------------------------
    // 2) Crashlytics
    // ---------------------------
    _dio.interceptors.add(CrashlyticsDioInterceptor());

    // ---------------------------
    // 3) Authentication + token attach
    // ---------------------------
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip if guest
          if (await AuthService.isGuest) {
            options.headers.remove('Authorization');
            return handler.next(options);
          }

          // Token expired?
          if (await AuthService.isTokenExpired()) {
            debugPrint("🔄 Token expired — refresh disabled but handled.");
            // If refresh needed, plug refresh logic here.
          }

          final token = await AuthService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    // ---------------------------
    // 4) GLOBAL RESPONSE HANDLING
    // ---------------------------
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          final status = response.statusCode ?? 0;

          if (response.data is Map) {
            final data = response.data as Map;

            // 🔴 Token expired
            if (data['message'] == 'Token is expired') {
              await AuthService.logout();
              return handler.next(response); // ✅ DO NOT reject
            }
          }

          // 🔴 Unauthorized
          if (status == 401) {
            await AuthService.logout();
            return handler.next(response); // ✅ DO NOT reject
          }

          // 🔴 Account blocked
          if (status == 403) {
            debugPrint("🚫 Account blocked — redirecting");
            _storage.deleteAll();
            debugPrint('Tokens cleared, user logged out');
            rootNavigatorKey.currentContext?.go('/blocked_account');
            return handler.next(response); // ✅ PASS RESPONSE
          }

          // ✅ Accept everything else
          return handler.next(response);
        },

        onError: (e, handler) {
          // Timeout
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            return handler.next(
              DioException(
                requestOptions: e.requestOptions,
                error: 'Connection timed out',
                type: DioExceptionType.connectionTimeout,
              ),
            );
          }

          // No Internet
          if (e.type == DioExceptionType.connectionError) {
            return handler.next(
              DioException(
                requestOptions: e.requestOptions,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          return handler.next(e);
        },
      ),
    );

  }

  // --------------------------------------------------------
  // UNIVERSAL METHODS — always return Response, never throw
  // --------------------------------------------------------
  static Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      AppLogger.log("called get method");
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _wrapError(e); // <-- FIX
    }
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.post(path, data: data, options: options);
    } catch (e) {
      throw _wrapError(e);
    }
  }

  static Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.put(path, data: data, options: options);
    } catch (e) {
      throw _wrapError(e);
    }
  }

  static Future<Response> delete(String path, {Options? options}) async {
    try {
      return await _dio.delete(path, options: options);
    } catch (e) {
      throw _wrapError(e);
    }
  }

  // --------------------------------------------------------
  // Convert unexpected errors to safe exceptions
  // --------------------------------------------------------
  static DioException _wrapError(dynamic error) {
    if (error is DioException) return error;

    FirebaseCrashlytics.instance.recordError(error, StackTrace.current);
    return DioException(
      requestOptions: RequestOptions(),
      error: "Unexpected error occurred",
      type: DioExceptionType.unknown,
    );
  }
}
