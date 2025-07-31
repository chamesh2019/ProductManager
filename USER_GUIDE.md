# ProductManager User Guide

A comprehensive guide for using the ProductManager application to track sales and manage product campaigns.

## Table of Contents

1. [Getting Started](#getting-started)
2. [User Registration](#user-registration)
3. [PIN-Based Access](#pin-based-access)
4. [Campaign Interface](#campaign-interface)
5. [Product Management](#product-management)
6. [Sales Tracking](#sales-tracking)
7. [Admin Features](#admin-features)
8. [Troubleshooting](#troubleshooting)

## Getting Started

### First Launch

When you first open the ProductManager app, you'll be guided through a simple setup process:

1. **Welcome Screen**: The app will check if you're already registered
2. **Registration Required**: If this is your first time, you'll see the registration screen
3. **Internet Connection**: Ensure you have an active internet connection for setup

### System Requirements

- Android device running Android 5.0+ or iOS device running iOS 12.0+
- Active internet connection (for initial setup and data sync)
- Camera/Gallery access (optional, for profile pictures)
- Approximately 50MB of free storage space

## User Registration

### Step-by-Step Registration

1. **Enter Full Name**
   - Type your complete name as it appears on official documents
   - This will be used to identify you in the system
   - Example: "John Michael Smith"

2. **Enter NIC (Optional)**
   - Provide your National Identity Card number
   - This serves as a unique identifier
   - If not provided, a normalized version of your name will be used
   - Example: "123456789V" or "199812345678"

3. **Add Profile Picture (Optional)**
   - Tap the camera icon to add a profile picture
   - Choose "Select from Gallery" to pick an existing photo
   - The image will be automatically resized and uploaded
   - You can skip this step and add a picture later

4. **Complete Registration**
   - Tap "Register" to create your account
   - Wait for confirmation that your account has been created
   - Your information is securely stored both locally and in the cloud

### Registration Tips

- **Name Format**: Use your full legal name for consistency
- **NIC Verification**: Double-check your NIC number for accuracy
- **Profile Picture**: Choose a clear, professional photo if possible
- **Network**: Ensure stable internet during registration

## PIN-Based Access

### Understanding the PIN System

The ProductManager uses a PIN-based system to control access to different campaigns:

- **Campaign PINs**: Each campaign has a unique 6-digit PIN
- **Admin PIN**: Special PIN (547698) provides full administrative access
- **Security**: PINs ensure users only access authorized campaigns

### Entering Your PIN

1. **PIN Entry Screen**
   - You'll see a numeric keypad after registration
   - Enter your 6-digit campaign PIN
   - The PIN display will show dots as you type

2. **PIN Validation**
   - Tap "Submit" or the checkmark button
   - The system will verify your PIN
   - Valid PINs redirect to the appropriate campaign
   - Invalid PINs show an error message

3. **PIN Types**
   - **Campaign PIN**: Access to specific campaign products
   - **Admin PIN (547698)**: Full system access and management
   - **Error Handling**: Clear messages for invalid or expired PINs

### Common PIN Issues

- **Wrong PIN**: Double-check the PIN with your supervisor
- **No Access**: Ensure the campaign is still active
- **Network Error**: Check your internet connection
- **Forgotten PIN**: Contact your administrator for assistance

## Campaign Interface

### Campaign Overview

Once you enter a valid campaign PIN, you'll see:

1. **Campaign Header**
   - Campaign name and description
   - Date range (start and end dates)
   - Active status indicator

2. **Product Grid**
   - Visual cards for each product in the campaign
   - Progress indicators showing sales vs. targets
   - Quick-access buttons for updates

3. **Navigation Options**
   - Menu button for additional features
   - Change log access
   - User profile options

### Understanding Campaign Status

- **Active Campaigns**: Green indicator, accepting sales updates
- **Inactive Campaigns**: Red indicator, read-only access
- **Expired Campaigns**: Gray indicator, historical data only

## Product Management

### Product Cards

Each product is displayed as a card containing:

1. **Product Image**: Visual representation of the product
2. **Product Name**: Clear product identification
3. **Price Information**: Unit price in local currency
4. **Sales Progress**: 
   - Current sold amount
   - Target amount
   - Percentage completion
   - Visual progress bar

### Reading Product Information

- **Green Progress**: Sales meeting or exceeding targets
- **Yellow Progress**: Sales approaching targets (70-99%)
- **Red Progress**: Sales below target expectations (<70%)
- **Price Display**: Formatted in local currency
- **Stock Status**: Visual indicators for inventory levels

### Product Categories

Products may be organized by:
- Product type or category
- Launch date or campaign phase
- Target demographic
- Price range or tier

## Sales Tracking

### Updating Sales Figures

1. **Select Product**
   - Tap on any product card
   - This opens the sales update dialog

2. **Review Current Data**
   - Current sold amount is displayed
   - Target amount shown for reference
   - Previous sales figures visible

3. **Enter New Amount**
   - Type the updated total sold amount
   - NOT the additional sales (enter total, not increment)
   - Example: If you had 50 sold and sold 10 more, enter 60

4. **Validate and Submit**
   - Check your entry is correct
   - Tap "Update" to save changes
   - Wait for confirmation message

### Sales Update Best Practices

- **Accuracy**: Double-check figures before submitting
- **Timeliness**: Update sales regularly (daily recommended)
- **Complete Totals**: Always enter the total sold amount, not increments
- **Verification**: Confirm updates are reflected in the progress bars

### Change Tracking

Every sales update is automatically logged with:
- Timestamp of the change
- User who made the change
- Previous and new values
- Reason for change (if applicable)

### Sales Analytics

The system provides immediate feedback:
- **Progress Visualization**: Percentage completion bars
- **Target Comparison**: How close you are to targets
- **Trend Analysis**: Performance over time
- **Achievement Indicators**: Visual confirmation of milestones

## Admin Features

### Admin Access (PIN: 547698)

Administrators have additional capabilities:

1. **Campaign Management**
   - View all campaigns
   - Create new campaigns
   - Modify existing campaigns
   - Activate/deactivate campaigns

2. **Product Management**
   - Add products to campaigns
   - Update product information
   - Set targets and pricing
   - Upload product images

3. **User Management**
   - View all registered users
   - Monitor user activity
   - Access change logs
   - Generate reports

### Creating Campaigns

1. **Campaign Details**
   - Enter campaign title and description
   - Set start and end dates
   - Assign budget (optional)
   - Generate unique PIN

2. **Campaign Configuration**
   - Choose active status
   - Upload campaign image
   - Set access permissions
   - Define success metrics

### Managing Products

1. **Product Creation**
   - Enter product name and description
   - Set pricing and target amounts
   - Upload product images
   - Assign to campaigns

2. **Product Updates**
   - Modify product details
   - Adjust targets and pricing
   - Update images and descriptions
   - Track performance metrics

## Troubleshooting

### Common Issues and Solutions

#### Login and Access Issues

**Problem**: Can't access the app after registration
- **Solution**: Check internet connection and try restarting the app
- **Check**: Verify Firebase services are operational

**Problem**: PIN not working
- **Solution**: Verify PIN with your supervisor
- **Check**: Ensure campaign is still active
- **Try**: Admin PIN (547698) to check system status

#### Data and Sync Issues

**Problem**: Changes not saving
- **Solution**: Check internet connection
- **Wait**: Allow time for offline data to sync
- **Retry**: Attempt the update again after connectivity is restored

**Problem**: Old data showing
- **Solution**: Pull down on the screen to refresh
- **Check**: Verify you're viewing the correct campaign
- **Wait**: Allow time for cloud synchronization

#### Image and Media Issues

**Problem**: Cannot upload profile picture
- **Solution**: Check device permissions for camera/gallery access
- **Try**: Restart the app and try again
- **Check**: Ensure sufficient device storage space

**Problem**: Product images not loading
- **Solution**: Check internet connection
- **Wait**: Images may take time to load on slow connections
- **Clear**: Try clearing app cache if available

#### Performance Issues

**Problem**: App running slowly
- **Solution**: Close other apps to free memory
- **Restart**: Close and reopen the ProductManager app
- **Update**: Ensure you have the latest app version

**Problem**: App crashes or freezes
- **Solution**: Force close and restart the app
- **Clear**: Clear app cache and data if needed
- **Report**: Contact your administrator with error details

### Getting Additional Help

If you continue experiencing issues:

1. **Contact Administrator**: Reach out to your campaign manager
2. **Document Issues**: Note exact error messages and steps to reproduce
3. **Check Network**: Verify stable internet connection
4. **Update App**: Ensure you're using the latest version

### Emergency Procedures

If the app is completely inaccessible:

1. **Document offline**: Keep manual records of sales
2. **Contact support**: Reach out to technical support immediately
3. **Alternative access**: Try accessing via admin PIN if authorized
4. **Data recovery**: Admin can help recover and input offline data

---

**Remember**: This app is designed to be simple and intuitive. Most tasks should be straightforward, but don't hesitate to ask for help when needed. Your accurate and timely sales reporting is crucial for campaign success.