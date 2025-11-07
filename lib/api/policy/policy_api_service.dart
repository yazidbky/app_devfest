import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class PolicyApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> createPolicy({
    required String type,
    required String startDate,
    required String endDate,
    required String user,
    required String vehicle,
    required int price,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/policy/create',
        data: {
          'type': type,
          'startDate': startDate,
          'endDate': endDate,
          'user': user,
          'vehicle': vehicle,
          'price': price,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Raw policy creation response: ${response.data}');
      String? policyId;
      if (response.data is Map && response.data['policy'] is Map) {
        policyId = response.data['policy']['_id']?.toString();
      }

      if (policyId != null) {
        return {
          'success': true,
          'policyId': policyId,
          'message': 'Policy created successfully'
        };
      }

      // Validate response structure
      if (response.data is! Map<String, dynamic>) {
        return {
          'success': false,
          'error': 'Invalid response format from server'
        };
      }

      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 201) {
        // Validate successful response
        if (responseData.containsKey('_id') && responseData['_id'] is String) {
          return {
            'success': true,
            'policyId': responseData['_id'],
            'message': responseData['message']?.toString() ?? 'Policy created'
          };
        }
        return {'success': false, 'error': 'Missing policy ID in response'};
      }

      // Handle error responses
      return {
        'success': false,
        'error': _parseError(responseData),
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': _parseDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: ${e.toString()}',
      };
    }
  }

  String _parseError(Map<String, dynamic> response) {
    try {
      if (response['error'] is String) return response['error'];
      if (response['message'] is String) return response['message'];
      if (response['errors'] is List) return response['errors'].join(', ');
      return 'Unknown server error';
    } catch (_) {
      return 'Invalid error format';
    }
  }

  String _parseDioError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      return _parseError(e.response!.data!);
    }
    return e.message ?? 'Network request failed';
  }
}
