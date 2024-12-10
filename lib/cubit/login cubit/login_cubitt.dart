import 'package:app_devfest/cubit/login%20cubit/login_state.dart';
import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      // Simulate login API call
      await Future.delayed(Duration(seconds: 2));
      // Assuming login success
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure('Login failed. Please try again.'));
    }
  }
}
