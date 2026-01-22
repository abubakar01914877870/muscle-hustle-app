import 'exercise_model.dart';

class WorkoutModel {
  final String id;
  final String name;
  final String? description;
  final int duration;
  final String difficulty;
  final bool isCustom;
  final List<ExerciseModel>? exercises;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutModel({
    required this.id,
    required this.name,
    this.description,
    required this.duration,
    required this.difficulty,
    this.isCustom = true,
    required this.createdAt,
    required this.updatedAt,
    this.exercises,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Intermediate',
      isCustom: true, // Plans are usually custom or system
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: DateTime.now(), // Field might not exist in API yet
      exercises: (json['exercises'] as List?)
          ?.map((e) => ExerciseModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'is_custom': isCustom,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
