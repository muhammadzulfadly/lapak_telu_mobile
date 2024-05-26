import 'package:flutter/material.dart';

import 'package:lapak_telu_crud/screen/eksplorasi_page.dart';
import 'package:lapak_telu_crud/screen/favorit_page.dart';
import 'package:lapak_telu_crud/screen/home_page.dart';
import 'package:lapak_telu_crud/screen/posting_page.dart';
import 'package:lapak_telu_crud/screen/profil_page.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  // Halaman-halaman yang ingin ditampilkan untuk setiap item BottomNavigationBar
  final List<Widget> _pages = [
    HomePage(),
    EksplorasiPage(),
    PostingProduk(),
    FavoritPage(),
    ProfilPage(),
  ];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar:  BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket),
                label: 'Eksplorasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box),
                label: 'Posting',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorit',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
     
    );
  }
}