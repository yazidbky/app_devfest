import 'package:app_devfest/api/plans/plans_api_service.dart';
import 'package:app_devfest/cubit/plans%20cubit/plansState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsuranceCubit extends Cubit<InsuranceState> {
  final InsuranceApiService _apiService;

  InsuranceCubit({InsuranceApiService? apiService})
      : _apiService = apiService ?? InsuranceApiService(),
        super(InsuranceInitial());

  Future<void> getRecommendedPlans({
    required String carType,
    required int cv,
    required String usage,
    required int carYear,
  }) async {
    emit(InsuranceLoading());

    // Input validation
    if (carType.isEmpty || cv <= 0 || usage.isEmpty || carYear <= 0) {
      emit(InsuranceFailure('Please provide valid car information'));
      return;
    }

    try {
      final result = await _apiService.getRecommendedPlans(
        carType: carType,
        cv: cv,
        usage: usage,
        carYear: carYear,
      );

      if (result['success'] == true) {
        final plans = result['plans'] as List<InsurancePlan>;
        if (plans.isEmpty) {
          emit(InsuranceFailure(
              'No insurance plans available for your car configuration'));
        } else {
          emit(InsuranceSuccess(plans: plans));
        }
      } else {
        emit(InsuranceFailure(result['error']?.toString() ??
            'Failed to fetch plans from server'));
      }
    } catch (e) {
      emit(InsuranceFailure(
          'An error occurred while fetching plans: ${e.toString()}'));
    }
  }

  void changeInsuranceType(String insuranceType) {
    if (state is InsuranceSuccess) {
      final currentState = state as InsuranceSuccess;
      emit(currentState.copyWith(selectedInsuranceType: insuranceType));
    }
  }

  void retryFetchPlans({
    required String carType,
    required int cv,
    required String usage,
    required int carYear,
  }) {
    getRecommendedPlans(
      carType: carType,
      cv: cv,
      usage: usage,
      carYear: carYear,
    );
  }
}
