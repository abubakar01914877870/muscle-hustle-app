import '../models/user_model.dart';
import '../remote/auth_remote_data_source.dart';
import '../../services/storage_service.dart';

/// Authentication repository combining remote and local data sources
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storage;

  AuthRepository(this._remoteDataSource, this._storage);

  /// Login with email and password
  Future<UserModel> login(String email, String password) async {
    final response = await _remoteDataSource.login(email, password);

    // Save tokens
    await _storage.saveTokens(response.accessToken, response.refreshToken);

    // Save user info
    await _storage.saveUserInfo(response.user.id, response.user.email);

    return response.user;
  }

  /// Register new user
  Future<UserModel> register(
    String email,
    String password,
    String? fullName,
  ) async {
    final response = await _remoteDataSource.register(
      email,
      password,
      fullName,
    );

    // Save tokens
    await _storage.saveTokens(response.accessToken, response.refreshToken);

    // Save user info
    await _storage.saveUserInfo(response.user.id, response.user.email);

    return response.user;
  }

  /// Get current user from API
  Future<UserModel> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  /// Update user profile
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    return await _remoteDataSource.updateProfile(data);
  }

  /// Logout user
  Future<void> logout() async {
    await _storage.clearAll();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.hasTokens();
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _storage.getUserId();
  }
}
