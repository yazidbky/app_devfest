class Policy {
  final String id;
  final String status;
  final DateTime endDate;
  final String? policyNumber;
  final String? type;
  final double? premium;
  final String? coverage;
  final DateTime? startDate;
  final String? userId;

  Policy({
    required this.id,
    required this.status,
    required this.endDate,
    this.policyNumber,
    this.type,
    this.premium,
    this.coverage,
    this.startDate,
    this.userId,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['_id'] ?? json['id'] ?? '',
      status: json['status'] ?? '',
      endDate: DateTime.parse(json['endDate']),
      policyNumber: json['policyNumber'],
      type: json['type'],
      premium: json['premium']?.toDouble(),
      coverage: json['coverage'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'status': status,
      'endDate': endDate.toIso8601String(),
      'policyNumber': policyNumber,
      'type': type,
      'premium': premium,
      'coverage': coverage,
      'startDate': startDate?.toIso8601String(),
      'userId': userId,
    };
  }

  // Helper method to check if policy is expired
  bool get isExpired {
    return status == 'expired' ||
        (status == 'active' && DateTime.now().isAfter(endDate));
  }

  // Helper method to get days until expiration
  int get daysUntilExpiration {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  @override
  String toString() {
    return 'Policy(id: $id, status: $status, endDate: $endDate, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Policy && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
