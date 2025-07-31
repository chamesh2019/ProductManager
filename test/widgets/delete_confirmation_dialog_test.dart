import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/delete_confirmation_dialog.dart';
import 'package:productmanager/models/campaign.dart';

void main() {
  testWidgets('DeleteConfirmationDialog displays campaign title and calls onConfirm', (WidgetTester tester) async {
    bool confirmed = false;
    final campaign = Campaign(
      id: 'c1',
      title: 'Test Campaign',
      description: 'desc',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
      isActive: true,
      pin: '123456',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => DeleteConfirmationDialog(
                campaign: campaign,
                onConfirm: () { confirmed = true; },
              ),
            ),
            child: Text('Show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Test Campaign'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });
}
