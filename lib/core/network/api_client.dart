import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../services/storage_service.dart';

/// Dio HTTP client with JWT authentication
class ApiClient {
  late final Dio dio;
  final StorageService _storage;

  ApiClient(this._storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_AuthInterceptor(_storage, dio));
    dio.interceptors.add(_LoggingInterceptor());
  }
}

/// Interceptor to add JWT token to requests
class _AuthInterceptor extends Interceptor {
  final StorageService _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token
    final accessToken = await _storage.getAccessToken();

    // Add token to header if available
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      try {
        // Try to refresh token
        final refreshToken = await _storage.getRefreshToken();

        if (refreshToken != null) {
          // Call refresh endpoint
          final response = await _dio.post(
            '${ApiConstants.apiBaseUrl}${ApiConstants.refreshToken}',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            // Save new access token
            final newAccessToken = response.data['access_token'];
            final oldRefreshToken = await _storage.getRefreshToken();
            await _storage.saveTokens(newAccessToken, oldRefreshToken!);

            // Retry original request with new token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await _dio.fetch(opts);
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        // Refresh failed, clear tokens
        await _storage.clearAll();
      }
    }

    handler.next(err);
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 REQUEST[${options.method}] => ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}');
    handler.next(err);
  }
}
