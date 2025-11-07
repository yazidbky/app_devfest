abstract class ClaimState {}

class ClaimInitial extends ClaimState {}

class ClaimLoading extends ClaimState {}

class ClaimSuccess extends ClaimState {
  final String message;
  final Map<String, dynamic>? claimData;

  ClaimSuccess(this.message, {this.claimData});
}

class ClaimFailure extends ClaimState {
  final String error;

  ClaimFailure(this.error);
}
