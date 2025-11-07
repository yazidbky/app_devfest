import 'package:app_devfest/api/login/login_api_service.dart';
import 'package:app_devfest/cubit/login%20cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginApiService _apiService;

  LoginCubit({LoginApiService? apiService})
      : _apiService = apiService ?? LoginApiService(),
        super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    // Input validation
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('Please enter both email and password'));
      return;
    }

    try {
      final result = await _apiService.loginUser(
        email: email,
        password: password,
      );

      if (result['success'] == true) {
        emit(LoginSuccess(
          token: result['accessToken'] ??
              '', // Changed from 'token' to 'accessToken'
        ));
      } else {
        emit(LoginFailure(result['error']?.toString() ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginFailure('An error occurred: ${e.toString()}'));
    }
  }
}
