import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/models/product.dart';

void main() {
  group('Product Model', () {
    test('should create a Product with correct values', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: 10.0,
        imageUrl: 'http://example.com/image.png',
        targetAmount: 1000,
        currentSoldAmount: 900,
        campaignId: 'campaign1',
      );
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, 10.0);
      expect(product.imageUrl, 'http://example.com/image.png');
      expect(product.targetAmount, 1000);
      expect(product.currentSoldAmount, 900);
      expect(product.campaignId, 'campaign1');
    });
  });
}
