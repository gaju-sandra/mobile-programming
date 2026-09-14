class User {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  // Converts this object into a Map (JSON), which is what an API expects
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}