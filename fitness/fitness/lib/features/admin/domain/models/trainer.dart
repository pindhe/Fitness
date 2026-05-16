class Trainer {
  final String id;
  final String name;
  final String level; // e.g., 'Master', 'Senior', 'Junior'
  final String specialty;
  final String bio;
  final String? videoUrl;
  final String? imageUrl;
  final int yearsOfExperience;

  Trainer({
    required this.id,
    required this.name,
    required this.level,
    required this.specialty,
    required this.bio,
    this.videoUrl,
    this.imageUrl,
    required this.yearsOfExperience,
  });

  factory Trainer.fromMap(Map<String, dynamic> map, String id) {
    return Trainer(
      id: id,
      name: map['name'] ?? '',
      level: map['level'] ?? 'Junior',
      specialty: map['specialty'] ?? '',
      bio: map['bio'] ?? '',
      videoUrl: map['videoUrl'],
      imageUrl: map['imageUrl'],
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
      'specialty': specialty,
      'bio': bio,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'yearsOfExperience': yearsOfExperience,
    };
  }
}
