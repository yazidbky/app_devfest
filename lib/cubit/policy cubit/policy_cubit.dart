import 'package:app_devfest/api/policy/policy_api_service.dart';
import 'package:app_devfest/cubit/policy%20cubit/policy_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PolicyCubit extends Cubit<PolicyState> {
  final PolicyApiService _apiService;

  PolicyCubit({PolicyApiService? apiService})
      : _apiService = apiService ?? PolicyApiService(),
        super(PolicyInitial());

  Future<void> createPolicy({
    required String type,
    required String startDate,
    required String endDate,
    required String user,
    required String vehicle,
    required int price,
  }) async {
    emit(PolicyLoading());

    try {
      final result = await _apiService.createPolicy(
        type: type,
        startDate: startDate,
        endDate: endDate,
        user: user,
        vehicle: vehicle,
        price: price,
      );

      if (result['success'] == true) {
        // Validate policy creation response
        final policyId = result['policyId']?.toString();
        if (policyId?.isNotEmpty ?? false) {
          emit(PolicySuccess(
            policyId: policyId!,
            message: result['message'] ?? 'Policy created successfully',
          ));
        } else {
          emit(PolicyFailure('Policy created but missing ID in response'));
        }
      } else {
        emit(PolicyFailure(
            result['error']?.toString() ?? 'Policy creation failed'));
      }
    } catch (e) {
      emit(PolicyFailure('Policy creation error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(PolicyInitial());
  }
}
