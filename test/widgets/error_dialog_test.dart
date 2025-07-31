import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/error_dialog.dart';

void main() {
  testWidgets('ErrorDialog displays error message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ErrorDialog(message: 'An error occurred'),
            ),
            child: Text('Show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.text('An error occurred'), findsOneWidget);
  });
}
