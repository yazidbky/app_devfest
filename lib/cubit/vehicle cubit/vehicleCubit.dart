import 'package:app_devfest/api/vehicle/vehivle_api_service.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleState.dart';
import 'package:app_devfest/local%20storage/save_vehicleId.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:io';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleApiService _vehicleApiService = VehicleApiService();

  VehicleCubit() : super(VehicleInitial());

  Future<void> addVehicle({
    required String owner,
    required String registrationNumber,
    required String model,
    required String brand,
    required String year,
    required String chassisNumber,
    required String driveLicense,
    required String vehicleRegistration,
    required String usageType,
  }) async {
    try {
      emit(VehicleLoading());

      print('Adding vehicle for owner: $owner'); // Debug log

      final response = await _vehicleApiService.addVehicle(
        owner: owner,
        registrationNumber: registrationNumber,
        model: model,
        brand: brand,
        year: year,
        usageType: usageType,
        chassisNumber: chassisNumber,
        driveLicense: driveLicense,
        vehicleRegistration: vehicleRegistration,
      );

      if (response['success'] == true) {
        final newVehicle = response['vehicle'];
        final newVehicleId = newVehicle['_id'] ?? newVehicle['id'];
        if (newVehicleId != null) {
          // Update local storage
          final currentIds = await VehicleStorage.getVehicleIds();
          if (!currentIds.contains(newVehicleId)) {
            currentIds.add(newVehicleId);
            await VehicleStorage.saveVehicleIds(currentIds);
          }
        }
        emit(VehicleSuccess(
            message: response['message'] ?? 'Vehicle added successfully'));
      } else {
        emit(VehicleFailure(
            error: response['error'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      print('VehicleCubit error: $e');
      emit(VehicleFailure(error: e.toString()));
    }
  }

  // Method to convert file to base64
  Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}
