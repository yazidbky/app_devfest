// policy_state.dart

abstract class PolicyState {}

class PolicyInitial extends PolicyState {}

class PolicyLoading extends PolicyState {}

class PolicySuccess extends PolicyState {
  final String policyId;
  final String message;

  PolicySuccess({required this.policyId, required this.message});
}

class PolicyFailure extends PolicyState {
  final String error;

  PolicyFailure(this.error);
}
