# ProductManager

A comprehensive Flutter application for managing product campaigns and tracking sales performance. This application was designed for companies to efficiently track sales of their product campaigns with real-time data synchronization and detailed analytics.

## 📱 Application Overview

ProductManager is a mobile-first sales tracking system that enables companies to:

- **Manage Product Campaigns**: Create and monitor marketing campaigns with specific date ranges, budgets, and target goals
- **Track Sales Performance**: Real-time tracking of product sales against target amounts with visual progress indicators
- **User Management**: Secure user registration with NIC (National Identity Card) integration and profile management
- **PIN-based Access Control**: Role-based access to different campaigns using secure PIN authentication
- **Offline Support**: Continue working offline with automatic data synchronization when connection is restored
- **Audit Trail**: Complete change logging for all sales updates and modifications

## 🚀 Key Features

### Campaign Management
- Create campaigns with title, description, date ranges, and budget allocation
- Visual campaign cards with status indicators (active/inactive)
- PIN-based campaign access for security and organization
- Campaign-specific product grouping

### Product Sales Tracking
- Individual product cards with images, pricing, and sales progress
- Target vs. actual sales comparison with percentage completion
- Quick sales update interface with validation
- Visual progress indicators for immediate status understanding

### User System
- User registration with full name and NIC verification
- Optional avatar upload for personalization  
- Persistent user sessions with local storage
- User-specific change tracking

### Security & Access Control
- PIN-based authentication for campaign access
- Admin PIN (547698) for full system access
- User data encryption and secure storage
- Firebase authentication integration

### Data Management
- Real-time Firebase Firestore integration
- Automatic offline data caching
- Cross-device data synchronization
- Comprehensive change logging with timestamps

## 🏗️ Technical Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **State Management**: StatefulWidget with local state
- **Local Storage**: SharedPreferences
- **Image Management**: Image picker with Firebase Storage
- **UI Components**: Material Design 3

## 📋 Prerequisites

Before running this application, ensure you have:

1. **Flutter SDK** (3.8.1 or higher)
2. **Firebase Account** and project setup
3. **Android Studio** or **VS Code** with Flutter extensions
4. **Physical device** or **emulator** for testing

## ⚙️ Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/chamesh2019/ProductManager.git
cd ProductManager
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration
⚠️ **Important**: This application requires Firebase to function. Please follow the detailed setup guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

Quick setup:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

### 4. Run the Application
```bash
flutter run
```

## 📖 User Guide

### First Time Setup
1. **User Registration**: Enter your full name and NIC (optional) when first opening the app
2. **Avatar Upload**: Optionally upload a profile picture from your gallery
3. **Account Creation**: Your account will be created and stored locally and in Firebase

### Daily Usage Workflow

#### Accessing Campaigns
1. **PIN Entry**: Enter your campaign-specific PIN on the PIN pad interface
2. **Campaign Access**: Valid PINs will take you to the respective campaign's products
3. **Admin Access**: Use PIN `547698` for full administrative access

#### Updating Sales Data
1. **Product Selection**: Tap on any product card to update its sales figures
2. **Sales Input**: Enter the new sold amount in the update dialog
3. **Validation**: The system validates the input and updates progress indicators
4. **Change Logging**: All changes are automatically logged with user and timestamp

#### Managing Campaigns (Admin)
1. **Campaign Creation**: Use the admin interface to create new campaigns
2. **Product Management**: Add products to campaigns with targets and pricing
3. **User Monitoring**: View all registered users and their activity

## 👥 User Roles & Permissions

### Regular Users (Campaign-specific PIN)
- Access to assigned campaign products only
- Update sales figures for products in their campaign
- View product progress and campaign information
- Cannot create or modify campaigns

### Administrators (PIN: 547698)
- Full access to all campaigns and products
- Create and modify campaigns
- Add and remove products
- View all user activity and change logs
- Access user management features

## 🔧 Configuration

### Environment Settings
The application behavior can be customized through:

- **Firebase Configuration**: Update `firebase_options.dart` for different environments
- **PIN Configuration**: Campaign PINs are stored in Firebase and can be updated through the admin interface
- **UI Customization**: Theme and branding can be modified in `main.dart`

### Company-Specific Customizations

This application includes several customizations for the target company:

1. **NIC Integration**: Supports Sri Lankan National Identity Card format
2. **Currency Display**: Configured for local currency formatting
3. **Date Formats**: Uses company-preferred date/time display
4. **Branding**: Custom color scheme and company-specific styling

## 📊 Data Models

### User
- ID (generated from NIC or normalized name)
- Full Name
- NIC (National Identity Card)
- Avatar URL
- Creation timestamp

### Campaign
- Unique ID
- Title and description
- Start and end dates
- Active status
- Budget allocation
- Associated PIN
- Image URL

### Product
- Unique ID
- Name and description
- Campaign association
- Price per unit
- Target sales amount
- Current sold amount
- Product image URL

### Change Log
- Timestamp
- User ID
- Product ID
- Previous and new values
- Change type and description

## 🔍 Monitoring & Analytics

The application provides several monitoring capabilities:

- **Sales Progress**: Real-time progress tracking against targets
- **User Activity**: Complete audit trail of all user actions
- **Campaign Performance**: Overview of campaign success metrics
- **Change History**: Detailed logs of all data modifications

## 🐛 Troubleshooting

### Common Issues

**App won't start / Firebase errors**
- Verify Firebase configuration is complete
- Check internet connectivity for initial setup
- Ensure Firestore security rules allow access

**PIN not working**
- Verify PIN is correctly associated with a campaign in Firebase
- Check campaign is marked as active
- Try admin PIN (547698) to access campaign management

**Data not syncing**
- Check internet connectivity
- Verify Firebase Firestore rules
- Check Firebase project quotas and billing

**Image upload failures**
- Verify Firebase Storage configuration
- Check device permissions for camera/gallery access
- Ensure sufficient device storage space

### Getting Help

For technical support or questions:
1. Check the troubleshooting section in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
2. Review Firebase Console for any service issues
3. Check Flutter and Firebase documentation for updates

## 📚 Additional Documentation

- [Firebase Setup Guide](FIREBASE_SETUP.md) - Detailed Firebase configuration instructions
- [User Guide](USER_GUIDE.md) - Comprehensive end-user instructions
- [Developer Guide](DEVELOPER_GUIDE.md) - Technical implementation details
- [Architecture Overview](ARCHITECTURE.md) - System design and data flow

## 🔄 Version History

- **v1.0.6** - Current stable release with comprehensive campaign and product management
- Enhanced user interface and Firebase integration
- Improved offline support and data synchronization
- Added comprehensive change logging

## 📄 License

This project is proprietary software developed for specific company use. All rights reserved.

---

**Note**: This application requires active Firebase configuration and internet connectivity for full functionality. Please ensure proper setup before deployment.
