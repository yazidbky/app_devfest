abstract class PlansState {}

class PlansInitial extends PlansState {}

class PlansLoaded extends PlansState {
  final Set<String> selectedOptions;

  PlansLoaded({required this.selectedOptions});
}

class PlansValidationInProgress extends PlansState {}

class PlansValidated extends PlansState {
  // This state indicates that validation is complete
}
