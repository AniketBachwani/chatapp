import 'package:chatapp/model/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Send message method
  Future<void> sendMessage(String message, String receiverUid, String name) async {
    //get the current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new messgae
    Message newMessage = Message(
      Name: name,
      senderId: currentUserId,
      receiverId: receiverUid,
      message: message,
      // password: password,
      timestamp: timestamp,
      senderEmail: currentUserEmail,
    );

    //construct chat room id from current user id and reciver id(sorted to avoid  dupilcate)
    List<String> ids = [currentUserId, receiverUid];
    ids.sort();
    String chatRoomId = ids.join("-");

    //add new message to database
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get messages method
  Stream<QuerySnapshot> getMessages(String currentUserId, String receiverUid) {
    List<String> ids = [currentUserId, receiverUid];
    ids.sort();
    String chatRoomId = ids.join("-");

    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
