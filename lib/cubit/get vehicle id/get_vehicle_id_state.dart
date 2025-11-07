import 'package:app_devfest/api/vehicle/vehicle_json.dart';

abstract class GetVehicleIdState {
  const GetVehicleIdState();
}

class GetVehicleIdInitial extends GetVehicleIdState {}

class GetVehicleIdLoading extends GetVehicleIdState {}

class GetVehicleIdLoaded extends GetVehicleIdState {
  final List<Vehicle> vehicles;
  final List<String> vehicleIds;

  const GetVehicleIdLoaded({required this.vehicles, required this.vehicleIds});
}

class GetVehicleIdError extends GetVehicleIdState {
  final String error;

  const GetVehicleIdError({required this.error});
}
