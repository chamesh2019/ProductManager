class Campaign {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final double? budget;
  final String? imageUrl;
  final String pin;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.pin,
    this.budget,
    this.imageUrl,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      pin: json['pin'] ?? '000000', // Default PIN for legacy campaigns
      budget: json['budget']?.toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'pin': pin,
      'budget': budget,
      'imageUrl': imageUrl,
    };
  }

  Campaign copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? pin,
    double? budget,
    String? imageUrl,
  }) {
    return Campaign(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      pin: pin ?? this.pin,
      budget: budget ?? this.budget,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
