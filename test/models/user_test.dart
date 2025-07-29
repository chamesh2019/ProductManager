import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('normalizeFullName converts names correctly', () {
      // Test various name formats
      expect(
        User.normalizeFullName('Chamesh Dinuka'),
        equals('chamesh-dinuka'),
      );
      expect(User.normalizeFullName('John Doe'), equals('john-doe'));
      expect(
        User.normalizeFullName('  Mary Jane Smith  '),
        equals('mary-jane-smith'),
      );
      expect(User.normalizeFullName('José María'), equals('jos-mara'));
      expect(User.normalizeFullName('test@user.com'), equals('testusercom'));
      expect(
        User.normalizeFullName('Multiple   Spaces'),
        equals('multiple-spaces'),
      );
    });

    test('generateUserId uses NIC when available', () {
      const user1 = User(fullName: 'Chamesh Dinuka', nic: '123456789V');
      expect(user1.generateUserId(), equals('123456789V'));

      const user2 = User(fullName: 'Chamesh Dinuka');
      expect(user2.generateUserId(), equals('chamesh-dinuka'));
    });

    test('normalizedFullName getter works correctly', () {
      const user = User(fullName: 'Chamesh Dinuka');
      expect(user.normalizedFullName, equals('chamesh-dinuka'));
    });

    test('toFirestore includes normalized name', () {
      const user = User(
        fullName: 'Chamesh Dinuka',
        nic: '123456789V',
        avatarUrl: '/path/to/image.jpg',
      );

      final firestoreData = user.toFirestore();
      expect(firestoreData['id'], equals('123456789V'));
      expect(firestoreData['normalizedFullName'], equals('chamesh-dinuka'));
      expect(firestoreData['fullName'], equals('Chamesh Dinuka'));
      expect(firestoreData['nic'], equals('123456789V'));
    });

    test('copyWith creates new instance with updated fields', () {
      const originalUser = User(
        id: 'original-id',
        fullName: 'Chamesh Dinuka',
        nic: '123456789V',
        avatarUrl: '/path/to/image.jpg',
      );

      final updatedUser = originalUser.copyWith(
        fullName: 'Chamesh D. Senanayake',
        avatarUrl: '/new/path/to/image.jpg',
      );

      expect(updatedUser.id, equals('original-id'));
      expect(updatedUser.fullName, equals('Chamesh D. Senanayake'));
      expect(updatedUser.nic, equals('123456789V'));
      expect(updatedUser.avatarUrl, equals('/new/path/to/image.jpg'));
    });

    test('normalization handles edge cases', () {
      expect(User.normalizeFullName(''), equals(''));
      expect(User.normalizeFullName('   '), equals(''));
      expect(User.normalizeFullName('a'), equals('a'));
      expect(User.normalizeFullName('A B C'), equals('a-b-c'));
      expect(User.normalizeFullName('1234'), equals('1234'));
      expect(User.normalizeFullName('Test-User'), equals('test-user'));
    });
  });
}
