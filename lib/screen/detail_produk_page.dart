import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class DetailProdukPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  DetailProdukPage({Key? key, required this.productData}) : super(key: key);

  @override
  _DetailProdukPageState createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  bool isLiked = false; // Variabel untuk melacak status like produk

  @override
  Widget build(BuildContext context) {
    final productData = widget.productData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: Image.network(productData['fotoProduk']),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData['namaProduk'],
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            'Rp${productData['hargaProduk']}',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Bagikan Produk"),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            final url =
                                                'https://lapak-telu.com/produk/${productData['namaProduk']}';
                                            FlutterClipboard.copy(url).then(
                                              (value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Link berhasil disalin'),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/images/icon-link.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final url = 'https://wa.me/';
                                            launch(url);
                                          },
                                          child: Image.asset(
                                            'assets/images/icon-whatsapp.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final url =
                                                'https://www.instagram.com';
                                            launch(url);
                                          },
                                          child: Image.asset(
                                            'assets/images/icon-instagram.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            final url =
                                                'https://www.facebook.com/';
                                            launch(url);
                                          },
                                          child: Image.asset(
                                            'assets/images/icon-facebook.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Detail',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Stok',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 102),
                          Text(
                            '${productData['stokProduk']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        productData['deskripsiProduk'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/images/logo_lapak.png'),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Muhammad Zulfadly'),
                              Text('Buah Batu'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    width: double.infinity,
                    height: 37,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Aksi ketika tombol ditekan
                      },
                      child: const Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
