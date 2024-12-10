import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedOptionsCubit extends Cubit<Set<String>> {
  SelectedOptionsCubit() : super({});

  // Method to toggle the selected option
  void toggleOption(String option) {
    final currentState = Set<String>.from(state);
    if (currentState.contains(option)) {
      currentState.remove(option);
    } else {
      currentState.add(option);
    }
    emit(currentState);
  }
}
