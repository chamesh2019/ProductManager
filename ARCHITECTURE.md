# ProductManager Architecture Overview

Comprehensive technical architecture documentation for the ProductManager Flutter application.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Application Flow](#application-flow)
3. [Data Architecture](#data-architecture)
4. [Security Architecture](#security-architecture)
5. [Scalability Considerations](#scalability-considerations)
6. [Technology Stack](#technology-stack)
7. [Integration Patterns](#integration-patterns)
8. [Performance Considerations](#performance-considerations)

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Applications                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Android   │  │     iOS     │  │    Web (Future)     │  │
│  │    App      │  │     App     │  │       App           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS/WebSocket
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  Firebase Cloud Platform                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Firestore  │  │ Firebase    │  │   Firebase          │  │
│  │  Database   │  │ Auth        │  │   Storage           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  Flutter Application                        │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │               Presentation Layer                    │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │   Screens   │  │   Widgets   │  │   Dialogs   │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                            │                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Business Logic Layer                   │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │   Services  │  │ Validators  │  │   Utils     │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                            │                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                 Data Layer                          │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │   Models    │  │ Repositories│  │   Cache     │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer
- **Screens**: Full-page UI components representing app states
- **Widgets**: Reusable UI components for consistent design
- **Dialogs**: Modal interactions for user input and confirmations

#### Business Logic Layer
- **Services**: Core business operations and data manipulation
- **Validators**: Input validation and data integrity checks
- **Utils**: Helper functions and common operations

#### Data Layer
- **Models**: Data structures and object representations
- **Repositories**: Data access abstraction (implemented by Services)
- **Cache**: Local storage and offline data management

## Application Flow

### User Registration Flow

```
Start App
    │
    ▼
Check Local User Data
    │
    ├─ User Exists ────────────────┐
    │                              │
    ▼                              │
Registration Screen                │
    │                              │
    ▼                              │
Enter User Details                 │
    │                              │
    ▼                              │
Upload Avatar (Optional)           │
    │                              │
    ▼                              │
Save to Firebase + Local           │
    │                              │
    └──────────────────────────────┤
                                   │
                                   ▼
                             PIN Entry Screen
```

### Campaign Access Flow

```
PIN Entry Screen
    │
    ▼
Enter Campaign PIN
    │
    ├─ PIN = 547698 (Admin) ──────────────────┐
    │                                         │
    ▼                                         │
Query Firebase for Campaign by PIN           │
    │                                         │
    ├─ Campaign Found ──────────┐             │
    │                           │             │
    ▼                           │             │
Show Error Message             │             │
    │                           │             │
    └─ Return to PIN Entry     │             │
                                │             │
                                ▼             ▼
                          Products Screen  Campaign Management
```

### Sales Update Flow

```
Products Screen
    │
    ▼
Select Product Card
    │
    ▼
Show Update Dialog
    │
    ▼
Enter New Sales Amount
    │
    ▼
Validate Input
    │
    ├─ Invalid ──── Show Error
    │
    ▼
Update Product in Firebase
    │
    ▼
Log Change in Change Log
    │
    ▼
Update Local UI
    │
    ▼
Show Success Confirmation
```

### Admin Management Flow

```
Admin PIN Entry (547698)
    │
    ▼
Campaign Management Screen
    │
    ├─ View Campaigns ──────────────┐
    │                               │
    ├─ View Users ──────────────────┤
    │                               │
    └─ View Change Logs ────────────┤
                                    │
                                    ▼
                              Management Actions
                              (Create, Edit, Delete)
```

## Data Architecture

### Firebase Firestore Schema

#### Collection: `users`
```json
{
  "id": "string (generated from NIC or normalized name)",
  "fullName": "string",
  "normalizedFullName": "string (for searching)",
  "nic": "string (optional)",
  "avatarUrl": "string (Firebase Storage URL)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Collection: `campaigns`
```json
{
  "id": "string (auto-generated document ID)",
  "title": "string",
  "description": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "isActive": "boolean",
  "pin": "string (6-digit unique identifier)",
  "budget": "number (optional)",
  "imageUrl": "string (Firebase Storage URL)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Collection: `products`
```json
{
  "id": "string (auto-generated document ID)",
  "name": "string",
  "description": "string (optional)",
  "campaignId": "string (reference to campaign)",
  "price": "number",
  "targetAmount": "number",
  "currentSoldAmount": "number",
  "imageUrl": "string (Firebase Storage URL)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Collection: `productChangeLogs`
```json
{
  "id": "string (auto-generated document ID)",
  "productId": "string (reference to product)",
  "userId": "string (reference to user)",
  "userName": "string (cached for performance)",
  "previousAmount": "number",
  "newAmount": "number",
  "changeType": "string (manual_update, correction, etc.)",
  "notes": "string (optional)",
  "timestamp": "timestamp"
}
```

### Data Relationships

```
User (1) ────────────── (∞) ProductChangeLog
                              │
Campaign (1) ─── (∞) Product (1) ── (∞) ProductChangeLog
```

### Indexing Strategy

**Firestore Composite Indexes:**
- `products`: `campaignId` (ascending) + `createdAt` (descending)
- `productChangeLogs`: `productId` (ascending) + `timestamp` (descending)
- `productChangeLogs`: `userId` (ascending) + `timestamp` (descending)
- `campaigns`: `pin` (ascending) + `isActive` (ascending)

### Local Storage Architecture

**SharedPreferences Keys:**
- `user_data`: JSON serialized User object
- `user_registered`: Boolean flag for registration status
- `app_version`: Version tracking for data migration
- `last_sync`: Timestamp of last successful sync

**Cache Strategy:**
- Firebase Firestore automatic offline persistence
- User data cached locally for quick access
- Images cached by Flutter's image loading system
- No manual cache invalidation (Firebase handles sync)

## Security Architecture

### Authentication Model

```
┌─────────────────────────────────────────────────────────────┐
│                 Authentication Flow                          │
│                                                             │
│  User Registration ──────┐                                  │
│          │               │                                  │
│          ▼               ▼                                  │
│  Local Storage    Firebase Anonymous Auth                   │
│          │               │                                  │
│          └───────────────┴─── PIN Verification             │
│                               │                             │
│                               ▼                             │
│                        Campaign Access                      │
└─────────────────────────────────────────────────────────────┘
```

### Access Control Matrix

| Role | User Registration | Campaign Access | Product View | Sales Update | Admin Functions |
|------|------------------|-----------------|--------------|--------------|----------------|
| Unregistered | ✓ | ✗ | ✗ | ✗ | ✗ |
| Regular User | ✓ | PIN-based | Campaign-specific | ✓ | ✗ |
| Admin User | ✓ | Full Access | All | ✓ | ✓ |

### Data Security Measures

1. **Firebase Security Rules**
   - Authenticated access only
   - Document-level permissions
   - Input validation at database level

2. **Client-Side Security**
   - Input sanitization
   - PIN masking in UI
   - Secure local storage

3. **Network Security**
   - HTTPS-only communication
   - Firebase SDK encryption
   - Certificate pinning (Firebase managed)

### Privacy Considerations

- **PII Handling**: User names and NIC numbers are personal data
- **Image Storage**: User avatars stored securely in Firebase Storage
- **Audit Trail**: Complete change logging for accountability
- **GDPR Compliance**: User data deletion capabilities (admin function)

## Scalability Considerations

### Current Limitations

- **Concurrent Users**: Limited by Firebase Firestore quotas
- **Data Size**: Document size limits (1MB per document)
- **Read/Write Operations**: Firebase pricing based on operations
- **Offline Storage**: Device storage limitations

### Scaling Strategies

#### Horizontal Scaling
```
Multiple Firebase Projects
    │
    ├─ Production Environment
    ├─ Staging Environment
    └─ Development Environment
```

#### Data Partitioning
```
By Region:
├─ firestore-us-central
├─ firestore-europe-west
└─ firestore-asia-southeast

By Company/Organization:
├─ company-a-project
├─ company-b-project
└─ company-c-project
```

#### Performance Optimization
- **Pagination**: Implement for large product lists
- **Caching**: Extended local caching strategies
- **Image Optimization**: Automatic resizing and compression
- **Query Optimization**: Minimize complex queries

### Load Testing Considerations

- **User Registration Burst**: Multiple simultaneous registrations
- **PIN Entry Spikes**: Campaign launch traffic patterns  
- **Sales Update Concurrency**: Multiple users updating same products
- **Image Upload Volume**: Large file uploads during peak usage

## Technology Stack

### Core Technologies

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| Framework | Flutter | 3.8.1+ | Cross-platform UI framework |
| Language | Dart | 3.0+ | Programming language |
| Backend | Firebase | Latest | Backend-as-a-Service |
| Database | Firestore | Latest | NoSQL document database |
| Storage | Firebase Storage | Latest | File and image storage |
| Auth | Firebase Auth | Latest | Authentication service |

### Dependencies

**Production Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  image_picker: ^1.0.5
  percent_indicator: ^4.2.5
  firebase_core: ^3.1.0
  cloud_firestore: ^5.0.1
  firebase_auth: ^5.1.0
  firebase_storage: ^12.0.1
  shared_preferences: ^2.2.2
```

**Development Dependencies:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### Platform Support

| Platform | Support Level | Notes |
|----------|---------------|-------|
| Android | Full Support | Target API 33+ |
| iOS | Full Support | iOS 12.0+ |
| Web | Future Support | Progressive Web App potential |
| Desktop | Not Planned | Mobile-first design |

## Integration Patterns

### Firebase Integration Pattern

```dart
abstract class FirebaseRepository<T> {
  CollectionReference get collection;
  T fromFirestore(DocumentSnapshot doc);
  Map<String, dynamic> toFirestore(T item);
  
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> save(T item);
  Future<void> delete(String id);
}
```

### Service Layer Pattern

```dart
class ProductService extends FirebaseRepository<Product> {
  static final _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();
  
  @override
  CollectionReference get collection => 
    FirebaseFirestore.instance.collection('products');
  
  // Business logic methods
  Future<void> updateProductSales(String productId, int newAmount, String userId) async {
    // Complex business logic here
  }
}
```

### Error Handling Pattern

```dart
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  ApiResponse.success(this.data) : error = null, isSuccess = true;
  ApiResponse.error(this.error) : data = null, isSuccess = false;
}
```

### State Management Pattern

```dart
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  void setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }
  
  void setError(String? error) {
    setState(() => _error = error);
  }
}
```

## Performance Considerations

### Database Performance

1. **Query Optimization**
   - Use compound indexes for complex queries
   - Limit query results with pagination
   - Cache frequently accessed data

2. **Write Performance**
   - Batch writes for multiple operations
   - Use transactions for data consistency
   - Implement optimistic updates

3. **Read Performance**
   - Enable offline persistence
   - Use real-time listeners judiciously
   - Implement proper loading states

### UI Performance

1. **Widget Optimization**
   - Use const constructors where possible
   - Implement proper key usage
   - Optimize ListView and GridView

2. **Image Performance**
   - Implement image caching
   - Use appropriate image formats
   - Implement lazy loading

3. **Memory Management**
   - Dispose controllers and streams
   - Use weak references for listeners
   - Monitor memory usage in profiler

### Network Performance

1. **Data Transfer**
   - Minimize payload size
   - Compress images before upload
   - Use appropriate data formats

2. **Connection Handling**
   - Implement retry mechanisms
   - Handle network state changes
   - Provide offline functionality

3. **Caching Strategy**
   - Cache static data locally
   - Implement cache invalidation
   - Use CDN for static assets

---

This architecture documentation provides a comprehensive view of the ProductManager application's technical design. It serves as a foundation for development decisions and future enhancements. Regular updates to this document should accompany major architectural changes.