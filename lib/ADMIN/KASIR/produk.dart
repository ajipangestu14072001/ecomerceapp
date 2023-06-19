import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controller.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final c = Get.put(Controllersr());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: c.produk(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Container(
                      margin: EdgeInsets.all(50),
                      child: Center(
                        child: Text(
                          "tidak ada produk",
                          style: TextStyle(
                              color: Color.fromARGB(255, 135, 12, 3),
                              fontSize: 15),
                        ),
                      ));
                }
                var data = snapshot.data!.docs;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: Get.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network('${data[index]['image']}'),
                                SizedBox(height: 10),
                                Text('NAMA',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(
                                  width: Get.width,
                                  child: Text('${(data[index]['nama'])}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(height: 10),
                                Text('DESKRIPSI',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(
                                  width: Get.width,
                                  child: Text(
                                      '${(data[index]['deskripsi_produk'])}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(height: 10),
                                Text('HARGA',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(
                                  width: Get.width,
                                  child: Text('Rp.' '${(data[index]['harga'])}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(height: 10),
                                Text('TANGGAL DI BUAT',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(
                                  width: Get.width,
                                  child: Text('${(data[index]['time'])}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    c.hapus_produk('${data[index].id}',
                                        '${data[index]['image']}');
                                  },
                                  child: Text('Hapus Produk'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      fixedSize: Size(Get.width, 40)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: data.length,
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 133, 1, 1),
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Get.to(TambahProduk());
              },
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

final control = Get.put(Controllersr());

class _TambahProdukState extends State<TambahProduk> {
  TextEditingController nama = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController harga = TextEditingController();
  final keys = GlobalKey<FormState>();
  bool search = false;
  var gambar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:  
                Text('Tambahkan produk baru',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17)),
      ),
        body: Form(
      key: keys,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
               
                SizedBox(height: 30),
                Text(
                  "NAMA",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  controller: nama,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    hintText: 'nama produk',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'nama tidak boleh kosong';
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "DESKRIPSI",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextFormField(
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  controller: deskripsi,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    hintText: 'deskripsi',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'nama tidak boleh kosong';
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "HARGA",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextFormField(
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  controller: harga,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    hintText: 'harga',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                    filled: true,
                    fillColor: Color.fromARGB(255, 217, 217, 217),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'nama tidak boleh kosong';
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "FOTO",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.maxFinite,
                      child: Card(
                        color: Color.fromARGB(255, 223, 223, 223),
                        child: GetBuilder<Controllersr>(
                            init: Controllersr(),
                            builder: (c) => c.pickedImage != null
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                            image: FileImage(
                                              File(c.pickedImage!.path),
                                            ),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Tambahkan Foto",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 3, 3, 3)),
                                    ),
                                  )),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.maxFinite,
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: search == false
                              ? Icon(
                                  Icons.add_a_photo,
                                  color: Colors.orange,
                                )
                              : Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                          onPressed: () async {
                            search == false
                                ? control.selectedImageGalery()
                                : control.resetImage();
                            setState(() {
                              search = search ? false : true;
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (keys.currentState!.validate()) {
                      setState(() {});
                    }
                    if (control.pickedImage == null) {
                      print("kosong");
                    }
                    await control.uploadImage(nama.text).then((hasilImage) {
                      if (hasilImage != null) {
                        setState(() {
                          gambar = hasilImage;
                        });
                        control.tambah_produk(
                            deskripsi.text, harga.text, hasilImage, nama.text);
                        deskripsi.clear();
                        harga.clear();
                        nama.clear();
                      }
                    });
                  },
                  child: Text('tambahkan produk'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      fixedSize: Size(Get.width, 40)),
                )
              ]),
            ),
          ])),
    ));
  }
}
