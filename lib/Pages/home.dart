import 'package:chatapp/Pages/Chat_Page.dart';
import 'package:chatapp/Pages/login_page.dart';
import 'package:chatapp/Pages/name_page.dart';
import 'package:chatapp/model/Image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/FireBase/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 245, 238)),
        backgroundColor: const Color.fromARGB(255, 178, 114, 77),
        leading: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Icon(Icons.error);
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    child: CircularImage(imagePath: data['index']),
                    onTap: () {
                      if (_auth.currentUser != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NamePage(
                                    email: _auth.currentUser!.email!,
                                    password: _passwordController.text,
                                  )),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),

        // flexibleSpace: CircularImage(imagePath: 5),
        title: const Center(
          child: Text(
            "Home Page",
            style: TextStyle(color: Color.fromARGB(255, 255, 245, 238)),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                //  Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => LoginPage()),
                //           ),y
                signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  /// This method is used to build the list of users
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          ),
        );
      },
    );
  }

  /// This method is used to build a user list item
  Widget _buildUserListItem(
    DocumentSnapshot doc,
  ) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.displayName != data['name'] &&
        data['name'] != null) {
      return ListTile(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(255, 232, 177, 145),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircularImage(
                  imagePath: data['index'],
                  size: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(data['name'],
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                // password: data['password'],
                reciverId: data['uid'],
                reciverEmail: data['email'],
                reciverName: data['name'],
                index: data['index'] ?? 0,
              ),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
