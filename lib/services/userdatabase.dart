import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({required this.uid});

  // Collection Refrence
  final CollectionReference userdatacollection =
      FirebaseFirestore.instance.collection('Userdata');

  // Update or add user data
  Future setUserData(String name, String email) async {
    return await userdatacollection.doc(uid).set({
      'name': name,
      'email': email,
      'description': 'No Description',
      'location': const GeoPoint(0, 0),
      'isServiceProvider': false,
      'isServiceProviderVerified': false,
      'points': 0,
      'request-id-list': [],
      'service-id-list': [],
    });
  }

  // Update name, email and description
  Future updateUserData(String name, String email, String description) async {
    return await userdatacollection.doc(uid).update({
      'name': name,
      'email': email,
      'description': description,
    });
  }

  // Change Location
  Future updateLocation(GeoPoint location) async {
    return await userdatacollection.doc(uid).update({
      'location': location,
    });
  }

  // Incrementing points
  Future incrementPoints(int points) async {
    return await userdatacollection.doc(uid).update({
      'points': FieldValue.increment(points),
    });
  }

  // Add request id to user data
  Future addRequestId(String requestId) async {
    return await userdatacollection.doc(uid).update({
      'request-id-list': FieldValue.arrayUnion([requestId])
    });
  }

  // Add service id to user data
  Future addServiceId(String serviceId) async {
    return await userdatacollection.doc(uid).update({
      'service-id-list': FieldValue.arrayUnion([serviceId])
    });
  }
}
