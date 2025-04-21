import 'package:app_devfest/cubit/plans%20cubit/plansState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(PlansInitial());

  // To toggle selected guarantee options
  void toggleGuaranteeOption(String option) {
    final currentState = state;
    if (currentState is PlansLoaded) {
      final updatedSelectedOptions =
          Set<String>.from(currentState.selectedOptions);
      if (updatedSelectedOptions.contains(option)) {
        updatedSelectedOptions.remove(option);
      } else {
        updatedSelectedOptions.add(option);
      }
      emit(PlansLoaded(selectedOptions: updatedSelectedOptions));
    }
  }

  // For validating and processing the selected options
  void validateSelection() {
    emit(PlansValidationInProgress());
    // Simulate validation logic here (e.g., API call)
    Future.delayed(const Duration(seconds: 2), () {
      emit(PlansValidated());
    });
  }
}
