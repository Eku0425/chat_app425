import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthService {
  AuthService._();

  static AuthService authService = AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create Account
  Future<void> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('User created successfully: $email');
    } on FirebaseAuthException catch (e) {
      log('Failed to create account: ${e.message}');
      Get.snackbar('Registration Problem', 'Account already register');
      rethrow; // Optionally, rethrow the error to handle it higher up in the call stack
    } catch (e) {
      log('An unexpected error occurred: $e');
      rethrow;
    }
  }

  // Login sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      log('User signed in successfully: $email');
      return "Success";
    } on FirebaseAuthException catch (e) {
      log('Failed to sign in: ${e.message}');
      rethrow; // Optionally, rethrow the error to handle it higher up in the call stack
    } catch (e) {
      log('An unexpected error occurred: $e');
      return e.toString();
    }
  }

  // Sign out
  Future<void> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      log('User signed out successfully');
    } catch (e) {
      log('Failed to sign out: $e');
      rethrow;
    }
  }

  // Get current user
  User? getCurrentUser() {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        log('Current user email: ${user.email}');
      }
      return user;
    } catch (e) {
      log('Failed to get current user: $e');
      return null;
    }
  }
}
