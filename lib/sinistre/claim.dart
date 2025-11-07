import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:app_devfest/components/custom_text_field.dart';
import 'package:app_devfest/components/uploadFilesCard.dart';
import 'package:app_devfest/cubit/claim%20cubit/claim_cubit.dart';
import 'package:app_devfest/cubit/claim%20cubit/claim_state.dart';
import 'package:app_devfest/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AccidentDetailsSubmission extends StatefulWidget {
  final String? userId;
  final String? vehicleId;
  final String? policyId;
  final VoidCallback? onSubmissionComplete;

  const AccidentDetailsSubmission({
    super.key,
    this.userId = '6832aff387ba74da46e408c2',
    this.vehicleId = '6832b01887ba74da46e408c4',
    this.policyId = '6832b05c87ba74da46e408c7',
    this.onSubmissionComplete,
  });

  @override
  _AccidentDetailsSubmissionState createState() =>
      _AccidentDetailsSubmissionState();
}

class _AccidentDetailsSubmissionState extends State<AccidentDetailsSubmission> {
  // Form controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController wilayaController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedVehicle;
  final List<Map<String, dynamic>> carModelsData = [
    {'name': "Renault Clio 4", 'cv': 6, 'type': "economy"},
    {'name': "Hyundai i10", 'cv': 5, 'type': "economy"},
    {'name': "Kia Picanto", 'cv': 4, 'type': "economy"},
    {'name': "Peugeot 208", 'cv': 5, 'type': "economy"},
    {'name': "Dacia Sandero", 'cv': 5, 'type': "economy"},
    {'name': "Dacia Logan", 'cv': 6, 'type': "economy"},
    {'name': "Chevrolet Spark", 'cv': 4, 'type': "economy"},
    {'name': "Volkswagen Golf 7", 'cv': 8, 'type': "luxury"},
    {'name': "Toyota Corolla", 'cv': 7, 'type': "economy"},
    {'name': "Hyundai Accent", 'cv': 6, 'type': "economy"},
    {'name': "Renault Symbol", 'cv': 5, 'type': "economy"},
    {'name': "Peugeot 301", 'cv': 6, 'type': "economy"},
    {'name': "Seat Ibiza", 'cv': 6, 'type': "economy"},
    {'name': "Citroën C3", 'cv': 5, 'type': "economy"},
    {'name': "Suzuki Swift", 'cv': 4, 'type': "economy"},
    {'name': "Hyundai Tucson", 'cv': 8, 'type': "suv"},
    {'name': "Kia Sportage", 'cv': 8, 'type': "suv"},
    {'name': "Dacia Duster", 'cv': 7, 'type': "suv"},
    {'name': "Peugeot 3008", 'cv': 8, 'type': "suv"},
    {'name': "Toyota Land Cruiser", 'cv': 10, 'type': "suv"},
    {'name': "BMW Serie 3", 'cv': 9, 'type': "luxury"},
    {'name': "Mercedes-Benz C-Class", 'cv': 9, 'type': "luxury"},
    {'name': "Audi A4", 'cv': 9, 'type': "luxury"},
    {'name': "Volkswagen Passat", 'cv': 8, 'type': "luxury"},
    {'name': "Skoda Octavia", 'cv': 7, 'type': "economy"},
  ];

  // Dropdown values
  final List<String> accidentTypes = [
    'collision',
    'theft',
    'fire',
    'vandalism',
    'natural_disaster',
    'other',
  ];
  String? selectedAccidentType;

  final List<String> vehicleStatusOptions = [
    'Drivable',
    'Not Drivable',
  ];
  String? selectedVehicleStatus;

  // File handling
  List<File> _accidentImages = [];

  // Date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Accident Date',
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Convert files to base64
  Future<List<String>> _filesToBase64(List<File> files) async {
    List<String> base64Images = [];

    for (File file in files) {
      try {
        final bytes = await file.readAsBytes();
        if (bytes.lengthInBytes > 10 * 1024 * 1024) {
          throw Exception('File ${file.path} exceeds 10MB limit');
        }
        base64Images.add(base64Encode(bytes));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File error: ${e.toString()}')),
        );
        rethrow;
      }
    }

