import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign-in method
  Future<UserCredential> signInwithEmailandPassword(
      String email, String password
      ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password,
          );

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthError(e.code));
    }
  }

  // Sign-up method
  Future<UserCredential> signUpwithEmailandPassword(
      String email, String password,String name,int index) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name':name,
        'index':index
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFirebaseAuthError(e.code));
    }
  }

  // Method to update name and image after signing up
Future<void> updateUserProfile(String name, int index) async {
  try {
    // Get the currently signed-in user
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // Update the user's Firestore document
      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': name,
        'index': index,
      });

      // Update the user's Firebase Authentication profile
      await currentUser.updateDisplayName(name);

      // Optionally reload the user to reflect changes
      await currentUser.reload();
    } else {
      throw Exception('No user is currently signed in.');
    }
  } catch (e) {
    throw Exception('Failed to update user profile: $e');
  }

}


  // Sign-out method
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Helper method to map FirebaseAuth errors to user-friendly messages
  String _getFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
