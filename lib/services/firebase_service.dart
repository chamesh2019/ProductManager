import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static FirebaseFirestore? _firestore;
  static FirebaseAuth? _auth;
  static FirebaseStorage? _storage;

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firestore = FirebaseFirestore.instance;
      _auth = FirebaseAuth.instance;
      _storage = FirebaseStorage.instance;

      // Configure Firestore settings first
      if (kIsWeb) {
        // Web-specific settings
        _firestore!.settings = const Settings(
          persistenceEnabled:
              false, // Disable persistence on web to avoid conflicts
        );
      } else {
        // Mobile-specific settings
        _firestore!.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );

        // Enable offline persistence for mobile only
        try {
          await _firestore!.enablePersistence();
        } catch (e) {
          print('Warning: Could not enable Firestore persistence: $e');
          // Continue without persistence if it fails
        }
      }

      // Test Firestore connection with a simple operation
      try {
        await _firestore!
            .collection('_test')
            .doc('_connection')
            .get()
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                print('Warning: Firestore connection test timed out');
                throw Exception('Connection timeout');
              },
            );
        print('Firebase initialized successfully with working connection');
      } catch (e) {
        print('Warning: Firestore connection test failed: $e');
        print('Firebase initialized but Firestore may not be accessible');
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
      rethrow;
    }
  }

  // Getters for Firebase services
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception(
        'Firebase not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _firestore!;
  }

  static FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception(
        'Firebase not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _auth!;
  }

  static FirebaseStorage get storage {
    if (_storage == null) {
      throw Exception(
        'Firebase not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _storage!;
  }

  // Check if Firebase is initialized
  static bool get isInitialized =>
      _firestore != null && _auth != null && _storage != null;

  // Test Firestore connectivity
  static Future<bool> testFirestoreConnection() async {
    if (!isInitialized) return false;

    try {
      await _firestore!
          .collection('_test')
          .doc('_connection')
          .get()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }

  // Collection references
  static CollectionReference get usersCollection =>
      firestore.collection('users');
  static CollectionReference get productsCollection =>
      firestore.collection('products');
  static CollectionReference get campaignsCollection =>
      firestore.collection('campaigns');
  static CollectionReference get productChangeLogsCollection =>
      firestore.collection('product_change_logs');

  // Utility methods for error handling
  static String handleFirebaseError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Permission denied. Please check your access rights.';
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again.';
        case 'deadline-exceeded':
          return 'Request timeout. Please check your connection.';
        case 'not-found':
          return 'Requested data not found.';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred: $error';
  }

  // Batch operations helper
  static WriteBatch getBatch() => firestore.batch();

  // Transaction helper
  static Future<T> runTransaction<T>(TransactionHandler<T> updateFunction) {
    return firestore.runTransaction(updateFunction);
  }
}
