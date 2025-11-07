import 'package:app_devfest/cubit/payment%20cubit/payment_cubit.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final String policyId;
  final VoidCallback onPaymentCompleted;
  final VoidCallback onCancel;

  const PaymentScreen({
    Key? key, // FIXED: Added missing Key parameter
    required this.policyId,
    required this.onPaymentCompleted,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<PaymentCubit>().state is! PaymentReady) {
        context.read<PaymentCubit>().initiatePayment(policyId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white, // FIXED: Added text color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onCancel,
        ),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentReady) {
            _launchPaymentUrl(context, state.checkoutUrl);
          }
          if (state is PaymentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is PaymentInitial) ...[
                  Text(
                    'Preparing payment...',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
                if (state is PaymentLoading) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Securing Payment Gateway...',
                    style: GoogleFonts.poppins(fontSize: 16),
                  )
                ],
                if (state is PaymentFailed) ...[
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Payment Failed',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: GoogleFonts.poppins(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PaymentCubit>().initiatePayment(policyId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry Payment'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchPaymentUrl(BuildContext context, String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        // Delay reset to ensure web view opens
        await Future.delayed(const Duration(seconds: 1));
        onPaymentCompleted();
      } else {
        throw 'Could not launch payment URL';
      }
    } catch (e) {
      print('Error launching payment URL: $e');
    }
  }
}
