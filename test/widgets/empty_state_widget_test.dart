import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget displays message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(),
        ),
      ),
    );
    expect(find.text('No campaigns found'), findsOneWidget);
    expect(find.textContaining('create your first campaign'), findsOneWidget);
  });
}
