import 'package:app_devfest/api/login/login_api_service.dart';

class FakeLoginApiService extends LoginApiService {
  @override
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Static mock logic
    if (email == 'yazid@gmail.com' && password == '123456') {
      return {
        "success": true,
        "message": "Logged in successfully",
        "accessToken": "mock_token_12345",
      };
    } else {
      return {
        "success": false,
        "error": "Invalid email or password",
      };
    }
  }
}
