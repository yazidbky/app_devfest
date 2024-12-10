import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isChecked,
  }) async {
    emit(RegisterLoading());

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      emit(RegisterFailure('All fields are required.'));
      return;
    }

    if (password != confirmPassword) {
      emit(RegisterFailure('Passwords do not match.'));
      return;
    }

    if (!isChecked) {
      emit(RegisterFailure('Please accept the terms and conditions.'));
      return;
    }

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));
      // Assuming registration success
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure('Registration failed. Please try again.'));
    }
  }
}
