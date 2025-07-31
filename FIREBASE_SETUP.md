# Firebase Setup Instructions

This project **requires** Firebase for cloud data storage and synchronization. The app will not run without proper Firebase configuration. Follow these steps to set up Firebase for your project.

## Prerequisites

1. [Firebase CLI](https://firebase.google.com/docs/cli) installed on your system
2. A Google account
3. Flutter development environment set up

## Setup Steps

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project name (e.g., "untitled-app")
4. Follow the setup wizard

### 2. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 3. Configure Firebase for Flutter

Run the following command in your project root directory:

```bash
flutterfire configure
```

This will:
- Automatically register your Flutter app with Firebase
- Create/update `firebase_options.dart` with your project configuration
- Set up platform-specific configuration files

### 4. Enable Firestore Database

1. In the Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Start in "test mode" for development (you can update security rules later)
4. Choose a location for your database

### 5. Enable Authentication (Optional)

1. In the Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable sign-in methods as needed

### 6. Enable Storage (Optional)

1. In the Firebase Console, go to "Storage"
2. Click "Get started"
3. Set up security rules as needed

## Firestore Collections

The app uses the following Firestore collections with specific access patterns:

- `users` - User registration and profile data
- `campaigns` - Campaign information with PIN-based access control
- `products` - Product data associated with campaigns
- `productChangeLogs` - Audit trail for all product changes

### Required Firestore Indexes

The application requires these composite indexes for optimal performance:

```javascript
// Composite indexes (create these in Firebase Console)
// Collection: products
// Fields: "campaignId" (Ascending), "createdAt" (Descending)

// Collection: productChangeLogs  
// Fields: "productId" (Ascending), "timestamp" (Descending)

// Collection: productChangeLogs
// Fields: "userId" (Ascending), "timestamp" (Descending)

// Collection: campaigns
// Fields: "pin" (Ascending), "isActive" (Ascending)
```

To create these indexes:
1. Go to Firebase Console → Firestore Database → Indexes
2. Click "Create Index"
3. Add the fields as specified above

## Data Structure

### Users Collection (`users/`)
```json
{
  "id": "string (generated from NIC or normalized name)",
  "fullName": "string",
  "normalizedFullName": "string (for searching)",
  "nic": "string (optional - National Identity Card)",
  "avatarUrl": "string (Firebase Storage URL, optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Notes:**
- User ID is automatically generated from NIC if provided, otherwise from normalized full name
- NIC field supports various formats (e.g., "123456789V", "199812345678")
- Avatar images are stored in Firebase Storage under `users/{userId}/`

### Campaigns Collection (`campaigns/`)
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
  "imageUrl": "string (Firebase Storage URL, optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Notes:**
- Each campaign has a unique PIN for access control
- Admin PIN `547698` provides special administrative access
- Campaign images are stored in Firebase Storage under `campaigns/{campaignId}/`

### Products Collection (`products/`)
```json
{
  "id": "string (auto-generated document ID)",
  "name": "string",
  "description": "string (optional)",
  "campaignId": "string (reference to campaign document)",
  "price": "number",
  "targetAmount": "number (target sales quantity)",
  "currentSoldAmount": "number (current sales quantity)",
  "imageUrl": "string (Firebase Storage URL, optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**Notes:**
- Products are associated with campaigns through `campaignId`
- Progress is calculated as `(currentSoldAmount / targetAmount) * 100`
- Product images are stored in Firebase Storage under `products/{productId}/`

### Product Change Logs Collection (`productChangeLogs/`)
```json
{
  "id": "string (auto-generated document ID)",
  "productId": "string (reference to product document)",
  "userId": "string (reference to user document)",
  "userName": "string (cached for performance)",
  "previousAmount": "number",
  "newAmount": "number",
  "changeType": "string (e.g., 'manual_update', 'correction')",
  "notes": "string (optional)",
  "timestamp": "timestamp"
}
```

**Notes:**
- Maintains complete audit trail of all product changes
- User name is cached to avoid additional lookups
- Supports different change types for categorization

## Offline Support

The app uses Firebase Firestore's built-in offline persistence:
- Firebase Firestore provides automatic offline caching
- Data is temporarily cached when offline and synced when connection is restored
- The app requires an initial internet connection to authenticate with Firebase

## Security Rules

For production, update your Firestore security rules to ensure proper access control:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    
    // Campaigns are readable by all authenticated users
    // Write access should be restricted to admin users
    match /campaigns/{campaignId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; 
      // TODO: Add admin role check for write operations
    }
    
    // Products are readable and writable by authenticated users
    match /products/{productId} {
      allow read, write: if request.auth != null;
    }
    
    // Product change logs are readable by authenticated users
    // Write access for creating new logs only
    match /productChangeLogs/{logId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if false; // Immutable audit logs
    }
  }
}
```

### Firebase Storage Security Rules

For file uploads (images), configure Storage security rules:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User avatar uploads
    match /users/{userId}/{allPaths=**} {
      allow read: if true; // Public read for user avatars
      allow write: if request.auth != null;
    }
    
    // Product images
    match /products/{productId}/{allPaths=**} {
      allow read: if true; // Public read for product images
      allow write: if request.auth != null;
    }
    
    // Campaign images
    match /campaigns/{campaignId}/{allPaths=**} {
      allow read: if true; // Public read for campaign images
      allow write: if request.auth != null;
    }
  }
}
```

