// payment_state.dart
part of 'payment_cubit.dart';

sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentReady extends PaymentState {
  final String checkoutUrl;

  PaymentReady({required this.checkoutUrl}); // Fixed required parameter
}

final class PaymentFailed extends PaymentState {
  final String error;

  PaymentFailed(this.error);
}
