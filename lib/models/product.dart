class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int targetAmount;
  final int currentSoldAmount;
  final String campaignId;
  final String? description;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.targetAmount,
    required this.currentSoldAmount,
    required this.campaignId,
    this.description,
  });

  double get soldPercentage =>
      targetAmount > 0 ? (currentSoldAmount / targetAmount) * 100 : 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price']?.toDouble() ?? 0.0,
      targetAmount: json['targetAmount'] ?? 0,
      currentSoldAmount: json['currentSoldAmount'] ?? 0,
      campaignId: json['campaignId'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'targetAmount': targetAmount,
      'currentSoldAmount': currentSoldAmount,
      'campaignId': campaignId,
      'description': description,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? targetAmount,
    int? currentSoldAmount,
    String? campaignId,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      targetAmount: targetAmount ?? this.targetAmount,
      currentSoldAmount: currentSoldAmount ?? this.currentSoldAmount,
      campaignId: campaignId ?? this.campaignId,
      description: description ?? this.description,
    );
  }
}
