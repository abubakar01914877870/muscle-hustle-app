/// User model for API responses
class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final bool isAdmin;
  final bool isTrainer;
  final String? profilePicture;
  final double? height;
  final double? weight;
  final double? targetWeight;
  final String? fitnessLevel;
  final String? fitnessGoal;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.isAdmin = false,
    this.isTrainer = false,
    this.profilePicture,
    this.height,
    this.weight,
    this.targetWeight,
    this.fitnessLevel,
    this.fitnessGoal,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      isTrainer: json['is_trainer'] as bool? ?? false,
      profilePicture: json['profile_picture'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      fitnessLevel: json['fitness_level'] as String?,
      fitnessGoal: json['fitness_goal'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'is_admin': isAdmin,
      'is_trainer': isTrainer,
      'profile_picture': profilePicture,
      'height': height,
      'weight': weight,
      'target_weight': targetWeight,
      'fitness_level': fitnessLevel,
      'fitness_goal': fitnessGoal,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Authentication response model
class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}

/// Token refresh response model
class TokenResponse {
  final String accessToken;

  TokenResponse({required this.accessToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(accessToken: json['access_token'] as String);
  }
}
