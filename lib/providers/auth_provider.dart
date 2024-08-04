// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider1 extends ChangeNotifier {
  //?
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => currentUser != null;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  // Future<void> signUp(
  //   String email,
  //   String password,
  //   String name,
  //   String imageUrl,
  // ) async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   await _fireStore.collection('users').doc(userCredential.user!.uid).set({
  //     "uid": userCredential.user!.uid,
  //     "name": name,
  //     "email": email,
  //     "password": password,
  //     "imageUrl": imageUrl,
  //   });
  //   notifyListeners();
  // }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
