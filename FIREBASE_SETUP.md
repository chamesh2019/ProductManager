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

The app uses the following Firestore collections:

- `users` - User registration data
- `campaigns` - Campaign information
- `products` - Product data associated with campaigns

## Data Structure

### Users Collection
```json
{
  "id": "string",
  "fullName": "string",
  "avatarUrl": "string (optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Campaigns Collection
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "isActive": "boolean",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Products Collection
```json
{
  "id": "string",
  "campaignId": "string",
  "name": "string",
  "description": "string",
  "price": "number",
  "targetAmount": "number",
  "currentSoldAmount": "number",
  "imageUrl": "string (optional)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Offline Support

The app uses Firebase Firestore's built-in offline persistence:
- Firebase Firestore provides automatic offline caching
- Data is temporarily cached when offline and synced when connection is restored
- The app requires an initial internet connection to authenticate with Firebase

## Security Rules

For production, update your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Campaigns are readable by all authenticated users
    match /campaigns/{campaignId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Add admin check here
    }
    
    // Products are readable by all authenticated users
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Add admin check here
    }
  }
}
```

## Testing

**Important**: The app requires Firebase to be properly configured and connected to function. Ensure you have completed all setup steps before running the app.

## Troubleshooting

1. **Firebase not initialized**: Check that `firebase_options.dart` is properly configured
2. **Permission denied**: Verify Firestore security rules allow public access for testing
3. **Network issues**: Ensure you have an internet connection for initial Firebase setup
4. **App crashes on startup**: Verify Firebase configuration is correct

## Dependencies Added

The following Firebase packages are required in `pubspec.yaml`:

- `firebase_core: ^3.1.0` - Core Firebase functionality
- `cloud_firestore: ^5.0.1` - Firestore database
- `firebase_auth: ^5.1.0` - Authentication (optional)
- `firebase_storage: ^12.0.1` - File storage (optional)
