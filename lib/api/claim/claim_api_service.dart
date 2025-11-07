import 'package:app_devfest/api/claim/claim_json.dart';
import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class ClaimApiService {
  static const String addClaimUrl = '$baseUrl/api/claims/';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> addClaim({
    required String user,
    required String vehicle,
    required String policy,
    required String description,
    required String date,
    required String location,
    required String wilaya,
    required String accidentType,
    required String vehicleStatus,
    required List<String> images,
  }) async {
    Claim claim = Claim(
      user: user,
      vehicle: vehicle,
      policy: policy,
      description: description,
      date: date,
      location: location,
      wilaya: wilaya,
      accidentType: accidentType,
      vehicleStatus: vehicleStatus,
      images: images,
    );

    final Map<String, dynamic> body = claim.toMap();

    try {
      print('Sending claim data: $body'); // Debug log
      final response = await _dio.post(
        addClaimUrl,
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500, // Accept 4xx responses
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          "success": true,
          "message": "Claim submitted successfully",
          "claim": response.data
        };
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");

      if (e.response?.statusCode == 400) {
        print("Bad request: ${e.response?.data}");
        return {
          "success": false,
          "error": e.response?.data is Map
              ? (e.response?.data["error"] ?? "Invalid claim data")
              : "Invalid claim data"
        };
      } else if (e.response?.statusCode == 404) {
        print("API endpoint not found: ${e.response?.data}");
        return {
          "success": false,
          "error":
              "API endpoint not found. Please check the server configuration."
        };
      } else if (e.response?.statusCode == 500) {
        print("Server error: ${e.response?.data}");
        return {
          "success": false,
          "error": "Server error, please try again later."
        };
      } else {
        print("Unexpected error: ${e.response?.data}");
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
