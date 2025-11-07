// cubit/payment_cubit/payment_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/api/payment/payment_api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentApiService apiService;
  StreamSubscription? _webViewSubscription;

  PaymentCubit(this.apiService) : super(PaymentInitial());

  Future<void> initiatePayment(String policyId) async {
    // Fixed parameter
    try {
      emit(PaymentLoading());
      final result = await apiService.initiatePayment(policyId);

      if (result['success'] == true) {
        emit(PaymentReady(
            checkoutUrl: result['checkout_url'] // Fixed parameter passing
            ));
      } else {
        emit(PaymentFailed(result['error']));
      }
    } catch (e) {
      emit(PaymentFailed('Payment initialization failed: $e'));
    }
  }

  // void monitorWebView(WebViewController controller) {
  //   _webViewSubscription?.cancel();
  //   _webViewSubscription = controller
  //       .getCurrentUrl()
  //       .asStream()
  //       .listen(_handleUrlChange);
  // }

  void _handleUrlChange(String? url) {
    if (url?.contains('/payment-success') == true) {
      // Handle successful payment
    }
  }

  @override
  Future<void> close() {
    _webViewSubscription?.cancel();
    return super.close();
  }
}
