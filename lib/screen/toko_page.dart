import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/detail_produk_page.dart';
import 'package:lapak_telu_crud/screen/update_produk.dart';
import 'package:lapak_telu_crud/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokoPage extends StatefulWidget {
  const TokoPage({Key? key}) : super(key: key);

  @override
  _TokoPageState createState() => _TokoPageState();
}

class _TokoPageState extends State<TokoPage> {
  List<Map<String, dynamic>> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      // Get current user's UID
      String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      // Read products from Firestore
      List<Map<String, dynamic>> products = await FirestoreService.readProduk();

      // Filter products to display only those sold by the current user
      List<Map<String, dynamic>> filteredProducts = products
          .where((productData) => productData['uid'] == currentUserUid)
          .toList();

      setState(() {
        displayedProducts = filteredProducts;
      });
    } catch (error) {
      print("Failed to fetch products: $error");
    }
  }

  Future<void> _soldProduct(String productId, String productName) async {
    try {
      // Tambahkan kata "[SOLD]" pada nama produk sebelum menghapusnya dari Firestore
      await FirestoreService.soldProduk(productId, "[SOLD] $productName");
      Navigator.pop(context);
    } catch (error) {
      print("Failed to delete product: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toko Anda",
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
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Expanded(
              child: displayedProducts.isEmpty
                  ? Center(
                      child: Text('Anda belum memiliki produk yang dijual'),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      padding: EdgeInsets.all(12.0),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: displayedProducts.map((productData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailProdukPage(productData: productData),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.sell_sharp,
                                                color: Colors
                                                    .red), // Menggunakan ikon sold_out dari library Icons
                                            onPressed: () {
                                              _soldProduct(productData['id'],
                                                  productData['namaProduk']);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Colors
                                                    .blue), // Menggunakan ikon sold_out dari library Icons
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProdukPage(
                                                          productData:
                                                              productData),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
