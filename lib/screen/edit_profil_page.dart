import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/profil_page.dart';
import 'package:lapak_telu_crud/services/firestore_auth.dart';

class EditProfilPage extends StatefulWidget {
  @override
  _EditProfilPageState createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      Map<String, dynamic>? data = await FirestoreAuth.readUser(user!.uid);
      if (data != null) {
        _namaController.text = data['nama'] ?? '';
        _alamatController.text = data['alamat'] ?? '';
        _teleponController.text = data['telepon'] ?? '';
      }
    }
  }

  Future<void> _editProfil() async {
    if (user != null) {
      await FirestoreAuth.updateUser(user!.uid, {
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'telepon': _teleponController.text,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _teleponController,
              decoration: InputDecoration(labelText: 'Telepon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editProfil,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
