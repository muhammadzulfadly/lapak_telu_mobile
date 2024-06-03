import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:lapak_telu_crud/services/firestore_service.dart';

class PostingProduk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posting produk page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt,
                      size: 50, color: const Color.fromRGBO(117, 117, 117, 1)),
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

  void addData(String imageUrl) {
    FirestoreService.createProduk(
      namaProduk: namaProdukController.text,
      deskripsiProduk: deskripsiProdukController.text,
      kategoriProduk: _selectedCategory!,
      hargaProduk: hargaProdukController.text,
      stokProduk: stokProdukController.text,
      fotoProduk: imageUrl,
    );
    // Setelah mengunggah produk, kosongkan nilai di dalam TextField
    namaProdukController.clear();
    deskripsiProdukController.clear();
    hargaProdukController.clear();
    stokProdukController.clear();

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
            "Posting Produk",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), // Hanya memperbolehkan angka
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Harga produk tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),

                // STOK PRODUK
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
                      hintText: "Jumlah produk",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), // Hanya memperbolehkan angka
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Stok produk tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),

                // Preview Gambar
                InkWell(
                  onTap: () {
                    _showImagePickerOptions();
                  },
                  child: _imagePreview(),
                ),

                // Tombol Validasi Data
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_image != null) {
                              final String fileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              final firebase_storage.Reference ref =
                                  firebase_storage.FirebaseStorage.instance
                                      .ref()
                                      .child('images')
                                      .child(fileName);
                              final File file = File(_image!.path);
                              await ref.putFile(file);
                              final String imageUrl =
                                  await ref.getDownloadURL();
                              addData(imageUrl);
                            } else {
                              addData("");
                            }
                            _showSnackBar("Berhasil menyimpan");
                          }
                        },
                        child: Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
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
