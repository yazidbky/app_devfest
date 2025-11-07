import 'package:app_devfest/cubit/claim%20cubit/claim_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_devfest/api/claim/claim_api_service.dart';

class ClaimCubit extends Cubit<ClaimState> {
  final ClaimApiService _claimApiService = ClaimApiService();

  ClaimCubit() : super(ClaimInitial());

  Future<void> addClaim({
    required String user,
    required String vehicle,
    required String policy,
    required String description,
    required String date,
    required String location,
    required String wilaya,
    required String accidentType,
    required String vehicleStatus,
    required List<String> images,
  }) async {
    emit(ClaimLoading());

    try {
      final result = await _claimApiService.addClaim(
        user: user,
        vehicle: vehicle,
        policy: policy,
        description: description,
        date: date,
        location: location,
        wilaya: wilaya,
        accidentType: accidentType,
        vehicleStatus: vehicleStatus,
        images: images,
      );

      if (result['success'] == true) {
        emit(ClaimSuccess(
          result['message'] ?? 'Claim submitted successfully',
          claimData: result['claim'] ?? {}, // Provide default empty map
        ));
      } else {
        print('Claim submission failed: ${result['error']}');
        emit(ClaimFailure(result['error'] ?? 'Failed to submit claim'));
      }
    } catch (e) {
      print('Error during claim submission: $e');
      emit(ClaimFailure('An unexpected error occurred: $e'));
    }
  }

  void reset() {
    emit(ClaimInitial());
  }
}
