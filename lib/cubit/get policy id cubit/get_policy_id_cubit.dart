import 'package:app_devfest/api/get%20policy/getpolicy_id_api.dart';
import 'package:app_devfest/cubit/get%20policy%20id%20cubit/get_policy_id_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPolicyCubit extends Cubit<GetPolicyState> {
  final GetPolicyById _policyService;
  String? _currentPolicyId; // Track the current policy ID

  GetPolicyCubit(this._policyService) : super(GetPolicyInitial());

  Future<void> fetchPolicy(String userId) async {
    _currentPolicyId = userId; // Store the policy ID
    emit(GetPolicyLoading());

    try {
      final response = await _policyService.getPolicy(userId: userId);

      if (response['success'] == true) {
        final policy = response['policy'];
        if (policy != null) {
          emit(GetPolicyLoaded(policy: policy));
        } else {
          emit(const GetPolicyError(error: 'Policy data is null'));
        }
      } else {
        final error = response['error'] ?? 'Failed to fetch policy';
        if (error == 'Policy not found') {
          emit(const GetPolicyNotFound());
        } else {
          emit(GetPolicyError(error: error));
        }
      }
    } catch (e) {
      emit(GetPolicyError(error: e.toString()));
    }
  }

  // Refresh the current policy
  Future<void> refreshPolicy() async {
    if (_currentPolicyId != null) {
      await fetchPolicy(_currentPolicyId!);
    }
  }

  // Clear policy data
  void clearPolicy() {
    _currentPolicyId = null;
    emit(GetPolicyInitial());
  }

  // Get the current policy ID
  String? get currentPolicyId => _currentPolicyId;
}
