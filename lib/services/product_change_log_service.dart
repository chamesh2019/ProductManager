import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_change_log.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'firebase_service.dart';

class ProductChangeLogService {
  static String generateLogId() {
    return 'log_${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<void> logProductChange({
    required Product oldProduct,
    required Product newProduct,
    required User user,
    required String changeType,
    String? notes,
  }) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final oldValues = oldProduct.toJson();
      final newValues = newProduct.toJson();

      // Remove non-relevant fields for comparison
      oldValues.remove('id');
      newValues.remove('id');
      oldValues.remove('campaignId');
      newValues.remove('campaignId');

      final changeLog = ProductChangeLog(
        id: generateLogId(),
        productId: newProduct.id,
        productName: newProduct.name,
        userId: user.id ?? user.generateUserId(),
        userName: user.fullName,
        changeType: changeType,
        oldValues: oldValues,
        newValues: newValues,
        timestamp: DateTime.now(),
        notes: notes,
      );

      await FirebaseService.productChangeLogsCollection
          .doc(changeLog.id)
          .set(changeLog.toJson());

      print('Product change logged successfully');
    } catch (e) {
      print('Error logging product change: $e');
      // Don't throw the error as logging shouldn't break the main operation
    }
  }

  static Future<List<ProductChangeLog>> getChangeLogsByProduct(
    String productId,
  ) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.productChangeLogsCollection
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                ProductChangeLog.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting change logs by product: $e');
      throw Exception('Failed to load change logs from Firebase: $e');
    }
  }

  static Future<List<ProductChangeLog>> getChangeLogsByUser(
    String userId,
  ) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.productChangeLogsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                ProductChangeLog.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting change logs by user: $e');
      throw Exception('Failed to load change logs from Firebase: $e');
    }
  }

  static Future<List<ProductChangeLog>> getAllChangeLogs({int? limit}) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      Query query = FirebaseService.productChangeLogsCollection.orderBy(
        'timestamp',
        descending: true,
      );

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) =>
                ProductChangeLog.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting all change logs: $e');
      throw Exception('Failed to load change logs from Firebase: $e');
    }
  }

  static Future<List<ProductChangeLog>> getChangeLogsByCampaign(
    String campaignId,
  ) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      // First get all products in the campaign
      final productsSnapshot = await FirebaseService.productsCollection
          .where('campaignId', isEqualTo: campaignId)
          .get();

      final productIds = productsSnapshot.docs.map((doc) => doc.id).toList();

      if (productIds.isEmpty) {
        return [];
      }

      // Then get change logs for those products
      final snapshot = await FirebaseService.productChangeLogsCollection
          .where('productId', whereIn: productIds)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                ProductChangeLog.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting change logs by campaign: $e');
      throw Exception('Failed to load change logs from Firebase: $e');
    }
  }
}
