import 'package:app_devfest/api/get%20vehicle%20by%20user/get_vehicle_byuser.dart';
import 'package:app_devfest/api/vehicle/vehicle_json.dart';
import 'package:app_devfest/cubit/get%20vehicle%20id/get_vehicle_id_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetVehicleIdCubit extends Cubit<GetVehicleIdState> {
  final GetVehicleByUser _vehicleService;
  String? _currentUserId; // Track the current user ID

  GetVehicleIdCubit(this._vehicleService) : super(GetVehicleIdInitial());

  Future<void> fetchUserVehicles(String userId) async {
    _currentUserId = userId; // Store the user ID
    emit(GetVehicleIdLoading());

    try {
      final response = await _vehicleService.getUserVehicles(userId: userId);

      if (response['success'] == true) {
        final vehicles = response['vehicles'] as List<Vehicle>;
        final vehicleIds = response['vehicleIds'] as List<String>;
        emit(GetVehicleIdLoaded(vehicles: vehicles, vehicleIds: vehicleIds));
      } else {
        emit(GetVehicleIdError(
            error: response['error'] ?? 'Failed to fetch vehicles'));
      }
    } catch (e) {
      emit(GetVehicleIdError(error: e.toString()));
    }
  }

  // Add this new method to refresh the vehicle list
  Future<void> refreshVehicles() async {
    if (_currentUserId != null) {
      await fetchUserVehicles(_currentUserId!);
    }
  }

  void clearVehicles() {
    emit(GetVehicleIdInitial());
  }
}
