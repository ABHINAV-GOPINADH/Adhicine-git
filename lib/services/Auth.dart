import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/homepage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context, String email, String password, String fname, String lname, int age, String sex) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'fname': fname,
          'lname': lname,
          'age': age,
          'sex': sex
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up successful! Please verify your email.')));
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'The email address is already in use';
          break;
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed';
          break;
        case 'weak-password':
          message = 'The password is too weak';
          break;
        default:
          message = 'An unknown error occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found for that email";
          break;
        case 'wrong-password':
          message = "Wrong password provided for that user";
          break;
        default:
          message = "Error: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Get current user
  User? getCurrentUser() {
    try {
      User? user = _auth.currentUser;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Fetch user data from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      return doc;
    } else {
      throw Exception("User not logged in");
    }
  }
}