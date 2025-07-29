import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/services/product_service.dart';

void main() {
  group('Product Service Tests', () {
    group('Product Service Error Handling', () {
      test('getAllProducts handles missing Firebase initialization', () {
        expect(
          () async {
            await ProductService.getAllProducts();
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('getProductById handles missing Firebase initialization', () {
        expect(
          () async {
            await ProductService.getProductById('test-id');
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('getProductsByCampaign handles missing Firebase initialization', () {
        expect(
          () async {
            await ProductService.getProductsByCampaign('campaign-id');
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('createProduct handles missing Firebase initialization', () {
        const testProduct = Product(
          id: 'test-product-id',
          name: 'Test Product',
          imageUrl: '/test/product.jpg',
          price: 99.99,
          targetAmount: 100,
          currentSoldAmount: 0,
          campaignId: 'test-campaign-id',
        );

        expect(
          () async {
            await ProductService.createProduct(testProduct);
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('updateProduct handles missing Firebase initialization', () {
        const testProduct = Product(
          id: 'test-product-id',
          name: 'Updated Product',
          imageUrl: '/updated/product.jpg',
          price: 149.99,
          targetAmount: 200,
          currentSoldAmount: 50,
          campaignId: 'test-campaign-id',
        );

        expect(
          () async {
            await ProductService.updateProduct(testProduct);
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('deleteProduct handles missing Firebase initialization', () {
        expect(
          () async {
            await ProductService.deleteProduct('test-id');
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test(
        'deleteProductsByCampaign handles missing Firebase initialization',
        () {
          expect(
            () async {
              await ProductService.deleteProductsByCampaign('campaign-id');
            },
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Firebase is not initialized'),
              ),
            ),
          );
        },
      );
    });

    group('Product Utility Methods Tests', () {
      test('generateProductId creates unique IDs', () {
        final id1 = ProductService.generateProductId();
        final id2 = ProductService.generateProductId();

        expect(id1, isA<String>());
        expect(id2, isA<String>());
        expect(id1, isNot(equals(id2)));
        expect(int.parse(id1), isA<int>());
        expect(int.parse(id2), isA<int>());
      });
    });

    group('Product Business Logic Tests', () {
      test('Product sold percentage calculation', () {
        const product1 = Product(
          id: 'product-1',
          name: 'Product 1',
          imageUrl: '/product1.jpg',
          price: 10.0,
          targetAmount: 100,
          currentSoldAmount: 25,
          campaignId: 'campaign-1',
        );

        expect(product1.soldPercentage, equals(25.0));

        const product2 = Product(
          id: 'product-2',
          name: 'Product 2',
          imageUrl: '/product2.jpg',
          price: 20.0,
          targetAmount: 200,
          currentSoldAmount: 150,
          campaignId: 'campaign-2',
        );

        expect(product2.soldPercentage, equals(75.0));

        const product3 = Product(
          id: 'product-3',
          name: 'Product 3',
          imageUrl: '/product3.jpg',
          price: 30.0,
          targetAmount: 50,
          currentSoldAmount: 50,
          campaignId: 'campaign-3',
        );

        expect(product3.soldPercentage, equals(100.0));
      });

      test('Product sold percentage handles edge cases', () {
        // Zero target amount
        const productZeroTarget = Product(
          id: 'zero-target',
          name: 'Zero Target Product',
          imageUrl: '/zero.jpg',
          price: 5.0,
          targetAmount: 0,
          currentSoldAmount: 10,
          campaignId: 'campaign-zero',
        );

        expect(productZeroTarget.soldPercentage, equals(0.0));

        // Zero current sold amount
        const productZeroSold = Product(
          id: 'zero-sold',
          name: 'Zero Sold Product',
          imageUrl: '/zerosold.jpg',
          price: 15.0,
          targetAmount: 100,
          currentSoldAmount: 0,
          campaignId: 'campaign-zerosold',
        );

        expect(productZeroSold.soldPercentage, equals(0.0));

        // Oversold product
        const productOversold = Product(
          id: 'oversold',
          name: 'Oversold Product',
          imageUrl: '/oversold.jpg',
          price: 25.0,
          targetAmount: 50,
          currentSoldAmount: 75,
          campaignId: 'campaign-oversold',
        );

        expect(productOversold.soldPercentage, equals(150.0));
      });

      test('Product price validation', () {
        const validProduct = Product(
          id: 'valid-price',
          name: 'Valid Price Product',
          imageUrl: '/valid.jpg',
          price: 19.99,
          targetAmount: 100,
          currentSoldAmount: 10,
          campaignId: 'campaign-valid',
        );

        expect(validProduct.price, greaterThan(0));
        expect(validProduct.price, isA<double>());

        const freeProduct = Product(
          id: 'free',
          name: 'Free Product',
          imageUrl: '/free.jpg',
          price: 0.0,
          targetAmount: 100,
          currentSoldAmount: 10,
          campaignId: 'campaign-free',
        );

        expect(freeProduct.price, equals(0.0));
      });

      test('Product quantity validation', () {
        const validProduct = Product(
          id: 'valid-quantity',
          name: 'Valid Quantity Product',
          imageUrl: '/valid.jpg',
          price: 10.0,
          targetAmount: 100,
          currentSoldAmount: 25,
          campaignId: 'campaign-valid',
        );

        expect(validProduct.targetAmount, greaterThanOrEqualTo(0));
        expect(validProduct.currentSoldAmount, greaterThanOrEqualTo(0));
        expect(
          validProduct.currentSoldAmount,
          lessThanOrEqualTo(validProduct.targetAmount * 2),
        ); // Allow overselling
      });
    });

    group('Product Model Integration Tests', () {
      test('Product JSON serialization preserves data', () {
        const product = Product(
          id: 'test-id',
          name: 'Test Product',
          imageUrl: '/test/product.jpg',
          price: 59.99,
          targetAmount: 80,
          currentSoldAmount: 20,
          campaignId: 'test-campaign-id',
          description: 'Test description',
        );

        final json = product.toJson();
        final reconstructed = Product.fromJson(json);

        expect(reconstructed.id, equals(product.id));
        expect(reconstructed.name, equals(product.name));
        expect(reconstructed.imageUrl, equals(product.imageUrl));
        expect(reconstructed.price, equals(product.price));
        expect(reconstructed.targetAmount, equals(product.targetAmount));
        expect(
          reconstructed.currentSoldAmount,
          equals(product.currentSoldAmount),
        );
        expect(reconstructed.campaignId, equals(product.campaignId));
        expect(reconstructed.description, equals(product.description));
        expect(reconstructed.soldPercentage, equals(product.soldPercentage));
      });

      test('Product copyWith functionality', () {
        const originalProduct = Product(
          id: 'original-id',
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

        expect(updatedProduct.id, equals(originalProduct.id));
        expect(updatedProduct.name, equals('Updated Product'));
        expect(updatedProduct.imageUrl, equals(originalProduct.imageUrl));
        expect(updatedProduct.price, equals(69.99));
        expect(
          updatedProduct.targetAmount,
          equals(originalProduct.targetAmount),
        );
        expect(updatedProduct.currentSoldAmount, equals(50));
        expect(updatedProduct.campaignId, equals(originalProduct.campaignId));
        expect(updatedProduct.description, equals(originalProduct.description));
      });

      test('Product fromJson handles missing optional fields', () {
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

      test('Product fromJson handles string numbers correctly', () {
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
    });

    group('Service Method Structure Tests', () {
      test('ProductService has expected static methods', () {
        // Test that required methods exist by checking their types
        expect(ProductService.getAllProducts, isA<Function>());
        expect(ProductService.getProductById, isA<Function>());
        expect(ProductService.getProductsByCampaign, isA<Function>());
        expect(ProductService.createProduct, isA<Function>());
        expect(ProductService.updateProduct, isA<Function>());
        expect(ProductService.deleteProduct, isA<Function>());
        expect(ProductService.deleteProductsByCampaign, isA<Function>());
        expect(ProductService.generateProductId, isA<Function>());
      });
    });
  });
}
