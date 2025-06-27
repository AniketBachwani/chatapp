// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String message;
  final String Name;
  // final String password;
  final String receiverId;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.senderEmail,
    required this.Name,
    required this.receiverId,
    required this.timestamp,
    // required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      // 'password': password,
      'senderEmail': senderEmail,
      'message': message,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'name': Name,
    };
  }
}
