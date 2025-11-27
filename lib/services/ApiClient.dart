import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentivisor/utils/AppLogger.dart';
import '../core/network/api_config.dart';
import '../core/network/mentee_endpoints.dart';
import '../utils/CrashlyticsDioInterceptor.dart';
import '../utils/constants.dart';
import 'AuthService.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      // We accept all statuses so responses reach onResponse; we’ll log 4xx/5xx ourselves.
      validateStatus: (_) => true,
    ),
  );

  static void setupInterceptors() {
    try {
      _dio.interceptors.clear();

      // 1) Console logging in debug
      _dio.interceptors.add(
        LogInterceptor(
          request: kDebugMode,
          requestHeader: kDebugMode,
          requestBody: kDebugMode,
          responseHeader: kDebugMode,
          responseBody: kDebugMode,
          error: true,
        ),
      );

      // 2) Crashlytics
      _dio.interceptors.add(CrashlyticsDioInterceptor());

      // 3) Auth & navigation wrapper
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // final isUnauthenticated = _unauthenticatedEndpoints.any(
            //       (endpoint) => options.uri.path.startsWith(endpoint),
            // );
            //
            // // Attach feature name optionally: options.extra['feature'] = 'profile_update';
            // // Allow opt-out per call: options.extra['skipCrashlytics'] = true;
            //
            // if (isUnauthenticated) {
            //   return handler.next(options);
            // }

            final isGuestUser = await AuthService.isGuest;
            if (isGuestUser) {
              debugPrint('Guest user → skipping token for ${options.uri}');
              options.headers.remove('Authorization');
              return handler.next(options);
            }

            final isExpired = await AuthService.isTokenExpired();
            if (isExpired) {
              debugPrint('Token expired → trying refresh...');
              // final refreshed = await _refreshToken();
              // if (!refreshed) {
              //   debugPrint('❌ Token refresh failed, logging out...');
              //   await AuthService.logout();
              //   return handler.reject(
              //     DioException(
              //       requestOptions: options,
              //       error: 'Token refresh failed, please log in again',
              //       type: DioExceptionType.cancel,
              //     ),
              //   );
              // }
            }

            final accessToken = await AuthService.getAccessToken();
            if (accessToken?.isNotEmpty == true) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            } else {
              debugPrint('⚠️ Non-guest but no token found');
            }

            return handler.next(options);
          },

          onResponse: (response, handler) async {
            // Backend-driven token expiry (business status)
            if (response.data is Map<String, dynamic>) {
              final data = response.data as Map<String, dynamic>;
              if (data['status'] == false && data['message'] == 'Token is expired') {
                await AuthService.logout();
                return handler.reject(
                  DioException(
                    requestOptions: response.requestOptions,
                    error: 'Token expired',
                    response: response,
                    type: DioExceptionType.badResponse,
                  ),
                );
              }
            }

            // Optional: central navigation on certain status codes
            _handleNavigation(response.statusCode, navigatorKey);

            return handler.next(response);
          },
        ),
      );
      // 2) Global status handling interceptor
      _dio.interceptors.add(
        InterceptorsWrapper(
          onResponse: (response, handler) async {
            final status = response.statusCode ?? 0;

            if (status >= 200 && status <= 400) {
              // success
              return handler.next(response);
            }
            // 4xx arrive here because validateStatus(<500) returns true
            if (status == 401) {
              debugPrint('❌ 401 Unauthorized, logging out...');
              await AuthService.logout();
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  error: 'Unauthorized, please log in again',
                  type: DioExceptionType.badResponse,
                ),
              );
            }

            if (status == 403) {
              debugPrint('❌ 403 Account Blocked');
              final context = navigatorKey.currentContext;
              context?.go('/blocked_account');
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  error: 'Your account is blocked',
                  type: DioExceptionType.badResponse,
                ),
              );
            }

            // Any other 4xx -> normalize as DioException so repos/cubits can handle uniformly
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: 'Request failed (${response.statusCode})',
                type: DioExceptionType.badResponse,
              ),
            );
          },

          onError: (DioException e, handler) {
            // Only 5xx (and network/timeout/cancel) reach here due to validateStatus(<500)
            final code = e.response?.statusCode;

            if (code == 401) {
              // defensive: if a 401 still ends up here
              AuthService.logout();
              return handler.next(
                DioException(
                  requestOptions: e.requestOptions,
                  response: e.response,
                  error: 'Unauthorized, please log in again',
                  type: DioExceptionType.badResponse,
                ),
              );
            }

            if (code == 403) {
              final context = navigatorKey.currentContext;
              context?.go('/blocked_account');
              return handler.next(
                DioException(
                  requestOptions: e.requestOptions,
                  response: e.response,
                  error: 'Your account is blocked',
                  type: DioExceptionType.badResponse,
                ),
              );
            }

            // Optionally map timeouts / no-internet to friendly errors
            if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout) {
              return handler.next(
                DioException(
                  requestOptions: e.requestOptions,
                  error: 'Network timeout, please try again',
                  type: e.type,
                  response: e.response,
                ),
              );
            }

            if (e.type == DioExceptionType.connectionError) {
              return handler.next(
                DioException(
                  requestOptions: e.requestOptions,
                  error: 'No internet connection',
                  type: e.type,
                  response: e.response,
                ),
              );
            }

            // leave others as-is (includes 5xx)
            return handler.next(e);
          },
        ),
      );
    } catch (e, stackTrace) {
      // Record unexpected setup failures
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
    }
  }

  // --- HTTP verbs (unchanged except passing options through) ---

  static Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      AppLogger.log("called get method");
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.post(path, data: data, options: options);
    } catch (e) {
      return _handleError(e);
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
      return _handleError(e);
    }
  }

  static Future<Response> delete(String path, {Options? options}) async {
    try {
      return await _dio.delete(path, options: options);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Never _handleError(dynamic error) {
    if (error is DioException) {
      throw error; // already captured by interceptor
    } else {
      final ex = Exception("Unexpected error occurred");
      FirebaseCrashlytics.instance.recordError(error, StackTrace.current, fatal: false);
      throw ex;
    }
  }


  static void _handleNavigation(
      int? statusCode,
      GlobalKey<NavigatorState> navigatorKey,
      ) {
    // Example: if (statusCode == 403) navigatorKey.currentState?.pushNamed('/no-access');
  }
}

