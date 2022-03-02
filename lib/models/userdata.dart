import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  final String name;
  final String email;
  final String description;
  final String points;
  final GeoPoint location;
  final List<String?> requests;
  final List<String?> services;
  final bool isServiceProvider;
  final bool isServiceProviderVerified;

  Userdata({
    required this.name,
    required this.email,
    required this.description,
    required this.points,
    required this.location,
    required this.requests,
    required this.services,
    required this.isServiceProvider,
    required this.isServiceProviderVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
