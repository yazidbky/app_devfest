class Vehicle {
  final String? id; // Add this field for the vehicle ID
  final String owner;
  final String registrationNumber;
  final String model;
  final String brand;
  final String year;
  final String chassisNumber;
  final String driveLicense;
  final String vehicleRegistration;
  final String usageType;

  Vehicle({
    this.id,
    required this.owner,
    required this.registrationNumber,
    required this.model,
    required this.brand,
    required this.year,
    required this.chassisNumber,
    required this.driveLicense,
    required this.vehicleRegistration,
    required this.usageType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? json['id'], // Handle both _id and id fields
      owner: json['owner'] ?? '',
      registrationNumber: json['registrationNumber'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      year: json['year'] ?? '',
      chassisNumber: json['chassisNumber'] ?? '',
      driveLicense: json['driveLicense'] ?? '',
      vehicleRegistration: json['vehicleRegistration'] ?? '',
      usageType: json['usageType'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'owner': owner,
      'registrationNumber': registrationNumber,
      'model': model,
      'brand': brand,
      'year': year,
      'chassisNumber': chassisNumber,
      'driveLicense': driveLicense,
      'vehicleRegistration': vehicleRegistration,
      'usageType': usageType,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}
