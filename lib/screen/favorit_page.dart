import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/detail_produk_page.dart';
import 'package:lapak_telu_crud/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  _FavoritPageState createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  List<Map<String, dynamic>> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Map<String, dynamic>> products = await FirestoreService.readData();
      setState(() {
        displayedProducts = products;
      });
    } catch (error) {
      print("Failed to fetch products: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Favorit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: displayedProducts.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final productData = displayedProducts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        productData['fotoProduk'],
                        fit: BoxFit.cover,
                      ),
                      title: Text(productData['namaProduk']),
                      subtitle: Text("Rp ${productData['hargaProduk']}"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          final url = 'https://wa.me/';
                          launch(url);
                        },
                        child:
                            Text('Chat', style: TextStyle(color: Colors.blue)),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProdukPage(productData: productData),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
