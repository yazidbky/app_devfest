import 'package:app_devfest/api/vehicle/vehicle_json.dart';
import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class VehicleApiService {
  static const String addVehicleUrl = '$baseUrl/api/vehicle/add';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> addVehicle({
    required String owner,
    required String registrationNumber,
    required String model,
    required String brand,
    required String year,
    required String chassisNumber,
    required String driveLicense,
    required String vehicleRegistration,
    required String usageType,
  }) async {
    Vehicle vehicle = Vehicle(
      owner: owner,
      registrationNumber: registrationNumber,
      model: model,
      brand: brand,
      year: year,
      usageType: usageType,
      chassisNumber: chassisNumber,
      driveLicense: driveLicense,
      vehicleRegistration: vehicleRegistration,
      // Now included
    );

    final Map<String, dynamic> body = vehicle.toMap();

    try {
      print('Sending vehicle data: $body'); // Debug log

      final response = await _dio.post(
        addVehicleUrl,
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500, // Accept 4xx responses
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Handle both 200 and 201 as success
        return {
          "success": true,
          "message": "Vehicle added successfully",
          "vehicle": response.data
        };
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");

      if (e.response?.statusCode == 400) {
        return {
          "success": false,
          "error": e.response?.data is Map
              ? (e.response?.data["error"] ?? "Invalid vehicle data")
              : "Invalid vehicle data"
        };
      } else if (e.response?.statusCode == 404) {
        return {
          "success": false,
          "error":
              "API endpoint not found. Please check the server configuration."
        };
      } else if (e.response?.statusCode == 500) {
        return {
          "success": false,
          "error": "Server error, please try again later."
        };
      } else {
        return {
          "success": false,
          "error": e.response?.data is Map
              ? (e.response?.data["error"] ?? "An error occurred")
              : "Connection error: ${e.message}"
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {"success": false, "error": "Failed to connect to the server: $e"};
    }

    return {"success": false, "error": "Something went wrong"};
  }
}
