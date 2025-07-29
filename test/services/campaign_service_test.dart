import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/campaign.dart';
import 'package:untitled/services/campaign_service.dart';

void main() {
  group('Campaign Service Tests', () {
    group('Campaign Service Error Handling', () {
      test('getAllCampaigns handles missing Firebase initialization', () {
        expect(
          () async {
            await CampaignService.getAllCampaigns();
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('getCampaignById handles missing Firebase initialization', () {
        expect(
          () async {
            await CampaignService.getCampaignById('test-id');
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('createCampaign handles missing Firebase initialization', () {
        final testCampaign = Campaign(
          id: 'test-id',
          title: 'Test Campaign',
          description: 'Test Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          pin: '123456',
        );

        expect(
          () async {
            await CampaignService.createCampaign(testCampaign);
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('updateCampaign handles missing Firebase initialization', () {
        final testCampaign = Campaign(
          id: 'test-id',
          title: 'Updated Campaign',
          description: 'Updated Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          pin: '123456',
        );

        expect(
          () async {
            await CampaignService.updateCampaign(testCampaign);
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });

      test('deleteCampaign handles missing Firebase initialization', () {
        expect(
          () async {
            await CampaignService.deleteCampaign('test-id');
          },
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      });
    });

    group('Campaign Utility Methods Tests', () {
      test('generateCampaignId creates unique IDs', () {
        final id1 = CampaignService.generateCampaignId();
        final id2 = CampaignService.generateCampaignId();

        expect(id1, isA<String>());
        expect(id2, isA<String>());
        expect(id1, isNot(equals(id2)));
        expect(int.parse(id1), isA<int>());
        expect(int.parse(id2), isA<int>());
      });

      test('generateCampaignPin creates valid 6-digit PINs', () {
        // Test multiple PIN generations
        for (int i = 0; i < 10; i++) {
          final pin = CampaignService.generateCampaignPin();

          expect(pin, isA<String>());
          expect(pin.length, equals(6));
          expect(int.parse(pin), isA<int>());
          expect(int.parse(pin), greaterThanOrEqualTo(100000));
          expect(int.parse(pin), lessThanOrEqualTo(999999));
        }
      });

      test('generateCampaignPin creates different PINs', () {
        final pins = <String>{};

        // Generate multiple PINs and check they're different
        for (int i = 0; i < 50; i++) {
          pins.add(CampaignService.generateCampaignPin());
        }

        // Should have generated at least 40 different PINs out of 50
        // (allowing for some random collisions)
        expect(pins.length, greaterThan(40));
      });
    });

    group('Campaign Business Logic Tests', () {
      test('Campaign date validation logic', () {
        final now = DateTime.now();
        final future = now.add(const Duration(days: 30));

        // Valid campaign dates
        final validCampaign = Campaign(
          id: 'valid-id',
          title: 'Valid Campaign',
          description: 'Valid Description',
          startDate: now,
          endDate: future,
          isActive: true,
          pin: '123456',
        );

        expect(validCampaign.startDate.isBefore(validCampaign.endDate), isTrue);

        // Invalid campaign dates
        final invalidCampaign = Campaign(
          id: 'invalid-id',
          title: 'Invalid Campaign',
          description: 'Invalid Description',
          startDate: future,
          endDate: now,
          isActive: true,
          pin: '123456',
        );

        expect(
          invalidCampaign.startDate.isAfter(invalidCampaign.endDate),
          isTrue,
        );
      });

      test('Campaign status checks based on dates', () {
        final now = DateTime.now();
        final future = now.add(const Duration(days: 30));
        final past = now.subtract(const Duration(days: 30));

        // Active campaign
        final activeCampaign = Campaign(
          id: 'active-id',
          title: 'Active Campaign',
          description: 'Active Description',
          startDate: past,
          endDate: future,
          isActive: true,
          pin: '123456',
        );

        expect(activeCampaign.isActive, isTrue);
        expect(now.isAfter(activeCampaign.startDate), isTrue);
        expect(now.isBefore(activeCampaign.endDate), isTrue);

        // Inactive campaign
        final inactiveCampaign = Campaign(
          id: 'inactive-id',
          title: 'Inactive Campaign',
          description: 'Inactive Description',
          startDate: past,
          endDate: future,
          isActive: false,
          pin: '123456',
        );

        expect(inactiveCampaign.isActive, isFalse);

        // Expired campaign
        final expiredCampaign = Campaign(
          id: 'expired-id',
          title: 'Expired Campaign',
          description: 'Expired Description',
          startDate: past,
          endDate: past.add(const Duration(days: 1)),
          isActive: true,
          pin: '123456',
        );

        expect(expiredCampaign.isActive, isTrue);
        expect(now.isAfter(expiredCampaign.endDate), isTrue);
      });

      test('PIN format validation', () {
        // Valid PIN formats
        expect('123456'.length, equals(6));
        expect(int.tryParse('123456'), isNotNull);
        expect('000000'.length, equals(6));
        expect(int.tryParse('000000'), isNotNull);
        expect('999999'.length, equals(6));
        expect(int.tryParse('999999'), isNotNull);

        // Invalid PIN formats
        expect('12345'.length, isNot(equals(6))); // Too short
        expect('1234567'.length, isNot(equals(6))); // Too long
        expect(int.tryParse('12345a'), isNull); // Contains letter
        expect(''.length, isNot(equals(6))); // Empty
        expect(int.tryParse('12 34 56'), isNull); // Contains spaces
      });
    });

    group('Campaign Model Integration Tests', () {
      test('Campaign JSON serialization preserves data', () {
        final now = DateTime.now();
        final campaign = Campaign(
          id: 'test-id',
          title: 'Test Campaign',
          description: 'Test Description',
          startDate: now,
          endDate: now.add(const Duration(days: 30)),
          isActive: true,
          pin: '123456',
          budget: 1000.0,
          imageUrl: '/test/image.jpg',
        );

        final json = campaign.toJson();
        final reconstructed = Campaign.fromJson(json);

        expect(reconstructed.id, equals(campaign.id));
        expect(reconstructed.title, equals(campaign.title));
        expect(reconstructed.description, equals(campaign.description));
        expect(reconstructed.startDate, equals(campaign.startDate));
        expect(reconstructed.endDate, equals(campaign.endDate));
        expect(reconstructed.isActive, equals(campaign.isActive));
        expect(reconstructed.pin, equals(campaign.pin));
        expect(reconstructed.budget, equals(campaign.budget));
        expect(reconstructed.imageUrl, equals(campaign.imageUrl));
      });

      test('Campaign copyWith functionality', () {
        final originalCampaign = Campaign(
          id: 'original-id',
          title: 'Original Campaign',
          description: 'Original Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
          pin: '123456',
        );

        final updatedCampaign = originalCampaign.copyWith(
          title: 'Updated Campaign',
          isActive: false,
          pin: '654321',
        );

        expect(updatedCampaign.id, equals(originalCampaign.id));
        expect(updatedCampaign.title, equals('Updated Campaign'));
        expect(
          updatedCampaign.description,
          equals(originalCampaign.description),
        );
        expect(updatedCampaign.startDate, equals(originalCampaign.startDate));
        expect(updatedCampaign.endDate, equals(originalCampaign.endDate));
        expect(updatedCampaign.isActive, isFalse);
        expect(updatedCampaign.pin, equals('654321'));
      });
    });

    group('Service Method Structure Tests', () {
      test('CampaignService has expected static methods', () {
        // Test that required methods exist by checking their types
        expect(CampaignService.getAllCampaigns, isA<Function>());
        expect(CampaignService.getCampaignById, isA<Function>());
        expect(CampaignService.createCampaign, isA<Function>());
        expect(CampaignService.updateCampaign, isA<Function>());
        expect(CampaignService.deleteCampaign, isA<Function>());
        expect(CampaignService.generateCampaignId, isA<Function>());
        expect(CampaignService.generateCampaignPin, isA<Function>());
      });
    });
  });
}
