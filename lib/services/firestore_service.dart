import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<List<String>> readCategories() async {
    List<String> categories = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('kategori').get();
      querySnapshot.docs.forEach((doc) {
        dynamic categoryData = doc['kategori'];
        if (categoryData is List) {
          categories.addAll(categoryData.cast<String>());
        } else if (categoryData is String) {
          categories.add(categoryData);
        } else {
          print("Invalid data type for category: $categoryData");
        }
      });
    } catch (error) {
      print("Failed to fetch categories: $error");
    }
    return categories;
  }

  static Future<void> createData({
    required String namaProduk,
    required String deskripsiProduk,
    required String kategoriProduk,
    required String hargaProduk,
    required String stokProduk,
    required String? fotoProduk,
  }) async {
    try {
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('produk');
      await collRef.add({
        'namaProduk': namaProduk,
        'deskripsiProduk': deskripsiProduk,
        'kategoriProduk': kategoriProduk,
        'hargaProduk': hargaProduk,
        'stokProduk': stokProduk,
        'fotoProduk': fotoProduk,
      });
      print("Data uploaded successfully");
    } catch (error) {
      print("Failed to upload data: $error");
    }
  }

  static Future<List<Map<String, dynamic>>> readData() async {
    List<Map<String, dynamic>> products = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('produk').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
        products.add(productData);
      });
      print("Data read successfully: $products");
    } catch (error) {
      print("Failed to read data: $error");
    }
    return products;
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('produk')
        .doc(productId)
        .delete();
  }
}
