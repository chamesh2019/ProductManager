import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/product_change_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('ProductChangeLog Tests', () {
    test('should create ProductChangeLog from JSON correctly', () {
      final json = {
        'id': 'log_123',
        'productId': 'prod_123',
        'productName': 'Test Product',
        'userId': 'user_123',
        'userName': 'John Doe',
        'changeType': 'sales_update',
        'oldValues': {'currentSoldAmount': 10},
        'newValues': {'currentSoldAmount': 15},
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'notes': 'Updated sales amount',
      };

      final changeLog = ProductChangeLog.fromJson(json);

      expect(changeLog.id, equals('log_123'));
      expect(changeLog.productId, equals('prod_123'));
      expect(changeLog.productName, equals('Test Product'));
      expect(changeLog.userId, equals('user_123'));
      expect(changeLog.userName, equals('John Doe'));
      expect(changeLog.changeType, equals('sales_update'));
      expect(changeLog.oldValues['currentSoldAmount'], equals(10));
      expect(changeLog.newValues['currentSoldAmount'], equals(15));
      expect(changeLog.notes, equals('Updated sales amount'));
    });

    test('should generate correct change description', () {
      final changeLog = ProductChangeLog(
        id: 'log_123',
        productId: 'prod_123',
        productName: 'Test Product',
        userId: 'user_123',
        userName: 'John Doe',
        changeType: 'sales_update',
        oldValues: {'currentSoldAmount': 10, 'price': 25.0},
        newValues: {'currentSoldAmount': 15, 'price': 30.0},
        timestamp: DateTime.now(),
      );

      final description = changeLog.getChangeDescription();

      expect(description, contains('Sold Amount: 10 → 15'));
      expect(description, contains('Price: 25.0 → 30.0'));
    });

    test('should convert to JSON correctly', () {
      final now = DateTime.now();
      final changeLog = ProductChangeLog(
        id: 'log_123',
        productId: 'prod_123',
        productName: 'Test Product',
        userId: 'user_123',
        userName: 'John Doe',
        changeType: 'sales_update',
        oldValues: {'currentSoldAmount': 10},
        newValues: {'currentSoldAmount': 15},
        timestamp: now,
        notes: 'Test notes',
      );

      final json = changeLog.toJson();

      expect(json['id'], equals('log_123'));
      expect(json['productId'], equals('prod_123'));
      expect(json['productName'], equals('Test Product'));
      expect(json['userId'], equals('user_123'));
      expect(json['userName'], equals('John Doe'));
      expect(json['changeType'], equals('sales_update'));
      expect(json['oldValues']['currentSoldAmount'], equals(10));
      expect(json['newValues']['currentSoldAmount'], equals(15));
      expect(json['timestamp'], isA<Timestamp>());
      expect(json['notes'], equals('Test notes'));
    });
  });
}
