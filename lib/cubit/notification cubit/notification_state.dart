import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;
  final String? timestamp;
  final String? userId;

  const NotificationSuccess(
    this.message, {
    this.timestamp,
    this.userId,
  });

  @override
  List<Object?> get props => [message, timestamp, userId];
}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure(this.error);

  @override
  List<Object> get props => [error];
}
