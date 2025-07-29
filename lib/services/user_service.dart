import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import 'firebase_service.dart';

class UserService {
  static String? _currentUserId;
  static const String _userDataKey = 'user_data';
  static const String _userIdKey = 'current_user_id';

  // Save user data to local storage
  static Future<void> _saveUserLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(user.toJson());
      await prefs.setString(_userDataKey, userData);
      if (user.id != null) {
        await prefs.setString(_userIdKey, user.id!);
        _currentUserId = user.id;
      }
      print('User data saved locally for user: ${user.id}');
    } catch (e) {
      print('Error saving user data locally: $e');
    }
  }

  // Load user data from local storage
  static Future<User?> _loadUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      final userId = prefs.getString(_userIdKey);

      if (userData != null && userId != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        _currentUserId = userId;
        return User.fromJson(userMap);
      }
    } catch (e) {
      print('Error loading user data locally: $e');
    }
    return null;
  }

  // Clear local user data
  static Future<void> _clearUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_userIdKey);
      _currentUserId = null;
      print('User data cleared locally');
    } catch (e) {
      print('Error clearing user data locally: $e');
    }
  }

  // Check if user is registered (now checks local storage first)
  static Future<bool> isUserRegistered() async {
    // First try to load from local storage
    final localUser = await _loadUserLocally();
    if (localUser != null) {
      return true;
    }

    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      if (_currentUserId != null) {
        final doc = await FirebaseService.usersCollection
            .doc(_currentUserId!)
            .get();
        return doc.exists;
      }
      return false;
    } catch (e) {
      print('Error checking user registration: $e');
      throw Exception('Failed to check user registration in Firebase: $e');
    }
  }

  static Future<User?> findExistingUser(User user) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final userId = user.generateUserId();

      // First, try to find by the generated user ID (NIC or normalized name)
      final doc = await FirebaseService.usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return User.fromFirestore(data, doc.id);
      }

      // If not found by ID, search by normalized full name and NIC combination
      if (user.nic != null && user.nic!.isNotEmpty) {
        final querySnapshot = await FirebaseService.usersCollection
            .where('nic', isEqualTo: user.nic)
            .where('normalizedFullName', isEqualTo: user.normalizedFullName)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          return User.fromFirestore(data, doc.id);
        }
      } else {
        // If no NIC, search by normalized full name only
        final querySnapshot = await FirebaseService.usersCollection
            .where('normalizedFullName', isEqualTo: user.normalizedFullName)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          return User.fromFirestore(data, doc.id);
        }
      }

      return null;
    } catch (e) {
      print('Error finding existing user: $e');
      return null;
    }
  }

  // Check if user exists by NIC
  static Future<User?> getUserByNic(String nic) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      // First try to get by document ID (if NIC is used as ID)
      final doc = await FirebaseService.usersCollection.doc(nic).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return User.fromFirestore(data, doc.id);
      }

      // If not found by ID, query by NIC field
      final querySnapshot = await FirebaseService.usersCollection
          .where('nic', isEqualTo: nic)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        return User.fromFirestore(data, doc.id);
      }

      return null;
    } catch (e) {
      print('Error getting user by NIC: $e');
      return null;
    }
  }

  // Save user registration data
  static Future<User> saveUser(User user) async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      // Check if user already exists
      final existingUser = await findExistingUser(user);
      if (existingUser != null) {
        // Update the existing user's information if needed
        final updatedUser = existingUser.copyWith(
          fullName: user.fullName,
          nic: user.nic ?? existingUser.nic,
          avatarUrl: user.avatarUrl ?? existingUser.avatarUrl,
        );

        final userId = updatedUser.generateUserId();
        _currentUserId = userId;

        final userData = {
          'id': userId,
          'fullName': updatedUser.fullName,
          'normalizedFullName': updatedUser.normalizedFullName,
          'nic': updatedUser.nic,
          'avatarUrl': updatedUser.avatarUrl,
          'createdAt': existingUser.createdAt ?? FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await FirebaseService.usersCollection.doc(userId).set(userData);
        print('Updated existing user: $userId');

        // Save to local storage
        final finalUpdatedUser = updatedUser.copyWith(id: userId);
        await _saveUserLocally(finalUpdatedUser);

        return finalUpdatedUser;
      }

      // Create new user
      final userId = user.generateUserId();
      _currentUserId = userId;

      final userData = {
        'id': userId,
        'fullName': user.fullName,
        'normalizedFullName': user.normalizedFullName,
        'nic': user.nic,
        'avatarUrl': user.avatarUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseService.usersCollection.doc(userId).set(userData);
      print('Created new user: $userId');

      // Save to local storage
      final finalUser = user.copyWith(id: userId);
      await _saveUserLocally(finalUser);

      return finalUser;
    } catch (e) {
      print('Error saving user to Firebase: $e');
      throw Exception('Failed to save user to Firebase: $e');
    }
  }

  // Get registered user data (now checks local storage first)
  static Future<User?> getUser() async {
    // First try to load from local storage
    final localUser = await _loadUserLocally();
    if (localUser != null) {
      return localUser;
    }

    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      if (_currentUserId != null) {
        final doc = await FirebaseService.usersCollection
            .doc(_currentUserId!)
            .get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final user = User.fromFirestore(data, doc.id);
          // Save to local storage for future use
          await _saveUserLocally(user);
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      throw Exception('Failed to get user from Firebase: $e');
    }
  }

  // Clear user data (for testing/logout)
  static Future<void> clearUser() async {
    // Clear local storage
    await _clearUserLocally();

    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      if (_currentUserId != null) {
        await FirebaseService.usersCollection.doc(_currentUserId!).delete();
        _currentUserId = null;
      }
    } catch (e) {
      print('Error clearing user: $e');
      throw Exception('Failed to clear user from Firebase: $e');
    }
  }

  // Logout user (clears local data but keeps Firebase data)
  static Future<void> logout() async {
    await _clearUserLocally();
  }

  // Get all registered users (admin function)
  static Future<List<User>> getAllUsers() async {
    if (!FirebaseService.isInitialized) {
      throw Exception(
        'Firebase is not initialized. Please check your Firebase configuration.',
      );
    }

    try {
      final snapshot = await FirebaseService.usersCollection
          .orderBy('createdAt', descending: true)
          .get();

      final users = <User>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        users.add(User.fromFirestore(data, doc.id));
      }

      print('Retrieved ${users.length} users from Firebase');
      return users;
    } catch (e) {
      print('Error getting all users: $e');
      throw Exception('Failed to get users from Firebase: $e');
    }
  }

  // Set current user ID (for login scenarios)
  static void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  // Get current user ID
  static String? getCurrentUserId() {
    return _currentUserId;
  }
}
