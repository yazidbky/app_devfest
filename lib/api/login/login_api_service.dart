import 'dart:convert';
import 'package:app_devfest/api/get%20policy/getpolicy_id_api.dart';
import 'package:app_devfest/api/get%20vehicle%20by%20user/get_vehicle_byuser.dart';
import 'package:app_devfest/local%20storage/save_vehicleId.dart';
import 'package:http/http.dart' as http;
import 'package:app_devfest/components/base_url.dart';
import 'package:app_devfest/local storage/user_storage.dart';
import 'package:app_devfest/local storage/policy_storage.dart';

class LoginApiService {
  static const String loginUrl = '$baseUrl/api/auth/login';

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'pwd': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['roles'][0];

        // Save user data first
        await UserStorage.saveUserData(
          userId: user['_id'],
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );

        // Fetch and save related data
        await _fetchAndStoreUserData(user['_id']); // Fixed the asterisk issue

        return {'success': true, 'message': 'Login successful'};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ??
              'Login failed with status code ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> _fetchAndStoreUserData(String userId) async {
    try {
      // Fetch and save vehicles
      final vehicleService = GetVehicleByUser();
      final vehicleResponse =
          await vehicleService.getUserVehicles(userId: userId);

      if (vehicleResponse['success']) {
        final vehicleIds = vehicleResponse['vehicleIds'] as List<String>;
        if (vehicleIds.isNotEmpty) {
          await VehicleStorage.saveVehicleIds(vehicleIds);
          await VehicleStorage.saveActiveVehicleId(vehicleIds.first);
          print('Saved ${vehicleIds.length} vehicle IDs: $vehicleIds');
        }
      } else {
        print('Failed to fetch vehicles: ${vehicleResponse['error']}');
      }

      // Fetch and save policies
      final policyService = GetPolicyById();
      final policyResponse = await policyService.getPolicy(userId: userId);

      if (policyResponse['success']) {
        final policy = policyResponse['policy'];
        if (policy != null) {
          // Extract policy ID from the policy object
          final policyId =
              policy.id ?? policy.policyId; // Adjust based on your Policy model
          if (policyId != null) {
            await PolicyStorage.savePolicyIds([policyId]);
            await PolicyStorage.saveActivePolicyId(policyId);
            print('Saved policy ID: $policyId');
          }
        }
      } else {
        print('Failed to fetch policy: ${policyResponse['error']}');
      }
    } catch (e) {
      print('Error fetching and storing user data: $e');
    }
  }
}
