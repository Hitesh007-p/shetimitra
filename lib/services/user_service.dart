import 'package:shared_preferences/shared_preferences.dart';
import 'package:shetimitra/models/user.dart';
import 'dart:convert';

class UserService {
  static const String _userKey = 'user_profile';

  // Save user profile
  static Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  // Get user profile
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  // Check if user exists
  static Future<bool> userExists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_userKey);
    } catch (e) {
      print('Error checking user: $e');
      return false;
    }
  }

  // Update user profile
  static Future<void> updateUser(User user) async {
    await saveUser(user);
  }

  // Clear user profile
  static Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error clearing user: $e');
    }
  }
}
