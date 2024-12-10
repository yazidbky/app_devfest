abstract class IdentityConfirmationState {}

class IdentityConfirmationInitial extends IdentityConfirmationState {}

class IdentityConfirmationLoading extends IdentityConfirmationState {}

class IdentityConfirmationSuccess extends IdentityConfirmationState {
  final String fileName;
  final String fileSize;

  IdentityConfirmationSuccess(this.fileName, this.fileSize);
}

class IdentityConfirmationFailure extends IdentityConfirmationState {
  final String error;

  IdentityConfirmationFailure(this.error);
}
