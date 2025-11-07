import 'package:app_devfest/api/get%20policy/gte_policy_id_json.dart';
import 'package:equatable/equatable.dart';

abstract class GetPolicyState extends Equatable {
  const GetPolicyState();

  @override
  List<Object?> get props => [];
}

class GetPolicyInitial extends GetPolicyState {}

class GetPolicyLoading extends GetPolicyState {}

class GetPolicyLoaded extends GetPolicyState {
  final Policy policy;

  const GetPolicyLoaded({required this.policy});

  @override
  List<Object?> get props => [policy];
}

class GetPolicyError extends GetPolicyState {
  final String error;

  const GetPolicyError({required this.error});

  @override
  List<Object?> get props => [error];
}

class GetPolicyNotFound extends GetPolicyState {
  const GetPolicyNotFound();
}
