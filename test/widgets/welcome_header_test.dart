import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/welcome_header.dart';
import 'package:productmanager/models/user.dart';

void main() {
  testWidgets('WelcomeHeader displays welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WelcomeHeader(user: User(fullName: 'Alice')),
        ),
      ),
    );
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
  });
}
