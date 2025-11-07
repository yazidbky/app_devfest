import 'package:app_devfest/components/base_url.dart';
import 'package:dio/dio.dart';

class InsurancePlan {
  final String title;
  final String insuranceType;
  final int duration;
  final String description;
  final int price;

  InsurancePlan({
    required this.title,
    required this.insuranceType,
    required this.duration,
    required this.description,
    required this.price,
  });

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      title: json['title']?.toString() ?? 'Unnamed Plan',
      insuranceType: json['insuranceType']?.toString() ?? 'Unknown',
      duration: _safeInt(json['duration']),
      description: json['description']?.toString() ?? '',
      price: _safeInt(json['price']),
    );
  }

  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class InsuranceApiService {
  static const String getPlansUrl = '$baseUrl/api/plans/recommended';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getRecommendedPlans({
    required String carType,
    required int cv,
    required String usage,
    required int carYear,
  }) async {
    try {
      final response = await _dio
          .post(
            getPlansUrl,
            data: {
              'carType': carType,
              'cv': cv,
              'usage': usage,
              'carYear': carYear,
            },
            options: Options(headers: {'Content-Type': 'application/json'}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<InsurancePlan> plans = [];
        if (response.data['plans'] != null) {
          plans = (response.data['plans'] as List)
              .map((planJson) => InsurancePlan.fromJson(planJson))
              .toList();
        }

        return {
          "success": true,
          "message": response.data['message'] ?? "Plans fetched successfully",
          "plans": plans,
        };
      } else {
        return {
          "success": false,
          "error": "Server returned status: ${response.statusCode}",
          "plans": <InsurancePlan>[],
        };
      }
    } on DioException catch (e) {
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              "Connection timeout. Please check your internet connection.";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "Unable to connect to server. Please try again later.";
          break;
        case DioExceptionType.badResponse:
          errorMessage = "Server error: ${e.response?.statusCode ?? 'Unknown'}";
          break;
        default:
          errorMessage = "Network error occurred. Please try again.";
      }

      return {
        "success": false,
        "error": errorMessage,
        "plans": <InsurancePlan>[],
      };
    } catch (e) {
      return {
        "success": false,
        "error": "An unexpected error occurred: ${e.toString()}",
        "plans": <InsurancePlan>[],
      };
    }
  }
}
