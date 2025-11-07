import 'dart:convert';
import 'dart:io';
import 'package:app_devfest/components/custom_text_field.dart';
import 'package:app_devfest/components/single_upload_Card.dart';
import 'package:app_devfest/cubit/get%20vehicle%20id/get_vehicle_id_cubit.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleCubit.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFiles extends StatefulWidget {
  final VoidCallback stepContinue;
  final VoidCallback stepCancel;
  final int currentStep;
  final int stepsLength;
  final String? userId;
  final Function(String carType, int cv, String usage, int carYear)?
      onCarDetailsSubmitted;

  const AddFiles({
    super.key,
    required this.stepsLength,
    required this.stepContinue,
    required this.stepCancel,
    required this.currentStep,
    this.userId,
    this.onCarDetailsSubmitted,
  });

  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  // Complete car models data with CV and type
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

  // Get just the names for the dropdown
  List<String> get carModels =>
      carModelsData.map((car) => car['name'] as String).toList();

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
    try {
      if (file == null) throw Exception('No file selected');
      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > 10 * 1024 * 1024) {
        throw Exception('File size exceeds 10MB limit');
      }
      return base64Encode(bytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File error: ${e.toString()}')),
      );
      rethrow;
    }
  }

  bool _validateForm() {
    if (selectedCarModel == null ||
        selectedCarUsageType == null ||
        registrationNumberController.text.isEmpty ||
        yearController.text.isEmpty ||
        chassisNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return false;
    }

    if (_driveLicenseFile == null || _vehicleRegistrationFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents")),
      );
      return false;
    }

    return true;
  }

  Future<void> _submitVehicle() async {
    FocusScope.of(context).unfocus();

    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _fileToBase64(_driveLicenseFile),
        _fileToBase64(_vehicleRegistrationFile),
      ]);

      final vehicleAddCubit = context.read<VehicleCubit>();
      final vehicleListCubit = context.read<GetVehicleIdCubit>();

      // Find the selected car model data
      final selectedCarData = carModelsData.firstWhere(
        (car) => car['name'] == selectedCarModel,
        orElse: () => {'cv': 5, 'type': 'economy'}, // Default values
      );

      await vehicleAddCubit.addVehicle(
        owner: widget.userId!,
        registrationNumber: registrationNumberController.text.trim(),
        model: selectedCarModel!,
        brand: "",
        year: (int.tryParse(yearController.text.trim()) ?? 2000).toString(),
        chassisNumber: chassisNumberController.text.trim(),
        driveLicense: results[0],
        vehicleRegistration: results[1],
        usageType: selectedCarUsageType!,
      );

      await Future.delayed(const Duration(seconds: 1));
      await vehicleListCubit.refreshVehicles();

      // Pass car details to parent
      // In AddFiles' _submitVehicle method
      if (widget.onCarDetailsSubmitted != null) {
        widget.onCarDetailsSubmitted!(
          selectedCarData['type']?.toLowerCase() ??
              'economy', // Ensure lowercase
          (selectedCarData['cv'] as int?) ?? 5, // Ensure int type
          selectedCarUsageType!.toLowerCase(), // Lowercase usage type
          int.tryParse(yearController.text.trim()) ?? 2000,
        );
      }

      widget.stepContinue();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehicleCubit, VehicleState>(
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

              // File upload components
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

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : widget.stepCancel,
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
                      onPressed: _isLoading ? null : _submitVehicle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF394496),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
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
      ),
    );
  }
}
