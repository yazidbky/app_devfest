import 'package:app_devfest/api/register/registre_json.dart';
import 'package:app_devfest/components/base_url.dart';
import 'package:app_devfest/local%20storage/save_userID.dart';
import 'package:dio/dio.dart';

class RegistreApiService {
  static const String registerUrl = '$baseUrl/api/auth/register';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    User user = User(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );

    final Map<String, dynamic> body = user.toMap();

    try {
      final response = await _dio.post(
        registerUrl,
        data: body, // No need for json.encode with Dio
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');
      final String userId = response.data['user']['_id'];
      print('User ID: $userId');
      saveUserId(userId);
      if (response.statusCode == 201) {
        User registeredUser = User.fromJson(response.data['user']);
        return {
          "success": true,
          "message": "User registered successfully",
          "user": registeredUser
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("Error 400: ${e.response?.data}");
        return {
          "success": false,
          "error": e.response?.data["error"] ?? "Email already in use"
        };
      } else if (e.response?.statusCode == 500) {
        return {
          "success": false,
          "error": "Server error, please try again later."
        };
      } else {
        return {
          "success": false,
          "error": e.response?.data["error"] ?? "An error occurred"
        };
      }
    } catch (e) {
      print("Unexpected error: $e");
      return {"success": false, "error": "Failed to connect to the server."};
    }

    return {"success": false, "error": "Something went wrong"};
  }
}
