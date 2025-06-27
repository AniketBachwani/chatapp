import 'package:chatapp/FireBase/auth_service.dart';
import 'package:chatapp/Pages/home.dart';
import 'package:chatapp/Pages/sign_up.dart';
import 'package:chatapp/model/Image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/FireBase/auth_service.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NamePage extends StatefulWidget {
  String email;
  String password;
  NamePage({super.key, required this.email, required this.password});
  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  // late TextEditingController _nameController;

  PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      backgroundColor: const Color.fromARGB(255, 178, 114, 77),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 178, 114, 77),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 255, 245, 238)),
        title:  const Text(
          ' Name Page ',
          style: TextStyle(color: Color.fromARGB(255, 255, 245, 238)),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                )),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Your Name \nAnd Choose Profile Pic",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 245, 238)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 300, // Set a fixed height for the PageView
              child: PageView.builder(
                controller: _pageController,
                itemCount: null, // Infinite scroll
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index % AddImage.length;
                  });
                },
                itemBuilder: (context, int index) {
                  int currentIndex = index % AddImage.length; // Circular index
                  double scale = _currentIndex == currentIndex ? 1.2 : 0.9;

                  return Column(
                    children: [
                      Transform.scale(
                        scale: scale,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ), // Circular border

                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: ClipOval(
                                  child: Image.asset(
                                    AddImage[currentIndex],
                                    fit: BoxFit.cover,
                                    height: 250,
                                    width: 250,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black),
                              // labelText: ' Enter Your Name ',
                              hintText: 'Enter Your Name',
                              hintStyle: TextStyle(color: Colors.black,fontSize: 15),
                              labelStyle: TextStyle(
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' *Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              // onPress: () async {
              //   if (_nameController.text.isNotEmpty) {
              //     // await Future.delayed(
              //     //   const Duration(milliseconds: 440),
              //     // );
              //     // Ensure passwords match
              //     if (_formKey.currentState!.validate()) {
              //       final authService =
              //           Provider.of<AuthService>(context, listen: false);

              //       try {
              //         // Call the sign-up method
              //         await authService.signUpwithEmailandPassword(
              //           widget.email,
              //           widget.password,
              //           _nameController.text,
              //           _currentIndex,
              //         );

              //         // Navigate to the login page or home page after successful sign-up
              //         Navigator.pushReplacement(
              //           context,
              //           MaterialPageRoute(builder: (context) => const HomePage()),
              //         );
              //       } catch (e) {
              //         // Display the error message in a SnackBar
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(content: Text(e.toString())),
              //         );
              //       }
              onPress: () async {
  if (_nameController.text.isNotEmpty) {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        // Check if the user already exists
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          // If user does not exist, sign up (create new account)
          await authService.signUpwithEmailandPassword(
            widget.email,
            widget.password,
            _nameController.text,
            _currentIndex,
          );

          // Navigate to home page after successful sign-up
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          
          // If user exists, update their profile
          await authService.updateUserProfile(_nameController.text, _currentIndex);

          // Navigate to home page after updating the profile
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (e) {
        // Display the error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
},

                  // }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HomePage(),
                  //   ),
                  // );
                // }
              // },
              height: 70,
              width: 200,
              text: 'Let\'s Go',
              isReverse: true,
              selectedTextColor: Colors.black,
              transitionType: TransitionType.LEFT_BOTTOM_ROUNDER,
              backgroundColor: Colors.black,
              selectedBackgroundColor: const Color.fromARGB(255, 236, 196, 114),
              borderColor: const Color.fromARGB(255, 236, 196, 114),
              borderRadius: 50,
              borderWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}
