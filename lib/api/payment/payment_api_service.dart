import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class PaymentApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> initiatePayment(String policyId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/payment/policy/$policyId/pay',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Payment API raw response: ${response.data}');

      // Directly check for checkout_url in response
      final checkoutUrl = response.data['checkout_url']?.toString();

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        return {'success': true, 'checkout_url': checkoutUrl};
      }

      return {
        'success': false,
        'error': response.data['message']?.toString() ?? 'Payment failed'
      };
    } on DioException catch (e) {
      print('Payment error: ${e.response?.data}');
      return {
        'success': false,
        'error': e.response?.data['message']?.toString() ?? 'Payment failed'
      };
    } catch (e) {
      return {'success': false, 'error': 'Unexpected error'};
    }
  }
}
