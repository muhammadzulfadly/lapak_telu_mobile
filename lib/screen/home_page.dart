import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/detail_produk_page.dart';
import 'package:lapak_telu_crud/services/firestore_auth.dart';
import 'package:lapak_telu_crud/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> displayedProducts = [];
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Map<String, dynamic>> products = await FirestoreService.readProduk();
      List<Map<String, dynamic>> filteredProducts = products
          .where((productData) => productData['statusProduk'] == 'tersedia')
          .toList();
      setState(() {
        displayedProducts = filteredProducts;
      });
    } catch (error) {
      print("Failed to fetch products: $error");
    }
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      Map<String, dynamic>? data = await FirestoreAuth.readUser(user!.uid);
      setState(() {
        userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData != null)
                  Text(
                    userData!['nama'] ?? 'Nama tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (userData != null)
                  Text(
                    userData!['alamat'] ?? 'Alamat tidak tersedia',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                // Tambahkan aksi untuk notifikasi di sini
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bagian pencarian produk
                  Container(
                    margin: EdgeInsets.all(12),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Mau cari produk apa nii?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.all(1),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(Icons.filter_list),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Slide banner
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection:
                          Axis.horizontal, //memberikan scroll arahnya
                      children: [
                        Container(
                          width: 300,
                          margin: EdgeInsets.all(12),
                          child: Center(
                            child: Image.asset(
                              'assets/images/banner-1.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.all(12),
                          child: Center(
                            child: Image.asset(
                              'assets/images/banner-2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.all(12),
                          child: Center(
                            child: Image.asset(
                              'assets/images/banner-3.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Kategori
                  GridView.count(
                    shrinkWrap:
                        true, //supaya bisa menyesuaikan ukuran tata letaknya
                    crossAxisCount:
                        4, // untuk menemtukan jumlah item yg ditampilkan dalam satu baris/kolom
                    children: [
                      // Kategori pertama
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.shopping_basket,
                                size: 40, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Pakaian', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      // Kategori kedua
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.tv, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Elektronik', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      // Kategori ketiga
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.smartphone,
                                size: 40, color: Colors.orange),
                            SizedBox(height: 8),
                            Text('Smartphone', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      // Kategori keempat
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Icon(Icons.more_horiz,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Lainnya', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'PRODUK PILIHAN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Produk terbaru
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: displayedProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemBuilder: (context, index) {
                          final productData = displayedProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailProdukPage(
                                      productData: productData),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      productData['fotoProduk'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productData['namaProduk'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "\Rp ${productData['hargaProduk']}",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
