import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/product_card.dart';
import 'package:productmanager/models/product.dart';

void main() {
  testWidgets('ProductCard displays product information', (WidgetTester tester) async {
    // Arrange: create a sample product
    final product = Product(
      id: 'p1',
      name: 'Test Product',
      price: 12.0,
      description: 'A test product',
      imageUrl: '',
      targetAmount: 100,
      currentSoldAmount: 20,
      campaignId: 'c1',
    );

    // Act: pump the ProductCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(product: product),
        ),
      ),
    );

    // Assert: verify product name and price are displayed
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.textContaining('12'), findsOneWidget);
  });
}
