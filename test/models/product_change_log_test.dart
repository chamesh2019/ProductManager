import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/models/product_change_log.dart';

void main() {
  group('ProductChangeLog Model', () {
    test('should create a ProductChangeLog with correct values', () {
      final log = ProductChangeLog(
        id: '1',
        productId: 'p1',
        productName: 'Test Product',
        changeType: 'update',
        userId: 'u1',
        userName: 'Test User',
        oldValues: {"price": 10.0},
        newValues: {"price": 12.0},
        timestamp: DateTime(2025, 7, 31),
      );
      expect(log.id, '1');
      expect(log.productId, 'p1');
      expect(log.productName, 'Test Product');
      expect(log.userId, 'u1');
      expect(log.userName, 'Test User');
      expect(log.oldValues, {"price": 10.0});
      expect(log.newValues, {"price": 12.0});
      expect(log.changeType, 'update');
      expect(log.timestamp, DateTime(2025, 7, 31));
    });
  });
}
