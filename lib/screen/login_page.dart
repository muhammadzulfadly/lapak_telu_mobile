import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/daftar_page.dart';
import 'package:lapak_telu_crud/screen/home_screen.dart';
import 'package:lapak_telu_crud/screen/lupa_password.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Jika login berhasil, pengguna akan diarahkan ke MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      _showErrorDialog("Username atau password salah. Silakan coba lagi.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
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
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return buildLoginForm();
          }
        },
      ),
    );
  }

  Widget buildLoginForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            // Form Login
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 13, 162, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 13, 162, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 13, 162, 255)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 13, 162, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 13, 162, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 13, 162, 255)),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LupaPassword()),
                  );
                },
                child: const Text(
                  'Lupa password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3570D6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 30.0),
            const Center(
              child: Text('Belum punya akun?'),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DaftarPage()),
                  );
                },
                child: const Text(
                  'Daftar Disini',
                  style: TextStyle(
                    color: Color(0xFF3570D6), // Ubah warna teks jika diinginkan
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
