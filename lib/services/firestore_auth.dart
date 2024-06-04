import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/home_screen.dart';
import 'package:lapak_telu_crud/screen/login_page.dart';

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

  static Future<Map<String, dynamic>?> readUser(String uid) async {
    try {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('akun').doc(uid).get();
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
      await FirebaseFirestore.instance.collection('akun').doc(uid).update(data);
      print('User updated successfully');
    } catch (error) {
      print('Failed to update user: $error');
    }
  }

  static Future<void> deleteUser(BuildContext context, String password) async {
    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Reautentikasi pengguna
        AuthCredential credential = EmailAuthProvider.credential(
          email: firebaseUser.email!,
          password: password,
        );
        await firebaseUser.reauthenticateWithCredential(credential);

        // Hapus akun pengguna dari Firebase Authentication
        await firebaseUser.delete();

        // Hapus data pengguna dari Firestore
        await FirebaseFirestore.instance
            .collection('akun')
            .doc(firebaseUser.uid)
            .delete();

        // Arahkan pengguna ke layar utama atau layar login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        print('Current user is null');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada pengguna yang aktif')),
        );
      }
    } catch (error) {
      print('Error deleting user: $error');
      // Tampilkan pesan error jika ada kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pengguna: $error')),
      );
    }
  }
}
