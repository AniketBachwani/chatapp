// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/FireBase/auth_service.dart';
import 'package:chatapp/Pages/home.dart';
import 'package:chatapp/Pages/login_page.dart';
import 'package:chatapp/Pages/name_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 178, 114, 77),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //logo
              Image.asset('assets/download-removebg-preview.png'),

              //welcome back message
              const Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 20),
                child: Text("Let's create an account for you!",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
              ),

              //email textfeild
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
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.black),
                                labelText:
                                    ' Enter your email (example@gamil.com) ',
                                border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' *Please enter some text';
                              } else if (!value.contains('@')) {
                                return ' *Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //password textfeild

                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.black),
                                labelText: ' Enter your password ',
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' *Please enter some text';
                              } else if (value.length < 6) {
                                return ' *Password must be atleat 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //password textfeild

                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextFormField(
                            controller: _confirmpasswordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.black),
                                labelText: ' Confirm password ',
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' *Please enter some text';
                              } else if (value != _passwordController.text) {
                                return ' *Password does not match';
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
              ElevatedButton(
                onPressed: () async {
                  // Ensure passwords match
                  if (_formKey.currentState!.validate()) {
                    if (_passwordController.text !=
                        _confirmpasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    // final authService =
                    //     Provider.of<AuthService>(context, listen: false);
                    // try {
                    //   // Call the sign-up method
                    //   await authService.signUpwithEmailandPassword(
                    //     _emailController.text,
                    //     _passwordController.text,
                    //   );

                      // Navigate to the login page or home page after successful sign-up
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NamePage(email: _emailController.text, password: _passwordController.text)),
                      );
                    // } catch (e) {
                    //   // Display the error message in a SnackBar
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text(e.toString())),
                    //   );
                    // }
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 50),
                  backgroundColor: const Color.fromARGB(255, 255, 233, 186),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Sign Up"),
              ),

              //sgin in button
              // ElevatedButton(
              //   onPressed: () async {
              //     if (_passwordController.text !=
              //         _confirmpasswordController.text) {
              //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //           content: Text("passwords do not match")));
              //       return;
              //     }
              //     final authService =
              //         Provider.of<AuthService>(context, listen: false);
              //     try {
              //       await authService.signInwithEmailandPassword(
              //           _emailController.text, _passwordController.text);
              //     } catch (e) {
              //       // ignore: use_build_context_synchronously
              //       ScaffoldMessenger.of(context)
              //           .showSnackBar(SnackBar(content: Text(e.toString())));
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //       fixedSize: const Size(250, 50),
              //       backgroundColor: const Color.fromARGB(255, 255, 233, 186),
              //       foregroundColor: Colors.black,
              //       textStyle: const TextStyle(fontSize: 18)),
              //   child: const Text("Sgin Up"),
              // ),

              const SizedBox(height: 10),
              //not a member? sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member?"),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
