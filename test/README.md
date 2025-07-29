# Test Suite for Flutter Campaign Management App

This directory contains a comprehensive test suite for the Flutter campaign management application. The tests are organized into multiple categories and files for better maintainability and clarity.

## Test Structure

```
test/
├── all_tests.dart                  # Main test runner that imports all tests
├── models/                         # Model unit tests
│   ├── user_test.dart             # User model tests
│   ├── campaign_test.dart         # Campaign model tests
│   └── product_test.dart          # Product model tests
├── services/                       # Service layer tests
│   ├── firebase_service_test.dart # Firebase service tests
│   ├── user_service_test.dart     # User service tests
│   ├── campaign_service_test.dart # Campaign service tests
│   └── product_service_test.dart  # Product service tests
├── widgets/                        # Widget tests
│   ├── campaign_card_test.dart    # Campaign card widget tests
│   └── product_card_test.dart     # Product card widget tests
├── screens/                        # Screen widget tests (to be added)
├── integration/                    # Integration tests
│   └── app_integration_test.dart  # Full app integration tests
└── README.md                      # This file
```

## Test Categories

### 1. Model Tests (`test/models/`)

Tests for data models and their business logic:

- **User Model Tests**: User normalization, ID generation, serialization
- **Campaign Model Tests**: Date validation, JSON serialization, copyWith functionality
- **Product Model Tests**: Sold percentage calculation, price validation, serialization

### 2. Service Tests (`test/services/`)

Tests for service layer functionality:

- **Firebase Service Tests**: Error handling, initialization validation
- **User Service Tests**: User management, Firebase interaction error handling
- **Campaign Service Tests**: Campaign CRUD operations, utility methods
- **Product Service Tests**: Product management, business logic validation

### 3. Widget Tests (`test/widgets/`)

Tests for UI components:

- **Campaign Card Tests**: Display, interaction, styling validation
- **Product Card Tests**: Product information display, user interactions

### 4. Integration Tests (`test/integration/`)

End-to-end tests for complete user flows:

- **App Integration Tests**: Full app startup, navigation, performance

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories

#### Model Tests Only
```bash
flutter test test/models/
```

#### Service Tests Only
```bash
flutter test test/services/
```

#### Widget Tests Only
```bash
flutter test test/widgets/
```

#### Integration Tests Only
```bash
flutter test test/integration/
```

### Run Specific Test File
```bash
flutter test test/models/user_test.dart
```

### Run All Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests with Detailed Output
```bash
flutter test --reporter expanded
```

## Test Coverage

The test suite covers:

- ✅ **Models**: Data validation, serialization, business logic
- ✅ **Services**: Firebase interaction, error handling, utility methods
- ✅ **Widgets**: UI component rendering, user interactions
- ✅ **Integration**: App startup, navigation, performance
- ⚠️ **Screens**: Screen-level widget tests (to be implemented)

## Test Conventions

### Naming Conventions
- Test files end with `_test.dart`
- Test groups describe the component being tested
- Individual tests describe specific behaviors

### Test Structure
```dart
void main() {
  group('ComponentName Tests', () {
    setUp(() {
      // Test setup
    });
    
    test('should do something when condition', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Mock Data
- Use consistent test data across tests
- Reset state in `setUp()` methods
- Use descriptive test data that makes tests readable

## Firebase Testing Notes

Since the app uses Firebase, most service tests focus on:
- Error handling when Firebase is not initialized
- Proper exception throwing and catching
- Service method structure validation

For full Firebase testing, you would typically:
- Use Firebase emulators for integration tests
- Mock Firebase services for unit tests
- Use test Firebase projects for end-to-end tests

## Widget Testing Notes

Widget tests use Flutter's testing framework to:
- Verify UI components render correctly
- Test user interactions (taps, text input)
- Validate styling and layout
- Ensure accessibility features work

## Performance Testing

Integration tests include basic performance checks:
- App startup time validation
- Memory usage monitoring
- Responsiveness under load

## Future Improvements

1. **Screen Tests**: Add comprehensive screen-level widget tests
2. **Firebase Mocking**: Implement proper Firebase service mocking
3. **E2E Tests**: Add real device end-to-end tests using `integration_test` package
4. **Golden Tests**: Add visual regression tests for widgets
5. **Performance Profiling**: Add detailed performance benchmarks

## Running Tests in CI/CD

For continuous integration, use:

```yaml
# Example GitHub Actions step
- name: Run tests
  run: |
    flutter test --coverage
    flutter test test/integration/ --no-coverage
```

## Debugging Tests

### View Test Output
```bash
flutter test --reporter expanded --verbose
```

### Debug Failing Tests
```bash
flutter test test/specific_test.dart --debug
```

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Best Practices

1. **Test Independence**: Each test should be independent and not rely on others
2. **Clear Assertions**: Use descriptive assertion messages
3. **Setup/Teardown**: Properly initialize and clean up test state
4. **Mock External Dependencies**: Mock Firebase, HTTP requests, etc.
5. **Test Edge Cases**: Include boundary conditions and error scenarios
6. **Readable Tests**: Write tests that serve as documentation

## Contributing to Tests

When adding new features:

1. Add corresponding unit tests for models/services
2. Add widget tests for new UI components
3. Update integration tests if adding new user flows
4. Ensure test coverage remains high
5. Follow existing test patterns and conventions

## Test Data

The test suite uses consistent test data:
- Test users with predictable IDs and names
- Sample campaigns with known date ranges
- Products with specific pricing and quantities

This ensures tests are predictable and maintainable.
