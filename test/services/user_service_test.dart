import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/services/user_service.dart';

void main() {
  group('User Service Tests', () {
    setUp(() {
      // Reset the current user ID before each test
      UserService.setCurrentUserId('');
    });

    test('generateUserId uses NIC when available', () {
      const user = User(fullName: 'Test User', nic: '123456789V');

      expect(user.generateUserId(), equals('123456789V'));
    });

    test('generateUserId uses normalized name when NIC is null', () {
      const user = User(fullName: 'Test User Name');

      expect(user.generateUserId(), equals('test-user-name'));
    });

    test('generateUserId uses normalized name when NIC is empty', () {
      const user = User(fullName: 'Another Test User', nic: '');

      expect(user.generateUserId(), equals('another-test-user'));
    });

    test('current user ID management', () {
      // Initially no current user
      expect(UserService.getCurrentUserId(), isNull);

      // Set current user
      UserService.setCurrentUserId('test-user-123');
      expect(UserService.getCurrentUserId(), equals('test-user-123'));

      // Clear current user by setting empty string
      UserService.setCurrentUserId('');
      expect(UserService.getCurrentUserId(), equals(''));
    });

    group('User Service Error Handling', () {
      test('findExistingUser handles missing Firebase initialization', () {
        expect(
          () async {
            const user = User(fullName: 'Test User');
            await UserService.findExistingUser(user);
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

      test('saveUser handles missing Firebase initialization', () {
        expect(
          () async {
            const user = User(fullName: 'Test User');
            await UserService.saveUser(user);
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

      test('getUser handles missing Firebase initialization', () {
        expect(
          () async {
            await UserService.getUser();
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

      test('getUserByNic handles missing Firebase initialization', () {
        expect(
          () async {
            await UserService.getUserByNic('123456789V');
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

      test('isUserRegistered handles missing Firebase initialization', () {
        expect(
          () async {
            await UserService.isUserRegistered();
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

      test('clearUser handles missing Firebase initialization', () {
        expect(
          () async {
            await UserService.clearUser();
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

      test('getAllUsers handles missing Firebase initialization', () {
        expect(
          () async {
            await UserService.getAllUsers();
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
    });

    group('User Data Logic Tests', () {
      test('User model normalization works correctly', () {
        const user1 = User(fullName: 'John Doe');
        expect(user1.normalizedFullName, equals('john-doe'));

        const user2 = User(fullName: 'Jane Smith O\'Connor');
        expect(user2.normalizedFullName, equals('jane-smith-oconnor'));

        const user3 = User(fullName: '  Multiple   Spaces  ');
        expect(user3.normalizedFullName, equals('multiple-spaces'));
      });

      test('User ID generation logic', () {
        const userWithNIC = User(fullName: 'Test User', nic: '123456789V');
        expect(userWithNIC.generateUserId(), equals('123456789V'));

        const userWithoutNIC = User(fullName: 'Test User');
        expect(userWithoutNIC.generateUserId(), equals('test-user'));

        const userEmptyNIC = User(fullName: 'Test User', nic: '');
        expect(userEmptyNIC.generateUserId(), equals('test-user'));
      });

      test('User copyWith functionality', () {
        const originalUser = User(
          id: 'original-id',
          fullName: 'Original Name',
          nic: '123456789V',
          avatarUrl: '/original/avatar.jpg',
        );

        final updatedUser = originalUser.copyWith(
          fullName: 'Updated Name',
          avatarUrl: '/updated/avatar.jpg',
        );

        expect(updatedUser.id, equals('original-id'));
        expect(updatedUser.fullName, equals('Updated Name'));
        expect(updatedUser.nic, equals('123456789V'));
        expect(updatedUser.avatarUrl, equals('/updated/avatar.jpg'));
      });

      test('User Firestore serialization', () {
        final now = DateTime.now();
        final user = User(
          id: 'test-id',
          fullName: 'Test User',
          nic: '123456789V',
          avatarUrl: '/test/avatar.jpg',
          createdAt: now,
        );

        final firestoreData = user.toFirestore();

        expect(firestoreData['id'], equals('123456789V')); // Generated from NIC
        expect(firestoreData['fullName'], equals('Test User'));
        expect(firestoreData['normalizedFullName'], equals('test-user'));
        expect(firestoreData['nic'], equals('123456789V'));
        expect(firestoreData['avatarUrl'], equals('/test/avatar.jpg'));
        expect(firestoreData['createdAt'], equals(now));
      });

      test('User fromFirestore deserialization', () {
        final testDate = DateTime.now();
        final firestoreData = {
          'id': 'firestore-id',
          'fullName': 'Firestore User',
          'nic': '987654321X',
          'avatarUrl': '/firestore/avatar.jpg',
          'createdAt': testDate,
        };

        final user = User.fromFirestore(firestoreData, 'doc-id');

        expect(user.id, equals('firestore-id'));
        expect(user.fullName, equals('Firestore User'));
        expect(user.nic, equals('987654321X'));
        expect(user.avatarUrl, equals('/firestore/avatar.jpg'));
        expect(user.createdAt, equals(testDate));
      });
    });

    group('Service Method Structure Tests', () {
      test('UserService has expected static methods', () {
        // Test that required methods exist by checking their types
        expect(UserService.findExistingUser, isA<Function>());
        expect(UserService.saveUser, isA<Function>());
        expect(UserService.getUser, isA<Function>());
        expect(UserService.getUserByNic, isA<Function>());
        expect(UserService.isUserRegistered, isA<Function>());
        expect(UserService.clearUser, isA<Function>());
        expect(UserService.getAllUsers, isA<Function>());
        expect(UserService.setCurrentUserId, isA<Function>());
        expect(UserService.getCurrentUserId, isA<Function>());
      });
    });
  });
}
