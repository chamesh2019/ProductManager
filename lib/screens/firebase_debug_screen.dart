import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class FirebaseDebugScreen extends StatefulWidget {
  const FirebaseDebugScreen({super.key});

  @override
  State<FirebaseDebugScreen> createState() => _FirebaseDebugScreenState();
}

class _FirebaseDebugScreenState extends State<FirebaseDebugScreen> {
  String _status = 'Checking Firebase status...';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseStatus();
  }

  Future<void> _checkFirebaseStatus() async {
    try {
      // Check if Firebase is initialized
      final isInitialized = FirebaseService.isInitialized;

      if (!isInitialized) {
        setState(() {
          _status = 'Firebase is not initialized';
        });
        return;
      }

      // Test Firestore connection
      final isConnected = await FirebaseService.testFirestoreConnection();

      setState(() {
        _isConnected = isConnected;
        if (isConnected) {
          _status = 'Firebase and Firestore are working correctly';
        } else {
          _status = '''Firebase initialized but Firestore connection failed.

Possible issues:
1. Firestore database not created in Firebase Console
2. Security rules denying access (check if rules allow public access)
3. Network connectivity issues
4. Project ID mismatch

Current project ID: fproduct-manager-4327

Solutions:
1. Go to Firebase Console → Firestore Database → Create database
2. Set rules to: allow read, write: if true; (for testing)
3. Check your internet connection
4. Verify project configuration''';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking Firebase: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Debug'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_status, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkFirebaseStatus,
                    child: const Text('Recheck Status'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
