import 'package:app_devfest/cubit/confirmation%20cubit/confirmationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdentityConfirmationCubit extends Cubit<IdentityConfirmationState> {
  IdentityConfirmationCubit() : super(IdentityConfirmationInitial());

  // Simulate file upload or camera process
  Future<void> uploadFileFromGallery(String fileName, String fileSize) async {
    emit(IdentityConfirmationLoading());

    try {
      // Simulate a delay for file upload
      await Future.delayed(const Duration(seconds: 2));

      if (fileName.isEmpty || fileSize.isEmpty) {
        throw Exception("Invalid file");
      }

      emit(IdentityConfirmationSuccess(fileName, fileSize));
    } catch (e) {
      emit(IdentityConfirmationFailure(e.toString()));
    }
  }

  Future<void> activateCamera() async {
    emit(IdentityConfirmationLoading());

    try {
      // Simulate camera activation delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful camera operation
      emit(IdentityConfirmationSuccess("selfie.jpg", "1MB"));
    } catch (e) {
      emit(IdentityConfirmationFailure("Failed to open camera"));
    }
  }
}