## Testing

**Important**: The app requires Firebase to be properly configured and connected to function. Ensure you have completed all setup steps before running the app.

## Troubleshooting

### Common Setup Issues

1. **Firebase not initialized**: 
   - Check that `firebase_options.dart` exists and is properly configured
   - Verify the Firebase project ID matches your console project
   - Ensure `flutterfire configure` was run successfully

2. **Permission denied errors**: 
   - Verify Firestore security rules allow public access for testing
   - Check that Firebase Authentication is properly configured
   - Ensure the app has proper network permissions

3. **Network connectivity issues**: 
   - Ensure stable internet connection for initial Firebase setup
   - Check that Firebase services are not blocked by firewall
   - Verify the device/emulator has internet access

4. **App crashes on startup**: 
   - Check Firebase configuration files are present
   - Verify all required Firebase services are enabled
   - Check console logs for specific Firebase initialization errors

5. **Build or dependency issues**:
   - Run `flutter clean && flutter pub get`
   - Ensure Flutter and Firebase CLI are up to date
   - Check for conflicting dependencies in `pubspec.yaml`

### Performance Optimization

1. **Enable Firestore Offline Persistence**:
   ```dart
   FirebaseFirestore.instance.settings = const Settings(
     persistenceEnabled: true,
     cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
   );
   ```

2. **Optimize Firestore Queries**:
   - Use indexes for compound queries
   - Limit query results with `.limit()`
   - Use pagination for large datasets

3. **Image Upload Optimization**:
   - Compress images before upload
   - Use appropriate image formats (JPEG for photos, PNG for graphics)
   - Implement progress indicators for uploads

### Monitoring and Debugging

1. **Firebase Console Monitoring**:
   - Monitor Firestore usage and quotas
   - Check Storage usage and bandwidth
   - Review Authentication logs

2. **Client-Side Debugging**:
   - Enable Firebase debugging in development
   - Use Flutter Inspector for widget debugging
   - Monitor network requests in dev tools

3. **Error Reporting**:
   - Consider adding Firebase Crashlytics for production
   - Implement proper error handling and user feedback
   - Log important events for debugging

## Dependencies Added

The following Firebase packages are required in `pubspec.yaml`:

- `firebase_core: ^3.1.0` - Core Firebase functionality
- `cloud_firestore: ^5.0.1` - Firestore database
- `firebase_auth: ^5.1.0` - Authentication (optional)
- `firebase_storage: ^12.0.1` - File storage (optional)
