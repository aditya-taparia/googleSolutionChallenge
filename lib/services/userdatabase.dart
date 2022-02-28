import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({required this.uid});

  // Collection Refrence
  final CollectionReference userdatacollection =
      FirebaseFirestore.instance.collection('Userdata');

  // Update or add user data
  Future updateUserData(String name, String email) async {
    return await userdatacollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }
}
