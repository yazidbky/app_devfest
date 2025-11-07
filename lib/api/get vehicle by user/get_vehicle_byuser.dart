import 'package:app_devfest/api/vehicle/vehicle_json.dart';
import 'package:app_devfest/components/base_url.dart';
import 'package:app_devfest/local%20storage/save_vehicleId.dart';
import 'package:dio/dio.dart';

class GetVehicleByUser {
  static String getUserVehiclesUrl(String userId) =>
      '$baseUrl/api/vehicle/user/$userId';

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getUserVehicles({
    required String userId,
  }) async {
    try {
      final response = await _dio
          .get(
            getUserVehiclesUrl(userId),
            options: Options(headers: {'Content-Type': 'application/json'}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<Vehicle> vehicles = [];
        List<String> vehicleIds = [];

        // Handle response format - it's a list of vehicles directly
        List<dynamic> vehiclesData = response.data is List ? response.data : [];

        for (var vehicleJson in vehiclesData) {
          try {
            final vehicle = Vehicle.fromJson(vehicleJson);
            vehicles.add(vehicle);

            // Check for _id field instead of id
            final vehicleId = vehicleJson['_id'] ?? vehicleJson['id'];
            if (vehicleId != null && vehicleId.isNotEmpty) {
              vehicleIds.add(vehicleId);
            }
          } catch (e) {
            print('Error parsing vehicle: $e');
          }
        }

        // Save all vehicle IDs to local storage
        if (vehicleIds.isNotEmpty) {
          await VehicleStorage.saveVehicleIds(vehicleIds);
          print('Saved vehicle IDs: $vehicleIds');
        }

        return {
          "success": true,
          "message": "Vehicles fetched successfully",
          "vehicles": vehicles,
          "vehicleIds": vehicleIds,
        };
      } else {
        return {
          "success": false,
          "error": "Server returned status: ${response.statusCode}",
          "vehicles": <Vehicle>[],
          "vehicleIds": <String>[],
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "error":
            e.response?.data['error'] ?? e.message ?? 'Unknown error occurred',
        "vehicles": <Vehicle>[],
        "vehicleIds": <String>[],
      };
    } catch (e) {
      return {
        "success": false,
        "error": e.toString(),
        "vehicles": <Vehicle>[],
        "vehicleIds": <String>[],
      };
    }
  }
}
