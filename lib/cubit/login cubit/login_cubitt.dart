import 'package:app_devfest/cubit/login%20cubit/login_state.dart';
import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure('Login failed. Please try again.'));
    }
  }
}
