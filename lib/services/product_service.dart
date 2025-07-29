import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'firebase_service.dart';
import 'product_change_log_service.dart';

class ProductService {
  static Future<List<Product>> getAllProducts() async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.productsCollection.get();
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      throw Exception('Failed to load products from Firebase: $e');
    }
  }

  static Future<List<Product>> getProductsByCampaign(String campaignId) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.productsCollection
          .where('campaignId', isEqualTo: campaignId)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting products by campaign: $e');
      throw Exception('Failed to load products from Firebase: $e');
    }
  }

  static Future<Product?> getProductById(String id) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final doc = await FirebaseService.productsCollection.doc(id).get();
      if (doc.exists) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting product by id: $e');
      throw Exception('Failed to load product from Firebase: $e');
    }
  }

  static Future<bool> createProduct(Product product) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final doc = await FirebaseService.productsCollection
          .doc(product.id)
          .get();
      if (doc.exists) {
        return false; // Product already exists
      }

      final productData = product.toJson();
      productData['createdAt'] = FieldValue.serverTimestamp();
      productData['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseService.productsCollection.doc(product.id).set(productData);

      return true;
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Failed to create product in Firebase: $e');
    }
  }

  static Future<bool> updateProduct(Product updatedProduct) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final productData = updatedProduct.toJson();
      productData['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseService.productsCollection
          .doc(updatedProduct.id)
          .update(productData);

      return true;
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('Failed to update product in Firebase: $e');
    }
  }

  static Future<bool> updateProductWithLogging(
    Product oldProduct,
    Product updatedProduct,
    User user, {
    String changeType = 'update',
    String? notes,
  }) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      // Log the change before updating
      await ProductChangeLogService.logProductChange(
        oldProduct: oldProduct,
        newProduct: updatedProduct,
        user: user,
        changeType: changeType,
        notes: notes,
      );

      // Update the product
      final result = await updateProduct(updatedProduct);
      return result;
    } catch (e) {
      print('Error updating product with logging: $e');
      throw Exception('Failed to update product in Firebase: $e');
    }
  }

  static Future<bool> deleteProduct(String id) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      await FirebaseService.productsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception('Failed to delete product from Firebase: $e');
    }
  }

  static Future<bool> deleteProductsByCampaign(String campaignId) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.productsCollection
          .where('campaignId', isEqualTo: campaignId)
          .get();

      final batch = FirebaseService.getBatch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return true;
    } catch (e) {
      print('Error deleting products by campaign: $e');
      throw Exception('Failed to delete products from Firebase: $e');
    }
  }

  static String generateProductId() {
    return 'prod_${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<Product> updateProductSales(
    String productId,
    int newSoldAmount,
    User user,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final product = await getProductById(productId);
    if (product != null) {
      final updatedProduct = product.copyWith(currentSoldAmount: newSoldAmount);

      // Log the change before updating
      await ProductChangeLogService.logProductChange(
        oldProduct: product,
        newProduct: updatedProduct,
        user: user,
        changeType: 'sales_update',
        notes:
            'Sales amount updated from ${product.currentSoldAmount} to $newSoldAmount',
      );

      await updateProduct(updatedProduct);
      return updatedProduct;
    }
    throw Exception('Product not found');
  }
}
