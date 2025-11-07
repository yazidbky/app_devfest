import 'dart:convert';
import 'dart:io';
import 'package:app_devfest/components/custom_text_field.dart';
import 'package:app_devfest/components/single_upload_Card.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleCubit.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCar extends StatefulWidget {
  final VoidCallback stepContinue;
  final VoidCallback stepCancel;
  final int currentStep;
  final int stepsLength;
  final String? userId;

  const AddCar({
    super.key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
    this.userId,
  });

  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final List<String> carModels = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Truck',
    'Van',
    'Coupe',
    'Convertible',
    'Wagon',
    'Other'
  ];
  String? selectedCarModel;

  final List<String> carUsageTypes = ['Personal', 'Commercial'];
  String? selectedCarUsageType;

  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();

  File? _driveLicenseFile;
  File? _vehicleRegistrationFile;
  bool _isLoading = false;

  Future<String> _fileToBase64(File? file) async {
    if (file == null) return '';
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitVehicle() async {
    if (selectedCarModel == null ||
        selectedCarUsageType == null ||
        registrationNumberController.text.isEmpty ||
        yearController.text.isEmpty ||
        chassisNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    if (_driveLicenseFile == null || _vehicleRegistrationFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final driveLicenseBase64 = await _fileToBase64(_driveLicenseFile);
      final vehicleRegistrationBase64 =
          await _fileToBase64(_vehicleRegistrationFile);

      context.read<VehicleCubit>().addVehicle(
            owner: widget.userId!,
            registrationNumber: registrationNumberController.text,
            model: selectedCarModel!,
            brand: "",
            year: yearController.text,
            chassisNumber: chassisNumberController.text,
            driveLicense: driveLicenseBase64,
            vehicleRegistration: vehicleRegistrationBase64,
            usageType: selectedCarUsageType!,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing files: ${e.toString()}")),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Car',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.stepCancel,
        ),
      ),
      body: BlocListener<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is VehicleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            setState(() => _isLoading = false);
          } else if (state is VehicleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            widget.stepContinue();
            setState(() => _isLoading = false);
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                // Car model dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Model',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Car Model',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                          value: selectedCarModel,
                          items: carModels
                              .map((model) => DropdownMenuItem(
                                    value: model,
                                    child: Text(model),
                                  ))
                              .toList(),
                          onChanged: (newValue) =>
                              setState(() => selectedCarModel = newValue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Car usage type dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Usage Type',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select Usage Type',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                          value: selectedCarUsageType,
                          items: carUsageTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (newValue) =>
                              setState(() => selectedCarUsageType = newValue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: registrationNumberController,
                  hintText: 'Enter Registration Number',
                  text: 'Car Registration Number',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: yearController,
                  hintText: 'Enter Car Year',
                  text: 'Car Year',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: chassisNumberController,
                  hintText: 'Enter Chassis Number',
                  text: 'Car Chassis Number',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 24),

                // Updated file upload components
                SingleUploadCard(
                  title: "Upload driver's license",
                  subtitle: "Please upload your valid driver's license",
                  dragFile:
                      'Drag your file(s) or browse\nMax 10 MB files are allowed',
                  onFileSelected: (file) =>
                      setState(() => _driveLicenseFile = file),
                ),
                const SizedBox(height: 24),

                SingleUploadCard(
                  title: 'Upload vehicle registration (Carte Grise)',
                  subtitle:
                      "Please upload your valid vehicle registration document",
                  dragFile:
                      "Drag your file(s) or browse\nMax 10 MB files are allowed",
                  onFileSelected: (file) =>
                      setState(() => _vehicleRegistrationFile = file),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF394496),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.currentStep == widget.stepsLength - 1
                                  ? 'Finish Registration'
                                  : 'Continue',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
