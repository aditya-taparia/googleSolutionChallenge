class Userdata {
  final String name;
  final String email;

  Userdata({required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
