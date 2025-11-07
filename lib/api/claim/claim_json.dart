class Claim {
  final String? id;
  final String user;
  final String vehicle;
  final String policy;
  final String description;
  final String date;
  final String location;
  final String wilaya;
  final String accidentType;
  final String vehicleStatus;
  final List<String> images;
  final String? status;

  Claim({
    this.id,
    required this.user,
    required this.vehicle,
    required this.policy,
    required this.description,
    required this.date,
    required this.location,
    required this.wilaya,
    required this.accidentType,
    required this.vehicleStatus,
    required this.images,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'vehicle': vehicle,
      'policy': policy,
      'description': description,
      'date': date,
      'location': location,
      'wilaya': wilaya,
      'accidentType': accidentType,
      'VehicleStatus': vehicleStatus,
      'images': images,
      if (status != null) 'status': status,
    };
  }

  factory Claim.fromMap(Map<String, dynamic> map) {
    return Claim(
      id: map['_id'] ?? map['id'],
      user: map['user'] ?? '',
      vehicle: map['vehicle'] ?? '',
      policy: map['policy'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      location: map['location'] ?? '',
      wilaya: map['wilaya'] ?? '',
      accidentType: map['accidentType'] ?? '',
      vehicleStatus: map['VehicleStatus'] ?? map['vehicleStatus'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      status: map['status'],
    );
  }
}
