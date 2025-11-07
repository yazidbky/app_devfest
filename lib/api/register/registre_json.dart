class User {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String? id;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
