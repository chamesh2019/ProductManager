class User {
  final String? id;
  final String fullName;
  final String? nic;
  final String? avatarUrl;
  final DateTime? createdAt;

  const User({
    this.id,
    required this.fullName,
    this.nic,
    this.avatarUrl,
    this.createdAt,
  });

  // Generate normalized identifier from full name
  static String normalizeFullName(String fullName) {
    return fullName
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
  }

  // Generate user ID from NIC, or use normalized name if NIC is not available
  String generateUserId() {
    if (nic != null && nic!.isNotEmpty) {
      return nic!;
    }
    return normalizeFullName(fullName);
  }

  // Get normalized full name for comparison
  String get normalizedFullName => normalizeFullName(fullName);

  // Create a User from Firestore data
  factory User.fromFirestore(Map<String, dynamic> data, String docId) {
    return User(
      id: data['id'] ?? docId,
      fullName: data['fullName'] ?? '',
      nic: data['nic'],
      avatarUrl: data['avatarUrl'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  // Convert User to Firestore data
  Map<String, dynamic> toFirestore() {
    final userId = generateUserId();
    return {
      'id': userId,
      'fullName': fullName,
      'normalizedFullName': normalizedFullName,
      'nic': nic,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
    };
  }

  // Convert User to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'nic': nic,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create User from JSON for local storage
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      nic: json['nic'],
      avatarUrl: json['avatarUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  // Create a copy of the user with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? nic,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nic: nic ?? this.nic,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
