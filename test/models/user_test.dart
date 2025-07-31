import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/models/user.dart';

void main() {
  group('User Model', () {
    test('should create a User with correct values', () {
      final user = User(
        id: '1',
        fullName: 'Test User',
        nic: '123456789V',
        avatarUrl: 'http://example.com/avatar.png',
      );
      expect(user.id, '1');
      expect(user.fullName, 'Test User');
      expect(user.nic, '123456789V');
      expect(user.avatarUrl, 'http://example.com/avatar.png');
    });
  });
}
