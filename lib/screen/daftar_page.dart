import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapak_telu_crud/screen/login_page.dart';
import 'package:lapak_telu_crud/screen/notifikasi_page.dart';

class DaftarPage extends StatefulWidget {
  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  bool agreeToTerms = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  signUp() async {
    if (!agreeToTerms) {
      _showErrorDialog(
          'Anda harus menyetujui Kebijakan Privasi dan Ketentuan Layanan.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Password yang Anda masukkan tidak sama');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      NotificationService().showNotification(
          title: 'Selamat Datang',
          body:
              'Anda telah berhasil melakukan registrasi aplikasi Lapak Tel-U');
    } catch (e) {
      _showErrorDialog('Pesan : $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pendaftaran Gagal'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Color.fromARGB(255, 13, 162, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color.fromARGB(255, 13, 162, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                labelStyle: TextStyle(color: Color.fromARGB(255, 13, 162, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 13, 162, 255)),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreeToTerms = value!;
                    });
                  },
                ),
                Text('Setuju dengan '),
                GestureDetector(
                  onTap: () {
                    // Tindakan untuk membuka Kebijakan Privasi
                  },
                  child: Text(
                    'Privasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(' dan '),
                GestureDetector(
                  onTap: () {
                    // Tindakan untuk membuka Ketentuan Layanan
                  },
                  child: Text(
                    'Kebijakan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                signUp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 13, 162, 255),
                foregroundColor: Colors.white,
              ),
              child: Text('Daftar'),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun? '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    'Masuk Disini',
                    style: TextStyle(color: Color(0xFF3570D6)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.0),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('Dengan masuk atau mendaftar, saya menyetujui '),
                  GestureDetector(
                    onTap: () {
                      // Tindakan untuk membuka Kebijakan Privasi
                    },
                    child: Text(
                      'Kebijakan Privasi ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('dan '),
                  GestureDetector(
                    onTap: () {
                      // Tindakan untuk membuka Ketentuan Layanan
                    },
                    child: Text(
                      'Ketentuan dari Lapak Tel-U.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
