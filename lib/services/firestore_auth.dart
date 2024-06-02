import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/home_screen.dart';

class FirestoreAuth {
  static Future<void> createUser(user, context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(firebaseUser.uid)
          .set({'email': user.email, 'uid': user.uid})
          .then((value) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen())))
          .catchError((e) {
            print(e);
          });
    } else {
      print('Current user is null');
    }
  }

  static Future<void> readLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      print(
        "$error",
      );
    }
  }

  static Future<Map<String, dynamic>?> readUser(String uid) async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('akun')
          .doc(uid)
          .get();
      if (userData.exists) {
        return userData.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (error) {
      print("Error getting user data: $error");
      return null;
    }
  }

  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('akun')
          .doc(uid)
          .update(data);
      print('User updated successfully');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

}



