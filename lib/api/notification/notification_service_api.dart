import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class NotificationApiService {
  static const String sendNotificationUrl = '$baseUrl/api/notifications';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> sendNotificationToUser({
    required String userId,
    required String message,
  }) async {
    final Map<String, dynamic> body = {
      'message': message,
    };

    try {
      print('Sending notification to user: $userId'); // Debug log
      print('Notification data: $body'); // Debug log

      final response = await _dio.post(
        '$sendNotificationUrl/$userId',
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500, // Accept 4xx responses
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message":
              response.data['message'] ?? "Notification sent successfully",
          "timestamp": response.data['timestamp'],
          "userId": userId,
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
              ? (e.response?.data["error"] ?? "Invalid notification data")
              : "Invalid notification data"
        };
      } else if (e.response?.statusCode == 404) {
        String errorMsg = "User not connected or not found";
        if (e.response?.data is Map) {
          errorMsg = e.response?.data["error"] ?? errorMsg;
        }
        print("User not found: ${e.response?.data}");
        return {"success": false, "error": errorMsg};
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
