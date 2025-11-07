import 'package:app_devfest/api/get%20policy/gte_policy_id_json.dart';
import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class GetPolicyById {
  static String getPolicyUrl(String userId) =>
      '$baseUrl/api/policy/get/$userId';

  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getPolicy({
    required String userId,
  }) async {
    try {
      final response = await _dio
          .get(
            getPolicyUrl(userId),
            options: Options(headers: {'Content-Type': 'application/json'}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          // Extract policy data from response
          final policyData = response.data['policy'];
          final policy = Policy.fromJson(policyData);

          return {
            "success": true,
            "message": "Policy fetched successfully",
            "policy": policy,
          };
        } catch (e) {
          print('Error parsing policy: $e');
          return {
            "success": false,
            "error": "Failed to parse policy data",
            "policy": null,
          };
        }
      } else if (response.statusCode == 404) {
        return {
          "success": false,
          "error": "Policy not found",
          "policy": null,
        };
      } else {
        return {
          "success": false,
          "error": "Server returned status: ${response.statusCode}",
          "policy": null,
        };
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return {
          "success": false,
          "error": "Policy not found",
          "policy": null,
        };
      }
      return {
        "success": false,
        "error":
            e.response?.data['error'] ?? e.message ?? 'Unknown error occurred',
        "policy": null,
      };
    } catch (e) {
      return {
        "success": false,
        "error": e.toString(),
        "policy": null,
      };
    }
  }
}
