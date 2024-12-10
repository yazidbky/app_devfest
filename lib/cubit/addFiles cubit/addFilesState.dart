abstract class AddFilesState {}

class AddFilesInitial extends AddFilesState {}

class AddFilesLoading extends AddFilesState {}

class AddFilesSuccess extends AddFilesState {}

class AddFilesFailure extends AddFilesState {
  final String error;

  AddFilesFailure(this.error);
}
