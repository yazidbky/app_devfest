// vehicle_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class VehicleStorage {
  static const String _vehicleIdsKey = 'vehicle_ids';
  static const String _activeVehicleIdKey = 'active_vehicle_id';

  static Future<void> saveVehicleIds(List<String> vehicleIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_vehicleIdsKey, vehicleIds);
  }

  static Future<List<String>> getVehicleIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_vehicleIdsKey) ?? [];
  }

  static Future<void> saveActiveVehicleId(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeVehicleIdKey, vehicleId);
  }

  static Future<String?> getActiveVehicleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeVehicleIdKey);
  }

  static Future<void> clearVehicleData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_vehicleIdsKey);
    await prefs.remove(_activeVehicleIdKey);
  }
}
