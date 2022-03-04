import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status, User user) async {
    await _firestore.collection('Userdata').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void addChatUser(String uid1, String uid2) async {
    await _firestore.collection('Userdata').doc(uid1).update({
      'chats': FieldValue.arrayUnion([uid2])
    });

    await _firestore.collection('Userdata').doc(uid2).update({
      'chats': FieldValue.arrayUnion([uid1])
    });
  }

  String chatRoomId(User user1, User user2) {
    addChatUser(user1.uid, user2.uid);
    if (user1.uid.toLowerCase().codeUnits[0] >
        user2.uid.toLowerCase().codeUnits[0]) {
      return "$user1.uid$user2.uid";
    } else {
      return "$user2.uid$user1.uid";
    }
  }

  void onSendMessage(TextEditingController _message, String ChatId) async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(ChatId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }
}