    return base64Images;
  }

  // Form validation
  bool _validateForm() {
    if (selectedAccidentType == null ||
        dateController.text.isEmpty ||
        locationController.text.isEmpty ||
        wilayaController.text.isEmpty ||
        selectedVehicleStatus == null ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return false;
    }

    if (_accidentImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please upload at least one accident image")),
      );
      return false;
    }

    return true;
  }

  // Submit claim
  Future<void> _submitClaim() async {
    FocusScope.of(context).unfocus();

    if (widget.userId == null ||
        widget.vehicleId == null ||
        widget.policyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Missing required user, vehicle, or policy information")),
      );
      return;
    }

    if (!_validateForm()) return;

    try {
      final base64Images = await _filesToBase64(_accidentImages);
      final claimCubit = context.read<ClaimCubit>();

      await claimCubit.addClaim(
        user: widget.userId!,
        vehicle: widget.vehicleId!,
        policy: widget.policyId!,
        description: descriptionController.text.trim(),
        date: dateController.text.trim(),
        location: locationController.text.trim(),
        wilaya: wilayaController.text.trim(),
        accidentType: selectedAccidentType!,
        vehicleStatus: selectedVehicleStatus!,
        images: base64Images,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Navigate to Home Page
  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text('Y', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          BlocConsumer<ClaimCubit, ClaimState>(
            listener: (context, state) {
              if (state is ClaimFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ClaimSuccess) {
                // Clear form after successful submission
                _clearForm();

                // Show success message briefly then navigate to home
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 1),
                  ),
                );

                // Navigate to home after a short delay
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    _navigateToHome();
                  }
                });

                if (widget.onSubmissionComplete != null) {
                  widget.onSubmissionComplete!();
                }
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Header with blue circle
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A90E2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Accident Details Submission',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Accident type dropdown
                      _buildDropdownField(
                        label: 'Accident type',
                        hint: '-- Select type of accident --',
                        value: selectedAccidentType,
                        items: accidentTypes,
                        onChanged: (value) =>
                            setState(() => selectedAccidentType = value),
                      ),
                      const SizedBox(height: 24),

                      // Vehicle dropdown
                      _buildVehicleDropdown(),
                      const SizedBox(height: 24),

                      // Accident Date
                      _buildDateField(),
                      const SizedBox(height: 24),

                      // Accident Location
                      CustomTextField(
                        controller: locationController,
                        hintText: 'Accident Location',
                        text: 'Accident Location',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),

                      // Wilaya
                      CustomTextField(
                        controller: wilayaController,
                        hintText: 'Wilaya',
                        text: 'Wilaya',
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 24),

                      // Vehicle Status
                      _buildVehicleStatusField(),
                      const SizedBox(height: 24),

                      // Accident Description
                      _buildDescriptionField(),
                      const SizedBox(height: 32),

                      // Upload Accident Images
                      _buildImageUploadSection(),
                      const SizedBox(height: 40),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6CF7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Submit Claim',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),

          // Loading overlay with blur effect
          BlocBuilder<ClaimCubit, ClaimState>(
            builder: (context, state) {
              if (state is ClaimLoading) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A90E2),
                              ),
                              strokeWidth: 4.0,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Submitting your claim...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              value: value,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                '-- Select your vehicle --',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              value: selectedVehicle,
              items: carModelsData.map((vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle['name'],
                  child: Text(
                    '${vehicle['name']} (CV: ${vehicle['cv']})',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (newValue) =>
                  setState(() => selectedVehicle = newValue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accident Date',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateController.text.isEmpty
                      ? 'mm/dd/yyyy'
                      : dateController.text,
                  style: GoogleFonts.poppins(
                    color: dateController.text.isEmpty
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Status',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: vehicleStatusOptions.map((status) {
            return Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: status,
                    groupValue: selectedVehicleStatus,
                    activeColor: const Color(0xFF4A90E2),
                    onChanged: (value) =>
                        setState(() => selectedVehicleStatus = value),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accident Description',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Accident Description',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Accident Images',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        UploadCard(
          title: "Drop Images Here",
          subtitle: "Please upload your files here ",
          dragFile: 'Drag your file(s) or browse\nMax 10 MB files are allowed',
          onFilesSelected: (files) {
            setState(() {
              _accidentImages = files;
            });
          },
        ),
        if (_accidentImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Selected Images (${_accidentImages.length})',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _accidentImages.length,
              itemBuilder: (context, index) {
                final file = _accidentImages[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () {
                              setState(() {
                                _accidentImages.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _clearForm() {
    setState(() {
      selectedAccidentType = null;
      selectedVehicle = null;
      selectedVehicleStatus = null;
      _accidentImages.clear();
      dateController.clear();
      locationController.clear();
      wilayaController.clear();
      descriptionController.clear();
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    locationController.dispose();
    wilayaController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
