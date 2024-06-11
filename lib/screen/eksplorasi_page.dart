import 'package:flutter/material.dart';
import 'package:lapak_telu_crud/screen/detail_produk_page.dart';
import 'package:lapak_telu_crud/services/firestore_service.dart';

class EksplorasiPage extends StatefulWidget {
  const EksplorasiPage({Key? key}) : super(key: key);

  @override
  _EksplorasiPageState createState() => _EksplorasiPageState();
}

class _EksplorasiPageState extends State<EksplorasiPage> {
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> displayedProducts = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int selectedCategoryIndex = -1;
  List<String> kategoriProduk = []; // Daftar kategori produk

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_search);
  }

  Future<void> _fetchProducts() async {
    try {
      List<Map<String, dynamic>> products = await FirestoreService.readProduk();
      List<Map<String, dynamic>> filteredProducts = products
          .where((productData) => productData['statusProduk'] == 'tersedia')
          .toList();
      setState(() {
        displayedProducts = filteredProducts;
        allProducts = filteredProducts;
        // Mengambil daftar kategori produk
        kategoriProduk = products
            .map((product) => product['kategoriProduk'] as String)
            .toSet()
            .toList();
      });
    } catch (error) {
      print("Failed to fetch products: $error");
    }
  }

  void _search() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      displayedProducts = allProducts
          .where((product) =>
              product['namaProduk'].toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      displayedProducts = allProducts
          .where((product) => product['kategoriProduk'] == category)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Eksplorasi",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            //
            // Search
            //
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.0, // Atur tinggi sesuai kebutuhan
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0), // Tambahkan ini jika diperlukan
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    color: Colors.blue,
                    onPressed: () {
                      // filter
                    },
                  ),
                ],
              ),
            ),

            //
            // Kategori
            //
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: SizedBox(
                height: 40.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kategoriProduk.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                          _filterByCategory(kategoriProduk[index]);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          color: selectedCategoryIndex == index
                              ? Colors.blue
                              : Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: Text(
                            kategoriProduk[index],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: selectedCategoryIndex == index
                                  ? Colors.white
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 8.0);
                  },
                ),
              ),
            ),
            //
            // PRODUK
            //
            Expanded(
              child: GridView.count(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData['namaProduk'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Rp ${productData['hargaProduk']}",
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
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
