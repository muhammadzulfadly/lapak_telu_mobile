import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/edit_profil_page.dart';
import 'package:lapak_telu_crud/screen/login_page.dart';
import 'package:lapak_telu_crud/screen/toko_page.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Profil",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/logo_lapak.png'),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          user?.displayName ?? 'Muhammad Zulfadly',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(user?.email ?? 'Email tidak tersedia'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TokoPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Lihat Toko Anda'),
                      Spacer(),
                      Icon(Icons.arrow_forward, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilPage()),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text('Edit Profil'),
                      Spacer(),
                      Icon(Icons.arrow_forward, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(
                          'Apakah Anda yakin ingin keluar dari akun Anda?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal',
                              style: TextStyle(color: Colors.black54)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Tutup dialog konfirmasi
                            signOut(context); // Panggil fungsi sign out
                          },
                          child: Text(
                            'Keluar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Keluar Akun'),
                      Spacer(),
                      Icon(Icons.arrow_forward, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
