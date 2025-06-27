// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'package:chatapp/FireBase/chat_service.dart';
import 'package:chatapp/model/Image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String reciverId;
  final String reciverEmail;
  final String reciverName;
  final int index;
  // final String password;

  const ChatPage({
    super.key,
    required this.reciverId,
    required this.reciverEmail, 
    required this.reciverName, 
    // required this.password,
    required this.index,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;

      // Clear the text field immediately
      _messageController.clear();

      // Send the message in the background
      await _chatService.sendMessage(messageText, widget.reciverId,widget.reciverName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 245, 238)),
        actions: [
          CircularImage(
                    imagePath: widget.index, // Path to your image
                    size: 50.0, // Adjust the size if needed
                  ),
        ],
        title: Text(
          widget.reciverName,
          style: const TextStyle(color: Color.fromARGB(255, 255, 245, 238)),
        ),
        backgroundColor: const Color.fromARGB(255, 178, 114, 77),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/wallpaper2.webp', // Your image path here
              fit: BoxFit.cover,
            ),
          ),

          // Chat UI (Messages and Input)
          Column(
            children: [
              // Messages List
              Expanded(
                child: _buildMessageList(),
              ),

              // User Input
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
          _firebaseAuth.currentUser!.uid, widget.reciverId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          reverse: true,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Padding(
            padding: (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                ? const EdgeInsets.only(left: 60)
                : const EdgeInsets.only(right: 60.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (data['senderEmail'] == _firebaseAuth.currentUser!.email)
                    ? const Color.fromARGB(255, 236, 196, 114)
                    : const Color.fromARGB(255, 219, 146, 105),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                data['message'],
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Container(
      color: const Color.fromARGB(255, 178, 114, 77),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter your message',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 245, 238)),
                    border: InputBorder.none,
                  ),
                  obscureText: false,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              color: Color.fromARGB(255, 255, 245, 238),
              Icons.send,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
