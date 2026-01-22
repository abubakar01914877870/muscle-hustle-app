/// API Configuration
class ApiConstants {
  // Base URL - Update this with your production URL
  static const String baseUrl = 'http://127.0.0.1:5000';
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  static const String workouts = '/workouts';
  static const String exercises = '/exercises';
  static const String progress = '/progress';
  static const String dietPlans = '/diet-plans';
  static const String blog = '/blog';
  static const String community = '/community';
  static const String planner = '/planner';

  // Sync endpoints
  static const String syncWorkouts = '/workouts/sync';
  static const String syncExercises = '/exercises/sync';
  static const String syncProgress = '/progress/sync';
  static const String syncDietPlans = '/diet-plans/sync';

  // Timeouts
  static const Duration connectTimeout = Duration(
    seconds: 60,
  ); // For cold server
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// Storage Keys
class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String lastSyncTime = 'last_sync_time';
}

/// Database Constants
class DatabaseConstants {
  static const String databaseName = 'muscle_hustle.db';
  static const int databaseVersion = 1;
}

/// App Constants
class AppConstants {
  static const String appName = 'Muscle Hustle';
  static const int itemsPerPage = 20;
  static const int maxImageSize = 2 * 1024 * 1024; // 2MB
  static const int imageQuality = 85;
}
