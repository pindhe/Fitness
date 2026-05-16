class MembershipPlan {
  final String id;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final String description;
  final List<String> features;
  final List<String> excludedFeatures;
  final bool isPopular;
  final String iconName;
  final int accentColor; // Hex color value

  MembershipPlan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.description,
    required this.features,
    this.excludedFeatures = const [],
    this.isPopular = false,
    required this.iconName,
    required this.accentColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'description': description,
      'features': features,
      'excludedFeatures': excludedFeatures,
      'isPopular': isPopular,
      'iconName': iconName,
      'accentColor': accentColor,
    };
  }

  factory MembershipPlan.fromMap(Map<String, dynamic> map, String id) {
    return MembershipPlan(
      id: id,
      name: map['name'] ?? '',
      monthlyPrice: (map['monthlyPrice'] ?? 0).toDouble(),
      yearlyPrice: (map['yearlyPrice'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      features: List<String>.from(map['features'] ?? []),
      excludedFeatures: List<String>.from(map['excludedFeatures'] ?? []),
      isPopular: map['isPopular'] ?? false,
      iconName: map['iconName'] ?? 'zap',
      accentColor: map['accentColor'] ?? 0xFF00FF9D,
    );
  }
}
