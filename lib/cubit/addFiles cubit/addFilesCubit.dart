import 'package:app_devfest/cubit/addFiles%20cubit/addFilesState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFilesCubit extends Cubit<AddFilesState> {
  AddFilesCubit() : super(AddFilesInitial());

  Future<void> uploadFiles(List<String> files) async {
    emit(AddFilesLoading());

    try {
      // Simulate a file upload process (could be replaced by real logic)
      await Future.delayed(const Duration(seconds: 3));

      if (files.isEmpty) {
        throw Exception("No files selected");
      }

      // Simulate successful upload
      emit(AddFilesSuccess());
    } catch (e) {
      emit(AddFilesFailure(e.toString()));
    }
  }
}
