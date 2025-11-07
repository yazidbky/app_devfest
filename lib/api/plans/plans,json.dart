class InsurancePlan {
  final String title;
  final String insuranceType;
  final int duration;
  final String description;
  final int price;

  InsurancePlan({
    required this.title,
    required this.insuranceType,
    required this.duration,
    required this.description,
    required this.price,
  });

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      title: json['title']?.toString() ?? 'Unnamed Plan',
      insuranceType: json['insuranceType']?.toString() ?? 'Unknown',
      duration: _safeInt(json['duration']),
      description: json['description']?.toString() ?? '',
      price: _safeInt(json['price']),
    );
  }

  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
