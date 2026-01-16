import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

/// Remote data source for authentication API calls
abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register(
    String email,
    String password,
    String? fullName,
  );
  Future<TokenResponse> refreshToken(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> register(
    String email,
    String password,
    String? fullName,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          if (fullName != null) 'full_name': fullName,
        },
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      return TokenResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put(ApiConstants.me, data: data);
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('error')) {
        return data['error'] as String;
      }
      return 'Server error: ${e.response!.statusCode}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Server may be starting up, please try again.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server is taking too long to respond. Please try again.';
    } else {
      return 'Network error. Please check your connection.';
    }
  }
}
