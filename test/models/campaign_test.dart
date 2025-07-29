import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/campaign.dart';

void main() {
  group('Campaign Model Tests', () {
    final testDate1 = DateTime(2024, 1, 1);
    final testDate2 = DateTime(2024, 12, 31);

    test('Campaign constructor creates instance correctly', () {
      final campaign = Campaign(
        id: 'test-id',
        title: 'Test Campaign',
        description: 'Test Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: true,
        pin: '123456',
        budget: 1000.0,
        imageUrl: '/path/to/image.jpg',
      );

      expect(campaign.id, equals('test-id'));
      expect(campaign.title, equals('Test Campaign'));
      expect(campaign.description, equals('Test Description'));
      expect(campaign.startDate, equals(testDate1));
      expect(campaign.endDate, equals(testDate2));
      expect(campaign.isActive, isTrue);
      expect(campaign.pin, equals('123456'));
      expect(campaign.budget, equals(1000.0));
      expect(campaign.imageUrl, equals('/path/to/image.jpg'));
    });

    test('Campaign constructor with optional parameters', () {
      final campaign = Campaign(
        id: 'test-id-2',
        title: 'Test Campaign 2',
        description: 'Test Description 2',
        startDate: testDate1,
        endDate: testDate2,
        isActive: false,
        pin: '654321',
      );

      expect(campaign.id, equals('test-id-2'));
      expect(campaign.title, equals('Test Campaign 2'));
      expect(campaign.description, equals('Test Description 2'));
      expect(campaign.startDate, equals(testDate1));
      expect(campaign.endDate, equals(testDate2));
      expect(campaign.isActive, isFalse);
      expect(campaign.pin, equals('654321'));
      expect(campaign.budget, isNull);
      expect(campaign.imageUrl, isNull);
    });

    test('fromJson creates Campaign from valid JSON', () {
      final json = {
        'id': 'json-id',
        'title': 'JSON Campaign',
        'description': 'JSON Description',
        'startDate': testDate1.toIso8601String(),
        'endDate': testDate2.toIso8601String(),
        'isActive': true,
        'pin': '789123',
        'budget': 2500.5,
        'imageUrl': '/json/image.jpg',
      };

      final campaign = Campaign.fromJson(json);

      expect(campaign.id, equals('json-id'));
      expect(campaign.title, equals('JSON Campaign'));
      expect(campaign.description, equals('JSON Description'));
      expect(campaign.startDate, equals(testDate1));
      expect(campaign.endDate, equals(testDate2));
      expect(campaign.isActive, isTrue);
      expect(campaign.pin, equals('789123'));
      expect(campaign.budget, equals(2500.5));
      expect(campaign.imageUrl, equals('/json/image.jpg'));
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'minimal-id',
        'title': 'Minimal Campaign',
        'description': 'Minimal Description',
        'startDate': testDate1.toIso8601String(),
        'endDate': testDate2.toIso8601String(),
        'isActive': false,
      };

      final campaign = Campaign.fromJson(json);

      expect(campaign.id, equals('minimal-id'));
      expect(campaign.title, equals('Minimal Campaign'));
      expect(campaign.description, equals('Minimal Description'));
      expect(campaign.startDate, equals(testDate1));
      expect(campaign.endDate, equals(testDate2));
      expect(campaign.isActive, isFalse);
      expect(campaign.pin, equals('000000')); // Default PIN
      expect(campaign.budget, isNull);
      expect(campaign.imageUrl, isNull);
    });

    test('toJson converts Campaign to JSON correctly', () {
      final campaign = Campaign(
        id: 'to-json-id',
        title: 'ToJSON Campaign',
        description: 'ToJSON Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: true,
        pin: '456789',
        budget: 3000.75,
        imageUrl: '/tojson/image.jpg',
      );

      final json = campaign.toJson();

      expect(json['id'], equals('to-json-id'));
      expect(json['title'], equals('ToJSON Campaign'));
      expect(json['description'], equals('ToJSON Description'));
      expect(json['startDate'], equals(testDate1.toIso8601String()));
      expect(json['endDate'], equals(testDate2.toIso8601String()));
      expect(json['isActive'], isTrue);
      expect(json['pin'], equals('456789'));
      expect(json['budget'], equals(3000.75));
      expect(json['imageUrl'], equals('/tojson/image.jpg'));
    });

    test('toJson handles null optional fields', () {
      final campaign = Campaign(
        id: 'null-fields-id',
        title: 'Null Fields Campaign',
        description: 'Null Fields Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: false,
        pin: '111111',
      );

      final json = campaign.toJson();

      expect(json['id'], equals('null-fields-id'));
      expect(json['title'], equals('Null Fields Campaign'));
      expect(json['description'], equals('Null Fields Description'));
      expect(json['startDate'], equals(testDate1.toIso8601String()));
      expect(json['endDate'], equals(testDate2.toIso8601String()));
      expect(json['isActive'], isFalse);
      expect(json['pin'], equals('111111'));
      expect(json['budget'], isNull);
      expect(json['imageUrl'], isNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final originalCampaign = Campaign(
        id: 'original-id',
        title: 'Original Campaign',
        description: 'Original Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: true,
        pin: '123456',
        budget: 1000.0,
        imageUrl: '/original/image.jpg',
      );

      final updatedCampaign = originalCampaign.copyWith(
        title: 'Updated Campaign',
        isActive: false,
        budget: 2000.0,
      );

      expect(updatedCampaign.id, equals('original-id'));
      expect(updatedCampaign.title, equals('Updated Campaign'));
      expect(updatedCampaign.description, equals('Original Description'));
      expect(updatedCampaign.startDate, equals(testDate1));
      expect(updatedCampaign.endDate, equals(testDate2));
      expect(updatedCampaign.isActive, isFalse);
      expect(updatedCampaign.pin, equals('123456'));
      expect(updatedCampaign.budget, equals(2000.0));
      expect(updatedCampaign.imageUrl, equals('/original/image.jpg'));
    });

    test('copyWith with all null parameters returns identical instance', () {
      final originalCampaign = Campaign(
        id: 'identical-id',
        title: 'Identical Campaign',
        description: 'Identical Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: true,
        pin: '999999',
      );

      final copiedCampaign = originalCampaign.copyWith();

      expect(copiedCampaign.id, equals(originalCampaign.id));
      expect(copiedCampaign.title, equals(originalCampaign.title));
      expect(copiedCampaign.description, equals(originalCampaign.description));
      expect(copiedCampaign.startDate, equals(originalCampaign.startDate));
      expect(copiedCampaign.endDate, equals(originalCampaign.endDate));
      expect(copiedCampaign.isActive, equals(originalCampaign.isActive));
      expect(copiedCampaign.pin, equals(originalCampaign.pin));
      expect(copiedCampaign.budget, equals(originalCampaign.budget));
      expect(copiedCampaign.imageUrl, equals(originalCampaign.imageUrl));
    });

    test('JSON serialization round trip preserves data', () {
      final originalCampaign = Campaign(
        id: 'round-trip-id',
        title: 'Round Trip Campaign',
        description: 'Round Trip Description',
        startDate: testDate1,
        endDate: testDate2,
        isActive: true,
        pin: '555555',
        budget: 1500.25,
        imageUrl: '/roundtrip/image.jpg',
      );

      final json = originalCampaign.toJson();
      final reconstructedCampaign = Campaign.fromJson(json);

      expect(reconstructedCampaign.id, equals(originalCampaign.id));
      expect(reconstructedCampaign.title, equals(originalCampaign.title));
      expect(
        reconstructedCampaign.description,
        equals(originalCampaign.description),
      );
      expect(
        reconstructedCampaign.startDate,
        equals(originalCampaign.startDate),
      );
      expect(reconstructedCampaign.endDate, equals(originalCampaign.endDate));
      expect(reconstructedCampaign.isActive, equals(originalCampaign.isActive));
      expect(reconstructedCampaign.pin, equals(originalCampaign.pin));
      expect(reconstructedCampaign.budget, equals(originalCampaign.budget));
      expect(reconstructedCampaign.imageUrl, equals(originalCampaign.imageUrl));
    });
  });
}
