class Workout {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., 'Strength', 'Cardio', 'HIIT'
  final String level; // 'Beginner', 'Intermediate', 'Advanced', 'Pro Athlete'
  final String? thumbnailUrl;
  final String? videoUrl;
  final String duration;
  final int calories;
  final List<String> equipment;
  final List<String> instructions;
  final List<String> tags;
  final String trainerName;
  final int videoCount;
  final bool isPublished;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    this.thumbnailUrl,
    this.videoUrl,
    required this.duration,
    required this.calories,
    required this.equipment,
    required this.instructions,
    required this.tags,
    required this.trainerName,
    this.videoCount = 1,
    this.isPublished = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'level': level,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'calories': calories,
      'equipment': equipment,
      'instructions': instructions,
      'tags': tags,
      'trainerName': trainerName,
      'videoCount': videoCount,
      'isPublished': isPublished,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    return Workout(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Strength',
      level: map['level'] ?? 'Beginner',
      thumbnailUrl: map['thumbnailUrl'],
      videoUrl: map['videoUrl'],
      duration: map['duration'] ?? '',
      calories: map['calories'] ?? 0,
      equipment: List<String>.from(map['equipment'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      trainerName: map['trainerName'] ?? '',
      videoCount: map['videoCount'] ?? 1,
      isPublished: map['isPublished'] ?? true,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
