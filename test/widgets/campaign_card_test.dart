import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/campaign.dart';
import 'package:untitled/widgets/campaign_card.dart';

void main() {
  group('CampaignCard Widget Tests', () {
    late Campaign testCampaign;
    bool editTapped = false;
    bool deleteTapped = false;
    bool cardTapped = false;

    setUp(() {
      editTapped = false;
      deleteTapped = false;
      cardTapped = false;

      testCampaign = Campaign(
        id: 'test-campaign-id',
        title: 'Test Campaign',
        description: 'This is a test campaign description',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        isActive: true,
        pin: '123456',
        budget: 1000.0,
        imageUrl: '/test/campaign.jpg',
      );
    });

    testWidgets('displays campaign information correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Verify campaign title is displayed
      expect(find.text('Test Campaign'), findsOneWidget);

      // Verify campaign description is displayed
      expect(find.text('This is a test campaign description'), findsOneWidget);

      // Verify PIN is displayed
      expect(find.text('123456'), findsOneWidget);

      // Verify PIN icon is displayed
      expect(find.byIcon(Icons.pin_drop), findsOneWidget);
    });

    testWidgets('handles card tap correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Tap on the card
      await tester.tap(find.byType(CampaignCard));
      await tester.pump();

      expect(cardTapped, isTrue);
      expect(editTapped, isFalse);
      expect(deleteTapped, isFalse);
    });

    testWidgets('handles edit button tap correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Find and tap the edit button
      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pump();

      expect(editTapped, isTrue);
      expect(deleteTapped, isFalse);
      expect(cardTapped, isFalse);
    });

    testWidgets('handles delete button tap correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.delete);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pump();

      expect(deleteTapped, isTrue);
      expect(editTapped, isFalse);
      expect(cardTapped, isFalse);
    });

    testWidgets('displays status indicator correctly for active campaign', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Should show active status
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('displays status indicator correctly for inactive campaign', (
      WidgetTester tester,
    ) async {
      final inactiveCampaign = testCampaign.copyWith(isActive: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: inactiveCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Should show inactive status
      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('handles campaign without optional onTap callback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              // No onTap provided
            ),
          ),
        ),
      );

      // Should not crash when tapping the card without onTap callback
      await tester.tap(find.byType(CampaignCard));
      await tester.pump();

      expect(cardTapped, isFalse);
    });

    testWidgets('displays budget information when available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Should display budget information
      expect(find.textContaining('1000.0'), findsOneWidget);
    });

    testWidgets('handles campaign without budget', (WidgetTester tester) async {
      final campaignWithoutBudget = testCampaign.copyWith(budget: null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: campaignWithoutBudget,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
            ),
          ),
        ),
      );

      // Should still render without budget
      expect(find.text('Test Campaign'), findsOneWidget);
    });

    testWidgets('has proper accessibility features', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCard(
              campaign: testCampaign,
              onEdit: () => editTapped = true,
              onDelete: () => deleteTapped = true,
              onTap: () => cardTapped = true,
            ),
          ),
        ),
      );

      // Check that semantic information is available
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      expect(
        find.byType(IconButton),
        findsAtLeastNWidgets(2),
      ); // Edit and Delete buttons
    });
  });
}
