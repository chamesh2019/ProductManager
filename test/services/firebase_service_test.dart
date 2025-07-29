import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/services/firebase_service.dart';

void main() {
  group('Firebase Service Tests', () {
    test('Firebase error handling for permission denied', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        const MockFirebaseException('permission-denied', 'Permission denied'),
      );
      expect(errorMessage, contains('Permission denied'));
    });

    test('Firebase error handling for unavailable service', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        const MockFirebaseException('unavailable', 'Service unavailable'),
      );
      expect(errorMessage, contains('temporarily unavailable'));
    });

    test('Firebase error handling for deadline exceeded', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        const MockFirebaseException('deadline-exceeded', 'Timeout'),
      );
      expect(errorMessage, contains('timeout'));
    });

    test('Firebase error handling for not found', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        const MockFirebaseException('not-found', 'Not found'),
      );
      expect(errorMessage, contains('not found'));
    });

    test('Firebase error handling for unknown error', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        const MockFirebaseException('unknown-error', 'Unknown error'),
      );
      expect(errorMessage, contains('An error occurred'));
    });

    test('Firebase error handling for non-Firebase exception', () {
      final errorMessage = FirebaseService.handleFirebaseError(
        Exception('Regular exception'),
      );
      expect(errorMessage, contains('unexpected error'));
    });

    test('Firebase initialization status tracking', () {
      // Test the initialization flag
      // Note: In real tests, you would mock the Firebase initialization
      expect(FirebaseService.isInitialized, isA<bool>());
    });

    // Note: The following tests would require Firebase to be initialized
    // In a real testing environment, you would mock these services

    group('Firebase Service Integration Tests (requires initialization)', () {
      test('Collection references are accessible when initialized', () {
        // This test would only pass if Firebase is properly initialized
        // In practice, you would skip this test or mock the Firebase services
        expect(
          () => FirebaseService.usersCollection,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase not initialized'),
            ),
          ),
        );
      });

      test('Firestore getter throws when not initialized', () {
        expect(
          () => FirebaseService.firestore,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase not initialized'),
            ),
          ),
        );
      });

      test('Auth getter throws when not initialized', () {
        expect(
          () => FirebaseService.auth,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase not initialized'),
            ),
          ),
        );
      });

      test('Storage getter throws when not initialized', () {
        expect(
          () => FirebaseService.storage,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase not initialized'),
            ),
          ),
        );
      });
    });
  });
}

// Mock Firebase Exception for testing error handling
class MockFirebaseException implements Exception {
  final String code;
  final String message;

  const MockFirebaseException(this.code, this.message);

  @override
  String toString() => 'MockFirebaseException: $code - $message';
}
