import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserId() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found in local storage');
    }

    return userId;
  } catch (e) {
    throw Exception('Failed to get user ID: ${e.toString()}');
  }
}

Future<void> saveUserId(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  } catch (e) {
    throw Exception('Failed to save user ID: ${e.toString()}');
  }
}

Future<void> clearUserId() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  } catch (e) {
    throw Exception('Failed to clear user ID: ${e.toString()}');
  }
}
