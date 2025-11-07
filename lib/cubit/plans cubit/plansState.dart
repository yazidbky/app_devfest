import 'package:app_devfest/api/plans/plans_api_service.dart';

abstract class InsuranceState {}

class InsuranceInitial extends InsuranceState {}

class InsuranceLoading extends InsuranceState {}

class InsuranceSuccess extends InsuranceState {
  final List<InsurancePlan> plans;
  final String selectedInsuranceType;

  InsuranceSuccess({
    required this.plans,
    this.selectedInsuranceType = 'mandatory',
  });

  InsuranceSuccess copyWith({
    List<InsurancePlan>? plans,
    String? selectedInsuranceType,
  }) {
    return InsuranceSuccess(
      plans: plans ?? this.plans,
      selectedInsuranceType:
          selectedInsuranceType ?? this.selectedInsuranceType,
    );
  }
}

class InsuranceFailure extends InsuranceState {
  final String error;

  InsuranceFailure(this.error);
}
