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

  static Future<void> createFavorit(String productId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference favoritesRef =
            FirebaseFirestore.instance.collection('favorit');

        await favoritesRef.add({'uid': user.uid, 'id': productId});

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
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('favorit')
            .where('uid', isEqualTo: user.uid)
            .get();
        List<String> productIds = [];
        querySnapshot.docs.forEach((doc) {
          productIds.add(doc['id']);
        });
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
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('favorit')
            .where('id', isEqualTo: productId)
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('favorit')
              .doc(querySnapshot.docs.first.id)
              .delete();
          print("Favorit berhasil dihapus");
        } else {
          print("Produk tidak ditemukan dalam daftar favorit");
        }
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Gagal menghapus favorit: $error");
    }
  }
}
