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

  void addChatUser(Map sender, Map reciever) async {
    print(sender['recieverId'] + "1st print");
    print(reciever['recieverId'] + "2st print");
    await _firestore.collection('Userdata').doc(sender['recieverId']).set({
      'chat-id-list': [reciever]
    }, SetOptions(merge: true));
    // .update({
    //   'chat-id-list': FieldValue.arrayUnion([reciever])
    // });

    await _firestore.collection('Userdata').doc(reciever['recieverId']).set({
      'chat-id-list': [sender]
    }, SetOptions(merge: true));

    // await _firestore.collection('Userdata').doc(reciever['recieverId'])
    // .update({
    //   'chat-id-list': FieldValue.arrayUnion([sender])
    // });
  }

  String chatRoomId(String user1, String user2) {
    // addChatUser(user1, user2);
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSendMessage(TextEditingController _message, String ChatId) async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "senderId": _auth.currentUser!.uid,
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
