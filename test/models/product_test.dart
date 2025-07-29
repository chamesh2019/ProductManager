import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Product constructor creates instance correctly', () {
      const product = Product(
        id: 'test-product-id',
        name: 'Test Product',
        imageUrl: '/path/to/product.jpg',
        price: 99.99,
        targetAmount: 100,
        currentSoldAmount: 25,
        campaignId: 'campaign-123',
        description: 'Test product description',
      );

      expect(product.id, equals('test-product-id'));
      expect(product.name, equals('Test Product'));
      expect(product.imageUrl, equals('/path/to/product.jpg'));
      expect(product.price, equals(99.99));
      expect(product.targetAmount, equals(100));
      expect(product.currentSoldAmount, equals(25));
      expect(product.campaignId, equals('campaign-123'));
      expect(product.description, equals('Test product description'));
    });

    test('Product constructor with optional description', () {
      const product = Product(
        id: 'test-product-id-2',
        name: 'Test Product 2',
        imageUrl: '/path/to/product2.jpg',
        price: 149.99,
        targetAmount: 50,
        currentSoldAmount: 10,
        campaignId: 'campaign-456',
      );

      expect(product.id, equals('test-product-id-2'));
      expect(product.name, equals('Test Product 2'));
      expect(product.imageUrl, equals('/path/to/product2.jpg'));
      expect(product.price, equals(149.99));
      expect(product.targetAmount, equals(50));
      expect(product.currentSoldAmount, equals(10));
      expect(product.campaignId, equals('campaign-456'));
      expect(product.description, isNull);
    });

    test('soldPercentage calculates correctly', () {
      const product1 = Product(
        id: 'product-1',
        name: 'Product 1',
        imageUrl: '/image1.jpg',
        price: 10.0,
        targetAmount: 100,
        currentSoldAmount: 25,
        campaignId: 'campaign-1',
      );

      expect(product1.soldPercentage, equals(25.0));

      const product2 = Product(
        id: 'product-2',
        name: 'Product 2',
        imageUrl: '/image2.jpg',
        price: 20.0,
        targetAmount: 200,
        currentSoldAmount: 150,
        campaignId: 'campaign-2',
      );

      expect(product2.soldPercentage, equals(75.0));

      const product3 = Product(
        id: 'product-3',
        name: 'Product 3',
        imageUrl: '/image3.jpg',
        price: 30.0,
        targetAmount: 50,
        currentSoldAmount: 50,
        campaignId: 'campaign-3',
      );

      expect(product3.soldPercentage, equals(100.0));
    });

    test('soldPercentage handles zero target amount', () {
      const product = Product(
        id: 'zero-target-product',
        name: 'Zero Target Product',
        imageUrl: '/zero.jpg',
        price: 5.0,
        targetAmount: 0,
        currentSoldAmount: 10,
        campaignId: 'campaign-zero',
      );

      expect(product.soldPercentage, equals(0.0));
    });

    test('soldPercentage handles zero current sold amount', () {
      const product = Product(
        id: 'zero-sold-product',
        name: 'Zero Sold Product',
        imageUrl: '/zerosold.jpg',
        price: 15.0,
        targetAmount: 100,
        currentSoldAmount: 0,
        campaignId: 'campaign-zerosold',
      );

      expect(product.soldPercentage, equals(0.0));
    });

    test('fromJson creates Product from valid JSON', () {
      final json = {
        'id': 'json-product-id',
        'name': 'JSON Product',
        'imageUrl': '/json/product.jpg',
        'price': 79.99,
        'targetAmount': 150,
        'currentSoldAmount': 45,
        'campaignId': 'json-campaign-id',
        'description': 'JSON product description',
      };

      final product = Product.fromJson(json);

      expect(product.id, equals('json-product-id'));
      expect(product.name, equals('JSON Product'));
      expect(product.imageUrl, equals('/json/product.jpg'));
      expect(product.price, equals(79.99));
      expect(product.targetAmount, equals(150));
      expect(product.currentSoldAmount, equals(45));
      expect(product.campaignId, equals('json-campaign-id'));
      expect(product.description, equals('JSON product description'));
    });

    test('fromJson handles missing optional and default values', () {
      final json = {
        'id': 'minimal-product-id',
        'name': 'Minimal Product',
        'imageUrl': '/minimal/product.jpg',
        'campaignId': 'minimal-campaign-id',
      };

      final product = Product.fromJson(json);

      expect(product.id, equals('minimal-product-id'));
      expect(product.name, equals('Minimal Product'));
      expect(product.imageUrl, equals('/minimal/product.jpg'));
      expect(product.price, equals(0.0));
      expect(product.targetAmount, equals(0));
      expect(product.currentSoldAmount, equals(0));
      expect(product.campaignId, equals('minimal-campaign-id'));
      expect(product.description, isNull);
    });

    test('fromJson handles string numbers correctly', () {
      final json = {
        'id': 'string-numbers-id',
        'name': 'String Numbers Product',
        'imageUrl': '/string/product.jpg',
        'price': '25.50',
        'targetAmount': '75',
        'currentSoldAmount': '30',
        'campaignId': 'string-campaign-id',
      };

      final product = Product.fromJson(json);

      expect(product.price, equals(25.50));
      expect(product.targetAmount, equals(75));
      expect(product.currentSoldAmount, equals(30));
    });

    test('toJson converts Product to JSON correctly', () {
      const product = Product(
        id: 'tojson-product-id',
        name: 'ToJSON Product',
        imageUrl: '/tojson/product.jpg',
        price: 59.99,
        targetAmount: 80,
        currentSoldAmount: 20,
        campaignId: 'tojson-campaign-id',
        description: 'ToJSON description',
      );

      final json = product.toJson();

      expect(json['id'], equals('tojson-product-id'));
      expect(json['name'], equals('ToJSON Product'));
      expect(json['imageUrl'], equals('/tojson/product.jpg'));
      expect(json['price'], equals(59.99));
      expect(json['targetAmount'], equals(80));
      expect(json['currentSoldAmount'], equals(20));
      expect(json['campaignId'], equals('tojson-campaign-id'));
      expect(json['description'], equals('ToJSON description'));
    });

    test('toJson handles null description', () {
      const product = Product(
        id: 'null-desc-id',
        name: 'Null Description Product',
        imageUrl: '/nulldesc/product.jpg',
        price: 39.99,
        targetAmount: 60,
        currentSoldAmount: 15,
        campaignId: 'nulldesc-campaign-id',
      );

      final json = product.toJson();

      expect(json['description'], isNull);
    });

    test('copyWith creates new instance with updated fields', () {
      const originalProduct = Product(
        id: 'original-product-id',
        name: 'Original Product',
        imageUrl: '/original/product.jpg',
        price: 49.99,
        targetAmount: 120,
        currentSoldAmount: 35,
        campaignId: 'original-campaign-id',
        description: 'Original description',
      );

      final updatedProduct = originalProduct.copyWith(
        name: 'Updated Product',
        price: 69.99,
        currentSoldAmount: 50,
      );

      expect(updatedProduct.id, equals('original-product-id'));
      expect(updatedProduct.name, equals('Updated Product'));
      expect(updatedProduct.imageUrl, equals('/original/product.jpg'));
      expect(updatedProduct.price, equals(69.99));
      expect(updatedProduct.targetAmount, equals(120));
      expect(updatedProduct.currentSoldAmount, equals(50));
      expect(updatedProduct.campaignId, equals('original-campaign-id'));
      expect(updatedProduct.description, equals('Original description'));
    });

    test('copyWith with all null parameters returns identical instance', () {
      const originalProduct = Product(
        id: 'identical-product-id',
        name: 'Identical Product',
        imageUrl: '/identical/product.jpg',
        price: 29.99,
        targetAmount: 90,
        currentSoldAmount: 40,
        campaignId: 'identical-campaign-id',
      );

      final copiedProduct = originalProduct.copyWith();

      expect(copiedProduct.id, equals(originalProduct.id));
      expect(copiedProduct.name, equals(originalProduct.name));
      expect(copiedProduct.imageUrl, equals(originalProduct.imageUrl));
      expect(copiedProduct.price, equals(originalProduct.price));
      expect(copiedProduct.targetAmount, equals(originalProduct.targetAmount));
      expect(
        copiedProduct.currentSoldAmount,
        equals(originalProduct.currentSoldAmount),
      );
      expect(copiedProduct.campaignId, equals(originalProduct.campaignId));
      expect(copiedProduct.description, equals(originalProduct.description));
    });

    test('JSON serialization round trip preserves data', () {
      const originalProduct = Product(
        id: 'roundtrip-product-id',
        name: 'Round Trip Product',
        imageUrl: '/roundtrip/product.jpg',
        price: 89.99,
        targetAmount: 110,
        currentSoldAmount: 55,
        campaignId: 'roundtrip-campaign-id',
        description: 'Round trip description',
      );

      final json = originalProduct.toJson();
      final reconstructedProduct = Product.fromJson(json);

      expect(reconstructedProduct.id, equals(originalProduct.id));
      expect(reconstructedProduct.name, equals(originalProduct.name));
      expect(reconstructedProduct.imageUrl, equals(originalProduct.imageUrl));
      expect(reconstructedProduct.price, equals(originalProduct.price));
      expect(
        reconstructedProduct.targetAmount,
        equals(originalProduct.targetAmount),
      );
      expect(
        reconstructedProduct.currentSoldAmount,
        equals(originalProduct.currentSoldAmount),
      );
      expect(
        reconstructedProduct.campaignId,
        equals(originalProduct.campaignId),
      );
      expect(
        reconstructedProduct.description,
        equals(originalProduct.description),
      );
      expect(
        reconstructedProduct.soldPercentage,
        equals(originalProduct.soldPercentage),
      );
    });

    test('soldPercentage precision test', () {
      const product = Product(
        id: 'precision-test-id',
        name: 'Precision Test Product',
        imageUrl: '/precision/product.jpg',
        price: 33.33,
        targetAmount: 3,
        currentSoldAmount: 1,
        campaignId: 'precision-campaign-id',
      );

      expect(product.soldPercentage, closeTo(33.333333333333336, 0.000001));
    });
  });
}
