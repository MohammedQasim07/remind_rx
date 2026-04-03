import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient(this.dio) {
    dio.options.baseUrl = 'https://his-reminder.bitxero-iq.com';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from secure storage
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add Language Header (Default to English if not set)
          // In a real app, this would come from a localization service
          options.headers['Accept-Language'] = options.headers['Accept-Language'] ?? 'en';
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors (e.g., 401 Unauthorized)
          if (e.response?.statusCode == 401) {
            // Logic to logout or refresh token
          }
          return handler.next(e);
        },
      ),
    );

    // Logging for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
