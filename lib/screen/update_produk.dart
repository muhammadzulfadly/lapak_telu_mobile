import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lapak_telu_crud/screen/toko_page.dart';
import 'package:lapak_telu_crud/services/firestore_service.dart';

class EditProdukPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  EditProdukPage({required this.productData});

  @override
  _EditProdukPageState createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String? _selectedCategory;
  final List<String> _categories = [];
  final namaProdukController = TextEditingController();
  final deskripsiProdukController = TextEditingController();
  final hargaProdukController = TextEditingController();
  final stokProdukController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirestoreService.readCategories().then((categories) {
      setState(() {
        _categories.addAll(categories);
      });
    });
    // Set initial values from productData
    namaProdukController.text = widget.productData['namaProduk'];
    deskripsiProdukController.text = widget.productData['deskripsiProduk'];
    hargaProdukController.text = widget.productData['hargaProduk'];
    stokProdukController.text = widget.productData['stokProduk'];
    _selectedCategory = widget.productData['kategoriProduk'];
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      print('Error occurred while picking image: $e');
      _showSnackBar('Error occurred while picking image');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _imagePreview() {
    return GestureDetector(
      onTap: () {
        _showImagePickerOptions();
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _image != null
            ? Image.file(File(_image!.path),
                fit: BoxFit.cover, width: double.infinity, height: 150)
            : widget.productData['fotoProduk'] != null
                ? Image.network(widget.productData['fotoProduk'],
                    fit: BoxFit.cover, width: double.infinity, height: 150)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_alt,
                          size: 50,
                          color: const Color.fromRGBO(117, 117, 117, 1)),
                      SizedBox(height: 8),
                      Text("Tap untuk upload foto",
                          style: TextStyle(color: Color(0xFF616161))),
                    ],
                  ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateData(String imageUrl) async {
    await FirestoreService.updateProduk(
      id: widget.productData['id'],
      namaProduk: namaProdukController.text,
      deskripsiProduk: deskripsiProdukController.text,
      kategoriProduk: _selectedCategory!,
      hargaProduk: hargaProdukController.text,
      stokProduk: stokProdukController.text,
      fotoProduk: imageUrl,
    );

    // Reset nilai untuk gambar yang dipilih
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Edit Produk",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // NAMA PRODUK
                Text(
                  "Nama Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: namaProdukController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Masukan nama produk",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama barang tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),

                // DESKRIPSI PRODUK
                Text(
                  "Deskripsi Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: deskripsiProdukController,
                    decoration: InputDecoration(
                      hintText: "Masukan deskripsi produk",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Deskripsi produk tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),

                // KATEGORI
                Text(
                  'Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text("Pilih Kategori Produk"),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                // HARGA
                Text(
                  'Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: hargaProdukController,
                    decoration: InputDecoration(
                      hintText: "Masukan Harga Produk",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Harga produk tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),

                // STOK
                Text(
                  'Stok',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: stokProdukController,
                    decoration: InputDecoration(
                      hintText: "Masukan Stok Produk",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Stok produk tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),

                // IMAGE UPLOAD
                Text(
                  "Foto Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                _imagePreview(),

                SizedBox(height: 20),

                // BUTTON SIMPAN
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? imageUrl = widget.productData['fotoProduk'];
                        if (_image != null) {
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref()
                              .child('images/${_image!.name}');
                          await ref.putFile(File(_image!.path));
                          imageUrl = await ref.getDownloadURL();
                        }
                        await updateData(imageUrl!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TokoPage(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
