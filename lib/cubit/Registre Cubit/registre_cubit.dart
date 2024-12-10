import 'package:app_devfest/cubit/Registre%20Cubit/registre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    try {
      // Simulate registration API call
      await Future.delayed(Duration(seconds: 2));
      // Assuming registration success
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure('Registration failed. Please try again.'));
    }
  }
}
