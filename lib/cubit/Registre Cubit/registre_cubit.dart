import 'package:app_devfest/api/register/register_api_service.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegistreApiService _apiService;

  RegisterCubit({RegistreApiService? apiService})
      : _apiService = apiService ?? RegistreApiService(),
        super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isChecked,
    required String phone,
    required String address,
  }) async {
    // Emit loading state to show progress indicator
    emit(RegisterLoading());

    // Validate inputs
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      emit(RegisterFailure('All fields are required.'));
      return;
    }

    // Validate password match
    if (password != confirmPassword) {
      emit(RegisterFailure('Passwords do not match.'));
      return;
    }

    // Validate terms acceptance
    if (!isChecked) {
      emit(RegisterFailure('Please accept the terms and conditions.'));
      return;
    }

    try {
      // Call the API service
      final result = await _apiService.registerUser(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      if (result['success']) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(result['error']));
      }
    } catch (e) {
      emit(RegisterFailure(
          'Network error. Please check your connection and try again.'));
    }
  }
}
