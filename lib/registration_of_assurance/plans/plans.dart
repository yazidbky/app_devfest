import 'package:app_devfest/api/payment/payment_api_service.dart';
import 'package:app_devfest/api/plans/plans_api_service.dart';
import 'package:app_devfest/components/insurance_plan_card.dart';
import 'package:app_devfest/cubit/payment%20cubit/payment_cubit.dart';
import 'package:app_devfest/cubit/plans%20cubit/plansCubit.dart';
import 'package:app_devfest/cubit/plans%20cubit/plansState.dart';
import 'package:app_devfest/cubit/policy%20cubit/policy_cubit.dart';
import 'package:app_devfest/registration_of_assurance/payment/payment_screen.dart';
import 'package:app_devfest/registration_of_assurance/payment/webview.dart';
import 'package:app_devfest/registration_of_assurance/policy/policy_screen.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Plans extends StatefulWidget {
  final VoidCallback stepContinue;
  final VoidCallback stepCancel;
  final int currentStep;
  final int stepsLength;
  final String carType;
  final int cv;
  final String usage;
  final int carYear;

  const Plans({
    Key? key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
    required this.carType,
    required this.cv,
    required this.usage,
    required this.carYear,
  }) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  String selectedInsuranceType = 'mandatory';

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  void _fetchPlans() {
    // Validate received data
    if (widget.carType.isEmpty || widget.cv <= 0 || widget.carYear <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid car configuration'),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }

    context.read<InsuranceCubit>().getRecommendedPlans(
          carType: widget.carType,
          cv: widget.cv,
          usage: widget.usage,
          carYear: widget.carYear,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentReady) {
          _launchPaymentUrl(context, state.checkoutUrl);
        }
        if (state is PaymentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Car information display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Car Information:',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Type: ${widget.carType}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'CV: ${widget.cv}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Usage: ${widget.usage}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Year: ${widget.carYear}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Insurance type selector
                Text(
                  'Choose your insurance type:',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedInsuranceType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'mandatory',
                          child: Text('Mandatory'),
                        ),
                        DropdownMenuItem(
                          value: 'medium coverage',
                          child: Text('Medium Coverage'),
                        ),
                        DropdownMenuItem(
                          value: 'full coverage',
                          child: Text('Full Coverage'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedInsuranceType = value;
                          });
                          context
                              .read<InsuranceCubit>()
                              .changeInsuranceType(value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Plans section
                BlocBuilder<InsuranceCubit, InsuranceState>(
                  builder: (context, state) {
                    if (state is InsuranceLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading insurance plans...'),
                            ],
                          ),
                        ),
                      );
                    } else if (state is InsuranceFailure) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Unable to Load Plans',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.red[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.error,
                                style: GoogleFonts.poppins(
                                  color: Colors.red[600],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _fetchPlans,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is InsuranceSuccess) {
                      final filteredPlans = state.plans
                          .where((plan) =>
                              plan.insuranceType.toLowerCase() ==
                              selectedInsuranceType.toLowerCase())
                          .toList();

                      if (filteredPlans.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Plans Available',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No insurance plans available for "$selectedInsuranceType" coverage type with your car configuration.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Try selecting a different insurance type or contact support.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          // Results header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Text(
                              '${filteredPlans.length} plan${filteredPlans.length != 1 ? 's' : ''} found for "$selectedInsuranceType" coverage',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Plans display
                          if (filteredPlans.length > 2)
                            SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: filteredPlans.map((plan) {
                                    return InsurancePlanCard(
                                      plan: plan,
                                      onPurchase: () =>
                                          _navigateToPolicyCreation(plan),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 800
                                        ? 3
                                        : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: filteredPlans.length,
                              itemBuilder: (context, index) {
                                return InsurancePlanCard(
                                  plan: filteredPlans[index],
                                  onPurchase: () => _navigateToPolicyCreation(
                                      filteredPlans[index]),
                                );
                              },
                            ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 32),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: widget.stepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      height: 40,
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: widget.stepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          widget.currentStep == widget.stepsLength - 1
                              ? 'Finish'
                              : 'Continue',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // FIXED: Added the missing onPaymentCompleted function
  void onPaymentCompleted() {
    // Handle payment completion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to next step or finish the flow
    widget.stepContinue();
  }

  Future<void> _launchPaymentUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        onPaymentCompleted();
      } else {
        // Fallback 1: Try opening in WebView
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
            webViewConfiguration: const WebViewConfiguration(
              headers: {'Content-Type': 'text/html'},
            ),
          );
        } catch (webViewError) {
          // Fallback 2: Show URL in dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Payment Required'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not open browser. Copy this URL:'),
                  SelectableText(url),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL copied to clipboard')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Copy URL'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Error: ${e.toString()}')),
      );
    }
  }

  void _navigateToPolicyCreation(InsurancePlan plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => PolicyCubit(),
          child: PolicyCreationScreen(
            selectedPlan: plan,
            onPolicyCreated: (policyId) {
              Navigator.of(context).pop();
              // Directly navigate to payment after policy creation
              _navigateToPayment(context, policyId);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _navigateToPayment(BuildContext context, String policyId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              PaymentCubit(PaymentApiService())..initiatePayment(policyId),
          child: BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentReady) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentWebView(
                      url: state.checkoutUrl,
                    ),
                  ),
                );
              }
            },
            child: PaymentScreen(
              policyId: policyId,
              onPaymentCompleted: () {
                // Handle successful payment completion
                Navigator.of(context).pop(); // Close payment screen
                onPaymentCompleted(); // Call the completion handler
              },
              onCancel: () {
                Navigator.of(context).pop(); // Close payment screen
              },
            ),
          ),
        ),
      ),
    );
  }
}
