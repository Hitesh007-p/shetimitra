class User {
  final String name;
  final String? address;
  final String? profilePhotoPath;
  final List<String> selectedCrops;
  final DateTime createdAt;

  User({
    required this.name,
    this.address,
    this.profilePhotoPath,
    required this.selectedCrops,
    required this.createdAt,
  });

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'profilePhotoPath': profilePhotoPath,
      'selectedCrops': selectedCrops,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      address: json['address'] as String?,
      profilePhotoPath: json['profilePhotoPath'] as String?,
      selectedCrops: List<String>.from(json['selectedCrops'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Create a copy with modifications
  User copyWith({
    String? name,
    String? address,
    String? profilePhotoPath,
    List<String>? selectedCrops,
    DateTime? createdAt,
  }) {
    return User(
      name: name ?? this.name,
      address: address ?? this.address,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      selectedCrops: selectedCrops ?? this.selectedCrops,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
