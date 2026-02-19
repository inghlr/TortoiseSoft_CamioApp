class RegisterRequest {
  final String name;
  final String lastName;
  final String country;
  final String phoneNumber;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.lastName,
    required this.country,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'lastname': lastName,
      'country': country,
      'phone_number': phoneNumber,
      'password': password,
    };
  }
}
