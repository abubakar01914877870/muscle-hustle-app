class ExerciseModel {
  final String id;
  final String name;
  final String? description;
  final String? muscleGroup;
  final String? equipment;
  final String? gifUrl;

  final String? instructions;
  final String? category;
  final bool isCustom;
  final String? videoUrl;

  ExerciseModel({
    required this.id,
    required this.name,
    this.description,
    this.muscleGroup,
    this.equipment,
    this.gifUrl,
    this.instructions,
    this.category,
    this.isCustom = false,
    this.videoUrl,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      muscleGroup: json['muscle_group'] as String?,
      equipment: json['equipment'] as String?,
      gifUrl:
          json['gif_url'] as String? ??
          json['image_url'] as String?, // Handle API variations
      instructions: json['instructions'] as String?,
      category: json['category'] as String?,
      isCustom: json['is_custom'] as bool? ?? false,
      videoUrl: json['video_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscle_group': muscleGroup,
      'equipment': equipment,
      'gif_url': gifUrl,
      'instructions': instructions,
      'category': category,
      'is_custom': isCustom,
    };
  }
}
