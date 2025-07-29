import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/models/user.dart';
import 'package:untitled/screens/pin_entry_screen.dart';
import 'package:untitled/screens/user_registration_screen.dart';

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
  });

  testWidgets('Registration screen displays correctly', (
    WidgetTester tester,
  ) async {
    // Test the registration screen directly
    await tester.pumpWidget(
      MaterialApp(home: UserRegistrationScreen(onRegistrationComplete: () {})),
    );

    // Verify that the registration screen elements are displayed
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Let\'s set up your profile'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Tap to add photo (optional)'), findsOneWidget);
  });

  testWidgets('PIN entry screen displays correctly', (
    WidgetTester tester,
  ) async {
    // Test the PIN entry screen directly with a sample user
    const user = User(fullName: 'John Doe');

    await tester.pumpWidget(
      MaterialApp(
        home: PinEntryScreen(user: user, onPinComplete: (pin) {}),
      ),
    );

    // Verify that the PIN entry screen elements are displayed
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Enter your 4-digit PIN'), findsOneWidget);

    // Verify that number buttons are present
    expect(find.text('1'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Verify that backspace button is present
    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);

    // Test PIN entry
    await tester.tap(find.text('1'));
    await tester.pump();

    await tester.tap(find.text('2'));
    await tester.pump();

    await tester.tap(find.text('3'));
    await tester.pump();

    // Test backspace
    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump();

    await tester.tap(find.text('4'));
    await tester.pump();

    await tester.tap(find.text('5'));
    await tester.pump();

    // Wait for any potential animations or delays
    await tester.pumpAndSettle();
  });

  testWidgets('Registration form validation works', (
    WidgetTester tester,
  ) async {
    bool registrationCompleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: UserRegistrationScreen(
          onRegistrationComplete: () {
            registrationCompleted = true;
          },
        ),
      ),
    );

    // Try to register without entering a name
    await tester.tap(find.text('Continue'));
    await tester.pump();

    // Should show validation message
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(registrationCompleted, false);

    // Now enter a name
    await tester.enterText(find.byType(TextField), 'Jane Smith');

    // The continue button should now work
    // Note: We can't actually test the registration completion
    // without mocking Firebase
  });
}
