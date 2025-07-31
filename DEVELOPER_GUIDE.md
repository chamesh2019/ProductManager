# ProductManager Developer Guide

Technical implementation guide for developers working on the ProductManager Flutter application.

## Table of Contents

1. [Development Environment](#development-environment)
2. [Project Structure](#project-structure)
3. [Architecture Overview](#architecture-overview)
4. [Core Services](#core-services)
5. [Data Models](#data-models)
6. [State Management](#state-management)
7. [Firebase Integration](#firebase-integration)
8. [UI Components](#ui-components)
9. [Testing Strategy](#testing-strategy)
10. [Build and Deployment](#build-and-deployment)
11. [Contributing Guidelines](#contributing-guidelines)

## Development Environment

### Prerequisites

- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio**: 2022.3 or higher (for Android development)
- **Xcode**: 14.0 or higher (for iOS development, macOS only)
- **Firebase CLI**: Latest version
- **FlutterFire CLI**: For Firebase configuration

### Setup Instructions

```bash
# Clone the repository
git clone https://github.com/chamesh2019/ProductManager.git
cd ProductManager

# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure

# Run the application
flutter run
```

### IDE Configuration

#### VS Code Extensions
- Flutter
- Dart
- Firebase
- GitLens
- Error Lens

#### Android Studio Plugins
- Flutter
- Dart
- Firebase

### Environment Variables

Create a `.env` file for local development (not tracked in git):
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
DEBUG_MODE=true
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── campaign.dart
│   ├── product.dart
│   └── product_change_log.dart
├── services/                 # Business logic and API services
│   ├── firebase_service.dart
│   ├── user_service.dart
│   ├── campaign_service.dart
│   ├── product_service.dart
│   └── product_change_log_service.dart
├── screens/                  # UI screens/pages
│   ├── user_registration_screen.dart
│   ├── pin_entry_screen.dart
│   ├── campaign_screen.dart
│   ├── products_screen.dart
│   ├── product_form_screen.dart
│   ├── campaign_form_screen.dart
│   ├── campaign_products_screen.dart
│   ├── product_change_log_screen.dart
│   └── firebase_debug_screen.dart
└── widgets/                  # Reusable UI components
    ├── product_card.dart
    ├── campaign_card.dart
    ├── user_avatar.dart
    ├── pin_display.dart
    ├── number_pad_button.dart
    ├── welcome_header.dart
    ├── date_selector.dart
    ├── empty_state_widget.dart
    ├── delete_confirmation_dialog.dart
    └── user_list_widget.dart

test/
├── widget_test.dart          # Widget tests
├── integration/              # Integration tests
├── models/                   # Model tests
├── services/                 # Service tests
└── widgets/                  # Widget component tests

android/                      # Android-specific code
ios/                          # iOS-specific code
web/                          # Web-specific code (if supported)
```

## Architecture Overview

### Design Patterns

The application follows these architectural patterns:

1. **Layered Architecture**
   - Presentation Layer (Screens/Widgets)
   - Business Logic Layer (Services)
   - Data Layer (Models/Firebase)

2. **Repository Pattern**
   - Services act as repositories for data access
   - Abstraction between UI and data sources
   - Easier testing and mocking

3. **Factory Pattern**
   - Model creation from JSON/Firestore data
   - Consistent object instantiation

### Data Flow

```
UI (Screens/Widgets)
    ↓
Services (Business Logic)
    ↓
Firebase (Data Storage)
```

### Offline-First Approach

- Firebase Firestore provides automatic offline caching
- Local SharedPreferences for user sessions
- Optimistic updates with eventual consistency
- Conflict resolution handled by Firebase

## Core Services

### FirebaseService

Central Firebase configuration and initialization:

```dart
class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Enable offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }
}
```

**Key Features:**
- Firebase initialization with default options
- Offline persistence configuration
- Error handling for initialization failures

### UserService

User management and authentication:

```dart
class UserService {
  static Future<bool> isUserRegistered() async
  static Future<User?> getUser() async
  static Future<void> saveUser(User user) async
  static Future<String> uploadUserAvatar(String imagePath) async
}
```

**Key Features:**
- Local storage with SharedPreferences
- Firebase Firestore user document management
- Image upload to Firebase Storage
- User ID generation from NIC or normalized name

### CampaignService

Campaign data management:

```dart
class CampaignService {
  static Future<List<Campaign>> getAllCampaigns() async
  static Future<List<Campaign>> getCampainbyPin(String pin) async
  static Future<void> saveCampaign(Campaign campaign) async
  static Future<void> deleteCampaign(String campaignId) async
}
```

**Key Features:**
- CRUD operations for campaigns
- PIN-based campaign filtering
- Firebase Firestore integration
- Real-time updates support

### ProductService

Product data management:

```dart
class ProductService {
  static Future<List<Product>> getAllProducts() async
  static Future<List<Product>> getProductsByCampaign(String campaignId) async
  static Future<void> saveProduct(Product product) async
  static Future<void> updateProductSales(String productId, int newSoldAmount, String userId) async
}
```

**Key Features:**
- Product CRUD operations
- Campaign-specific product filtering
- Sales update with change logging
- Image upload support

### ProductChangeLogService

Change tracking and audit trails:

```dart
class ProductChangeLogService {
  static Future<void> logProductChange(ProductChangeLog changeLog) async
  static Future<List<ProductChangeLog>> getChangeLogForProduct(String productId) async
  static Future<List<ProductChangeLog>> getAllChangeLogs() async
}
```

**Key Features:**
- Comprehensive change logging
- Audit trail maintenance
- User activity tracking
- Timestamp and change type recording

## Data Models

### User Model

```dart
class User {
  final String? id;
  final String fullName;
  final String? nic;
  final String? avatarUrl;
  final DateTime? createdAt;
  
  // Methods
  String generateUserId()
  String get normalizedFullName
  factory User.fromFirestore(Map<String, dynamic> data, String docId)
  Map<String, dynamic> toFirestore()
}
```

**Key Features:**
- Flexible ID generation (NIC or normalized name)
- Firestore serialization/deserialization
- Local storage JSON support

### Campaign Model

```dart
class Campaign {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final double? budget;
  final String? imageUrl;
  final String pin;
  
  // Methods
  factory Campaign.fromJson(Map<String, dynamic> json)
  Map<String, dynamic> toJson()
  Campaign copyWith({...})
}
```

**Key Features:**
- Date range validation
- PIN-based access control
- Optional budget and image support
- Immutable design with copyWith

### Product Model

```dart
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int targetAmount;
  final int currentSoldAmount;
  final String campaignId;
  final String? description;
  
  // Computed properties
  double get soldPercentage
}
```

**Key Features:**
- Automatic progress calculation
- Campaign association
- Price and target tracking
- Immutable design

### ProductChangeLog Model

```dart
class ProductChangeLog {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int previousAmount;
  final int newAmount;
  final DateTime timestamp;
  final String changeType;
  final String? notes;
}
```

**Key Features:**
- Complete audit information
- User identification
- Change type classification
- Optional notes support

## State Management

### Current Approach: StatefulWidget

The application currently uses Flutter's built-in StatefulWidget for state management:

```dart
class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  Future<void> _loadProducts() async {
    // Load data and update state
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }
}
```

### State Management Best Practices

1. **Local State**: Use StatefulWidget for screen-specific state
2. **Async Operations**: Always handle loading states
3. **Error Handling**: Provide user feedback for errors
4. **Memory Management**: Dispose controllers and listeners

### Future Considerations

For scaling, consider migrating to:
- **Provider**: For dependency injection and state sharing
- **Riverpod**: For more robust state management
- **Bloc/Cubit**: For complex business logic

## Firebase Integration

### Firestore Database Structure

```
users/
  {userId}/
    id: string
    fullName: string
    normalizedFullName: string
    nic: string
    avatarUrl: string
    createdAt: timestamp

campaigns/
  {campaignId}/
    id: string
    title: string
    description: string
    startDate: timestamp
    endDate: timestamp
    isActive: boolean
    pin: string
    budget: number
    imageUrl: string

products/
  {productId}/
    id: string
    name: string
    description: string
    campaignId: string
    price: number
    targetAmount: number
    currentSoldAmount: number
    imageUrl: string
    createdAt: timestamp
    updatedAt: timestamp

productChangeLogs/
  {changeLogId}/
    id: string
    productId: string
    userId: string
    userName: string
    previousAmount: number
    newAmount: number
    timestamp: timestamp
    changeType: string
    notes: string
```

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    
    // Campaigns are readable by authenticated users
    match /campaigns/{campaignId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Add admin check
    }
    
    // Products are readable and writable by authenticated users
    match /products/{productId} {
      allow read, write: if request.auth != null;
    }
    
    // Change logs are readable by authenticated users
    match /productChangeLogs/{logId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Firebase Storage

Used for storing:
- User avatar images
- Product images
- Campaign images

**File Structure:**
```
users/
  {userId}/
    avatar.{extension}

products/
  {productId}/
    image.{extension}

campaigns/
  {campaignId}/
    image.{extension}
```

## UI Components

### Design System

The application uses Material Design 3 with custom theming:

```dart
ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Roboto',
  // Additional theme customizations
)
```

### Reusable Widgets

#### ProductCard
Displays product information with progress indicators:
```dart
ProductCard(
  product: product,
  onTap: () => _showUpdateDialog(product),
)
```

#### CampaignCard
Shows campaign overview with status indicators:
```dart
CampaignCard(
  campaign: campaign,
  onTap: () => _navigateToProducts(campaign),
)
```

#### UserAvatar
Displays user profile pictures with fallback:
```dart
UserAvatar(
  imageUrl: user.avatarUrl,
  name: user.fullName,
  size: 60,
)
```

### Screen Navigation

Navigation follows a hierarchical structure:
1. User Registration (first time)
2. PIN Entry
3. Campaign/Products View
4. Admin Features (if applicable)

## Testing Strategy

### Unit Tests

Test individual functions and classes:

```dart
// test/services/user_service_test.dart
void main() {
  group('UserService', () {
    test('should generate user ID from NIC', () {
      final user = User(fullName: 'John Doe', nic: '123456789V');
      expect(user.generateUserId(), '123456789V');
    });
  });
}
```

### Widget Tests

Test individual widget behavior:

```dart
// test/widgets/product_card_test.dart
void main() {
  testWidgets('ProductCard displays product information', (tester) async {
    final product = Product(/* test data */);
    
    await tester.pumpWidget(
      MaterialApp(home: ProductCard(product: product)),
    );
    
    expect(find.text(product.name), findsOneWidget);
  });
}
```

### Integration Tests

Test complete workflows:

```dart
// test/integration/user_registration_test.dart
void main() {
  group('User Registration Flow', () {
    testWidgets('complete registration process', (tester) async {
      // Test complete user registration workflow
    });
  });
}
```

### Testing Guidelines

1. **Coverage**: Aim for >80% code coverage
2. **Mock Services**: Mock Firebase services for unit tests
3. **Widget Tests**: Test UI components in isolation
4. **Integration Tests**: Test complete user workflows
5. **Performance Tests**: Test with large datasets

## Build and Deployment

### Development Build

```bash
# Debug build
flutter run --debug

# Profile build (for performance testing)
flutter run --profile

# Release build
flutter run --release
```

### Android Release

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS Release

```bash
# Build for iOS
flutter build ios --release

# Build IPA (for App Store)
flutter build ipa --release
```

### Environment Configuration

Create different Firebase projects for different environments:

- **Development**: Local testing
- **Staging**: Pre-production testing
- **Production**: Live application

### CI/CD Pipeline

Recommended GitHub Actions workflow:

```yaml
name: Build and Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --debug
```

## Contributing Guidelines

### Code Style

Follow Dart's official style guide:
- Use `dart format` for formatting
- Follow naming conventions
- Add documentation comments for public APIs

### Git Workflow

1. **Feature Branches**: Create branches for new features
2. **Commit Messages**: Use conventional commit format
3. **Pull Requests**: Require code review before merging
4. **Testing**: All tests must pass before merging

### Code Review Checklist

- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes without versioning
- [ ] Performance impact considered
- [ ] Security implications reviewed

### Development Best Practices

1. **Error Handling**: Always handle potential errors
2. **Null Safety**: Leverage Dart's null safety features
3. **Performance**: Consider widget rebuilds and memory usage
4. **Accessibility**: Include semantic labels and proper navigation
5. **Internationalization**: Prepare for multi-language support

### Debugging

#### Flutter Inspector
Use Flutter Inspector for widget tree analysis:
```bash
flutter run --debug
# Then use Flutter Inspector in your IDE
```

#### Firebase Debugging
Enable Firebase debugging in development:
```dart
if (kDebugMode) {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    sslEnabled: false, // Only for local debugging
  );
}
```

#### Performance Profiling
Use Flutter's performance profiling tools:
```bash
flutter run --profile
# Use DevTools for performance analysis
```

---

This developer guide provides the foundation for understanding and contributing to the ProductManager application. For specific implementation questions, refer to the inline code documentation and existing examples in the codebase.