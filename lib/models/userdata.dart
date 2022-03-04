class Userdata {
  final String name;
  final String email;
  final List? chats;

  Userdata({required this.name, required this.email, this.chats});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'chats': chats};
  }
}
