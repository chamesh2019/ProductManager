import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'models/user_test.dart' as user_tests;
import 'models/campaign_test.dart' as campaign_tests;
import 'models/product_test.dart' as product_tests;
import 'services/firebase_service_test.dart' as firebase_service_tests;
import 'services/user_service_test.dart' as user_service_tests;
import 'services/campaign_service_test.dart' as campaign_service_tests;
import 'services/product_service_test.dart' as product_service_tests;
import 'widgets/campaign_card_test.dart' as campaign_card_tests;
import 'widgets/product_card_test.dart' as product_card_tests;
import 'integration/app_integration_test.dart' as integration_tests;

void main() {
  group('All Tests', () {
    group('Model Tests', () {
      group('User Model', user_tests.main);
      group('Campaign Model', campaign_tests.main);
      group('Product Model', product_tests.main);
    });

    group('Service Tests', () {
      group('Firebase Service', firebase_service_tests.main);
      group('User Service', user_service_tests.main);
      group('Campaign Service', campaign_service_tests.main);
      group('Product Service', product_service_tests.main);
    });

    group('Widget Tests', () {
      group('Campaign Card Widget', campaign_card_tests.main);
      group('Product Card Widget', product_card_tests.main);
    });

    group('Integration Tests', () {
      group('App Integration', integration_tests.main);
    });
  });
}
