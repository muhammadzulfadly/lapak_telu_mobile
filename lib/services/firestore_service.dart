import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<void> createProduk({
    required String namaProduk,
    required String deskripsiProduk,
    required String kategoriProduk,
    required String hargaProduk,
    required String stokProduk,
    required String? fotoProduk,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference collRef =
            FirebaseFirestore.instance.collection('produk');
        DocumentReference docRef = collRef.doc(); // Buat ID unik
        String produkId = docRef.id;

        await docRef.set({
          'id': produkId,
          'uid': user.uid,
          'namaProduk': namaProduk,
          'deskripsiProduk': deskripsiProduk,
          'kategoriProduk': kategoriProduk,
          'hargaProduk': hargaProduk,
          'stokProduk': stokProduk,
          'fotoProduk': fotoProduk,
        });
        print("Data uploaded successfully with ID: $produkId");
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Failed to upload data: $error");
    }
  }

  static Future<List<Map<String, dynamic>>> readProduk() async {
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

  static Future<void> soldProduk(String productId, String newName) async {
    try {
      await FirebaseFirestore.instance
          .collection('produk')
          .doc(productId)
          .update({'namaProduk': newName});
      print("Product name updated successfully");
    } catch (error) {
      print("Failed to update product name: $error");
    }
  }
}
