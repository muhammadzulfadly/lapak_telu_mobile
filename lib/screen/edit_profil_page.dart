import 'package:flutter/material.dart';

class EditProfilPage extends StatelessWidget {
  const EditProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Telepon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementasi fungsi untuk menyimpan perubahan profil
                // Misalnya: saveChanges();
                // Setelah itu bisa kembali ke halaman sebelumnya atau halaman profil
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
