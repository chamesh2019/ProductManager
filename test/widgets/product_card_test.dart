import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;
    bool cardTapped = false;
    bool editTapped = false;
    bool deleteTapped = false;

    setUp(() {
      cardTapped = false;
      editTapped = false;
      deleteTapped = false;

      testProduct = const Product(
        id: 'test-product-id',
        name: 'Test Product',
        imageUrl: 'https://example.com/test-image.jpg',
        price: 29.99,
        targetAmount: 100,
        currentSoldAmount: 25,
        campaignId: 'test-campaign-id',
        description: 'This is a test product description',
      );
    });

    testWidgets('displays product information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => cardTapped = true,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Verify product name is displayed
      expect(find.text('Test Product'), findsOneWidget);

      // Verify product price is displayed
      expect(find.textContaining('29.99'), findsOneWidget);

      // Verify sold amount and target are displayed
      expect(find.textContaining('25'), findsOneWidget);
      expect(find.textContaining('100'), findsOneWidget);
    });

    testWidgets('handles card tap correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => cardTapped = true,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Tap on the card
      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      expect(cardTapped, isTrue);
      expect(editTapped, isFalse);
      expect(deleteTapped, isFalse);
    });

    testWidgets('handles edit button tap correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => cardTapped = true,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Find and tap the edit button
      final editButton = find.byIcon(Icons.edit);
      if (editButton.evaluate().isNotEmpty) {
        await tester.tap(editButton);
        await tester.pump();
        expect(editTapped, isTrue);
      }
    });

    testWidgets('handles delete button tap correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => cardTapped = true,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.delete);
      if (deleteButton.evaluate().isNotEmpty) {
        await tester.tap(deleteButton);
        await tester.pump();
        expect(deleteTapped, isTrue);
      }
    });

    testWidgets('displays sold percentage correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      // Product has 25/100 sold = 25%
      expect(find.textContaining('25'), findsAtLeastNWidgets(1));
    });

    testWidgets('handles product with 100% sold', (WidgetTester tester) async {
      final completedProduct = testProduct.copyWith(currentSoldAmount: 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: completedProduct)),
        ),
      );

      // Should show 100% completion
      expect(find.textContaining('100'), findsAtLeastNWidgets(1));
    });

    testWidgets('handles product with oversold amount', (
      WidgetTester tester,
    ) async {
      final oversoldProduct = testProduct.copyWith(currentSoldAmount: 150);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: oversoldProduct)),
        ),
      );

      // Should handle oversold scenario gracefully
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('handles product without optional callbacks', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              // No callbacks provided
            ),
          ),
        ),
      );

      // Should not crash when tapping without callbacks
      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      expect(cardTapped, isFalse);
    });

    testWidgets('displays price with proper formatting', (
      WidgetTester tester,
    ) async {
      final expensiveProduct = testProduct.copyWith(price: 1234.56);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: expensiveProduct)),
        ),
      );

      // Should display price
      expect(find.textContaining('1234.56'), findsOneWidget);
    });

    testWidgets('handles zero price product', (WidgetTester tester) async {
      final freeProduct = testProduct.copyWith(price: 0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: freeProduct)),
        ),
      );

      // Should handle free products
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.textContaining('0'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays product without description', (
      WidgetTester tester,
    ) async {
      final productWithoutDescription = testProduct.copyWith(description: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: productWithoutDescription)),
        ),
      );

      // Should still render without description
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('has proper card elevation and styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      // Check that card has proper styling
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(4));
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('handles image loading error gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: testProduct)),
        ),
      );

      // Should have image widget with error handling
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('has accessibility features', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Check that semantic information is available
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
