import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/widgets/campaign_card.dart';
import 'package:productmanager/models/campaign.dart';

void main() {
  testWidgets('CampaignCard displays campaign information', (WidgetTester tester) async {
    final campaign = Campaign(
      id: 'c1',
      name: 'Test Campaign',
      description: 'A test campaign',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CampaignCard(campaign: campaign),
        ),
      ),
    );
    expect(find.text('Test Campaign'), findsOneWidget);
    expect(find.text('A test campaign'), findsOneWidget);
  });
}
