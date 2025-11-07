// policy_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class PolicyStorage {
  static const String _policyIdsKey = 'policy_ids';
  static const String _activePolicyIdKey = 'active_policy_id';

  static Future<void> savePolicyIds(List<String> policyIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_policyIdsKey, policyIds);
  }

  static Future<List<String>> getPolicyIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_policyIdsKey) ?? [];
  }

  static Future<void> saveActivePolicyId(String policyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activePolicyIdKey, policyId);
  }

  static Future<String?> getActivePolicyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activePolicyIdKey);
  }

  static Future<void> clearPolicyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_policyIdsKey);
    await prefs.remove(_activePolicyIdKey);
  }
}
