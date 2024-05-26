import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/login_page.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  LoginPage()),
              (route) => false)
        });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_lapak.png'),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                'Lapak Tel-U',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(
                      0xFF3570D6), // Menggunakan kode warna heksadesimal dengan format yang sesuai
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}