import 'package:flutter/material.dart';
import 'models/user.dart';
import 'screens/pin_entry_screen.dart';
import 'screens/products_screen.dart';
import 'screens/user_registration_screen.dart';
import 'screens/campaign_screen.dart';
import 'services/user_service.dart';
import 'services/firebase_service.dart';
import 'services/campaign_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseService.initialize();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Exit the app if Firebase fails to initialize
    throw Exception(
      'Firebase is required for this app to run. Please check your Firebase configuration.',
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const AppHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  bool _isLoading = true;
  bool _isUserRegistered = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkUserRegistration();
  }

  Future<void> _checkUserRegistration() async {
    try {
      final isRegistered = await UserService.isUserRegistered();
      if (isRegistered) {
        final user = await UserService.getUser();
        setState(() {
          _isUserRegistered = true;
          _user = user;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isUserRegistered = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUserRegistered = false;
        _isLoading = false;
      });
    }
  }

  void _onRegistrationComplete() {
    _checkUserRegistration();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isUserRegistered || _user == null) {
      return UserRegistrationScreen(
        onRegistrationComplete: _onRegistrationComplete,
      );
    }

    return PinEntryScreen(
      user: _user!,
      onPinComplete: (pin) async {
        print('PIN entered: $pin');

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        try {
          if (pin == '547698') {
            Navigator.of(context).pop(); // Close loading dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const CampaignScreen()),
            );
          } else {
            var campaigns = await CampaignService.getCampainbyPin(pin);
            Navigator.of(context).pop(); // Close loading dialog

            if (campaigns.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No campaigns found for this PIN'),
                  backgroundColor: Colors.red,
                ),
              );
              // Reset the PIN entry screen instead of navigating
              return;
            } else {
              // Use the first campaign found for the PIN
              final campaign = campaigns.first;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsScreen(user: _user!, campaign: campaign),
                ),
              );
            }
          }
        } catch (e) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      },
    );
  }
}
