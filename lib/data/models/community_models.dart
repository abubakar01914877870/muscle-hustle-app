import 'dart:io';
import '../../core/constants/api_constants.dart';

class GymModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String phone;
  final String googleMapLink;
  final String address;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  GymModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.phone,
    required this.googleMapLink,
    required this.address,
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      googleMapLink: json['google_map_link'] as String,
      address: json['address'] as String,
      images:
          (json['images'] as List?)
              ?.map((e) => _ensureAbsoluteUrl(e as String))
              .toList() ??
          [],
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return HttpDate.parse(dateStr.toString());
    } catch (_) {
      try {
        return DateTime.parse(dateStr.toString());
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  static String _ensureAbsoluteUrl(String url) {
    // Cloudinary URLs and other absolute URLs
    if (url.startsWith('http')) return url;
    // Remove leading slash if present to avoid double slashes
    final cleanPath = url.startsWith('/') ? url.substring(1) : url;
    return '${ApiConstants.baseUrl}/$cleanPath';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'phone': phone,
      'google_map_link': googleMapLink,
      'address': address,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TrainerModel {
  final String id;
  final String email;
  final String fullName;
  final String? slug;
  final String? profilePicture;
  final Map<String, dynamic> profile;
  final bool isTrainer;

  TrainerModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.slug,
    this.profilePicture,
    required this.profile,
    this.isTrainer = false,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    String? pic = json['profile_picture'] as String?;
    if (pic != null && !pic.startsWith('http')) {
      final cleanPath = pic.startsWith('/') ? pic.substring(1) : pic;
      pic = '${ApiConstants.baseUrl}/$cleanPath';
    }

    return TrainerModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      slug: json['slug'] as String?,
      profilePicture: pic,
      profile: json['trainer_profile'] as Map<String, dynamic>? ?? {},
      isTrainer: json['is_trainer'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'full_name': fullName,
      'slug': slug,
      'profile_picture': profilePicture,
      'trainer_profile': profile,
      'is_trainer': isTrainer,
    };
  }
}
