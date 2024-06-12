import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapak_telu_crud/services/database_helper.dart';

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
        Timestamp createdAt = Timestamp.now();

        await docRef.set({
          'id': produkId,
          'uid': user.uid,
          'namaProduk': namaProduk,
          'deskripsiProduk': deskripsiProduk,
          'kategoriProduk': kategoriProduk,
          'hargaProduk': hargaProduk,
          'stokProduk': stokProduk,
          'fotoProduk': fotoProduk,
          'statusProduk': 'tersedia',
          'createdAt': createdAt
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

  static Future<void> updateProduk({
    required String id,
    required String namaProduk,
    required String deskripsiProduk,
    required String kategoriProduk,
    required String hargaProduk,
    required String stokProduk,
    required String? fotoProduk,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('produk').doc(id).update({
        'namaProduk': namaProduk,
        'deskripsiProduk': deskripsiProduk,
        'kategoriProduk': kategoriProduk,
        'hargaProduk': hargaProduk,
        'stokProduk': stokProduk,
        'fotoProduk': fotoProduk,
      });
      print("Product updated successfully");
    } catch (error) {
      print("Failed to update product: $error");
    }
  }

  static Future<void> soldProduk(String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('produk')
          .doc(productId)
          .get();

      if (productSnapshot.exists) {
        String currentName = productSnapshot['statusProduk'];
        // Cek apakah status produk sudah "sold"
        if (currentName == 'sold') {
          print("Product status is already 'sold' and cannot be changed");
          return;
        }
        await FirebaseFirestore.instance
            .collection('produk')
            .doc(productId)
            .update({'statusProduk': 'sold', 'namaProduk': '[SOLD]'});
        print("Product status updated successfully");
      } else {
        print("Product not found");
      }
    } catch (error) {
      print("Failed to update product status: $error");
    }
  }

  static Future<void> createFavorit(String productId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await DatabaseHelper.instance.createFavorite(user.uid, productId);
        print("Product saved to favorites successfully");
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Failed to save favorite: $error");
    }
  }

  static Future<List<Map<String, dynamic>>> readFavorit() async {
    List<Map<String, dynamic>> favoriteProducts = [];
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<Map<String, dynamic>> favorites =
            await DatabaseHelper.instance.readFavorites(user.uid);
        List<String> productIds =
            favorites.map((fav) => fav['product_id'].toString()).toList();

        // Mengambil data produk berdasarkan productId yang ada di daftar favorit
        for (String productId in productIds) {
          DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
              .collection('produk')
              .doc(productId)
              .get();
          if (productSnapshot.exists) {
            favoriteProducts
                .add(productSnapshot.data() as Map<String, dynamic>);
          }
        }
        print("Favorit products read successfully: $favoriteProducts");
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Failed to read favorite products: $error");
    }
    return favoriteProducts;
  }

  static Future<void> deleteFavorit(String productId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await DatabaseHelper.instance.deleteFavorite(user.uid, productId);
        print("Favorit berhasil dihapus");
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Gagal menghapus favorit: $error");
    }
  }
}
