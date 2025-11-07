import 'package:app_devfest/api/plans/plans_api_service.dart';
import 'package:app_devfest/cubit/policy%20cubit/policy_cubit.dart';
import 'package:app_devfest/cubit/policy%20cubit/policy_state.dart';
import 'package:app_devfest/local%20storage/save_userID.dart';
import 'package:app_devfest/local%20storage/save_vehicleId.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PolicyCreationScreen extends StatefulWidget {
  final InsurancePlan selectedPlan;
  final Function(String) onPolicyCreated;
  final VoidCallback onCancel;

  const PolicyCreationScreen({
    Key? key,
    required this.selectedPlan,
    required this.onPolicyCreated,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<PolicyCreationScreen> createState() => _PolicyCreationScreenState();
}

class _PolicyCreationScreenState extends State<PolicyCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String _userId = '';
  String _vehicleId = '';
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _setDefaultDates();
  }

  Future<void> _loadUserData() async {
    try {
      // Get user ID
      _userId = await getUserId();

      // Get vehicle IDs
      final vehicleIds = await VehicleStorage.getVehicleIds();
      if (vehicleIds.isEmpty) {
        throw Exception('No registered vehicles found');
      }

      // Get latest vehicle ID
      _vehicleId = vehicleIds.last;

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user data: ${e.toString()}';
        _loading = false;
      });
      _showErrorSnackbar(_errorMessage);
      Future.delayed(const Duration(seconds: 1), widget.onCancel);
    }
  }

  void _setDefaultDates() {
    final now = DateTime.now();
    _startDateController.text = _formatDate(now);
    final endDate = now.add(Duration(days: widget.selectedPlan.duration * 30));
    _endDateController.text = _formatDate(endDate);
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Create Policy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onCancel,
        ),
      ),
      body: BlocListener<PolicyCubit, PolicyState>(
        listener: (context, state) {
          if (state is PolicySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            widget.onPolicyCreated(state.policyId);
          } else if (state is PolicyFailure) {
            _showErrorSnackbar(state.error);
          }
        },
        child: _loading ? _buildLoading() : _buildContent(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: GoogleFonts.poppins(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 24),
            _buildPlanSummaryCard(),
            const SizedBox(height: 24),
            _buildDateForm(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Information',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.person_outline, 'User ID:', _userId),
          _buildInfoRow(Icons.directions_car, 'Vehicle ID:', _vehicleId),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: mainColor, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Plan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.selectedPlan.title,
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            widget.selectedPlan.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.selectedPlan.duration} months',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              Text(
                '${widget.selectedPlan.price} DZD',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildDateField(
              controller: _startDateController,
              label: 'Start Date',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              controller: _endDateController,
              label: 'End Date',
              icon: Icons.event_available,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      validator: (value) => value?.isEmpty ?? true ? 'Select date' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: mainColor),
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<PolicyCubit, PolicyState>(
      builder: (context, state) {
        final isLoading = state is PolicyLoading;
        return Row(
          children: [
            Expanded(
              child: _buildButton(
                text: 'Cancel',
                color: Colors.grey,
                onPressed: isLoading ? null : widget.onCancel,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildButton(
                text: 'Create Policy',
                color: mainColor,
                onPressed: isLoading ? null : _submitPolicy,
                isLoading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: mainColor,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      controller.text = _formatDate(picked);
    }
  }

  void _submitPolicy() {
    if (_formKey.currentState!.validate()) {
      context.read<PolicyCubit>().createPolicy(
            type: widget.selectedPlan.insuranceType,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
            user: _userId,
            vehicle: _vehicleId,
            price: widget.selectedPlan.price,
          );
    }
  }
}
