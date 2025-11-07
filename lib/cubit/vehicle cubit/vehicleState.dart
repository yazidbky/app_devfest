abstract class VehicleState {
  const VehicleState();
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleSuccess extends VehicleState {
  final String message;
  const VehicleSuccess({required this.message});
}

class VehicleFailure extends VehicleState {
  final String error;
  const VehicleFailure({required this.error});
}
