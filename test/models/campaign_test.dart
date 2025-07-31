import 'package:flutter_test/flutter_test.dart';
import 'package:productmanager/models/campaign.dart';

void main() {
  group('Campaign Model', () {
    test('should create a Campaign with correct values', () {
      final campaign = Campaign(
        id: '1',
        title: 'Test Campaign',
        startDate: DateTime(2025, 7, 31),
        endDate: DateTime(2025, 8, 31),
        description: 'This is a test campaign',
        isActive: true,
        pin: '123456'
      );
      expect(campaign.id, '1');
      expect(campaign.title, 'Test Campaign');
      expect(campaign.startDate, DateTime(2025, 7, 31));
      expect(campaign.endDate, DateTime(2025, 8, 31));
      expect(campaign.description, 'This is a test campaign');
      expect(campaign.isActive, true);
      expect(campaign.pin, '123456');
    });
  });
}
