// // import 'package:chatting_app/login_page.dart';
// import 'package:chatapp/FireBase/auth_service.dart';
// import 'package:chatapp/FireBase/firebase_options.dart';
// import 'package:chatapp/Pages/name_page.dart';
// import 'package:chatapp/Pages/sign_up.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(ChangeNotifierProvider(create: (context) => AuthService()
//   ,child: const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(debugShowCheckedModeBanner: false,
//      home: 
//     //  NamePage()
//      SignUp()
//      );
//   }
// }
import 'package:chatapp/FireBase/auth_service.dart';
import 'package:chatapp/FireBase/fire_auth.dart';
import 'package:chatapp/FireBase/firebase_options.dart';
// import 'package:chatapp/Pages/auth_gate.dart';  // Import AuthGate
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(), // Use AuthGate here to handle authentication state
    );
  }
}

