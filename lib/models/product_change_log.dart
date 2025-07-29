import 'package:cloud_firestore/cloud_firestore.dart';

class ProductChangeLog {
  final String id;
  final String productId;
  final String productName;
  final String userId;
  final String userName;
  final String changeType;
  final Map<String, dynamic> oldValues;
  final Map<String, dynamic> newValues;
  final DateTime timestamp;
  final String? notes;

  const ProductChangeLog({
    required this.id,
    required this.productId,
    required this.productName,
    required this.userId,
    required this.userName,
    required this.changeType,
    required this.oldValues,
    required this.newValues,
    required this.timestamp,
    this.notes,
  });

  factory ProductChangeLog.fromJson(Map<String, dynamic> json) {
    return ProductChangeLog(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      userId: json['userId'],
      userName: json['userName'],
      changeType: json['changeType'],
      oldValues: Map<String, dynamic>.from(json['oldValues'] ?? {}),
      newValues: Map<String, dynamic>.from(json['newValues'] ?? {}),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'userId': userId,
      'userName': userName,
      'changeType': changeType,
      'oldValues': oldValues,
      'newValues': newValues,
      'timestamp': Timestamp.fromDate(timestamp),
      'notes': notes,
    };
  }

  String getChangeDescription() {
    final changes = <String>[];

    for (final entry in newValues.entries) {
      final key = entry.key;
      final newValue = entry.value;
      final oldValue = oldValues[key];

      if (oldValue != newValue) {
        String fieldName = _getFieldDisplayName(key);
        changes.add('$fieldName: $oldValue → $newValue');
      }
    }

    return changes.join(', ');
  }

  String _getFieldDisplayName(String fieldName) {
    switch (fieldName) {
      case 'currentSoldAmount':
        return 'Sold Amount';
      case 'targetAmount':
        return 'Target Amount';
      case 'price':
        return 'Price';
      case 'name':
        return 'Name';
      case 'description':
        return 'Description';
      case 'imageUrl':
        return 'Image';
      default:
        return fieldName;
    }
  }
}
