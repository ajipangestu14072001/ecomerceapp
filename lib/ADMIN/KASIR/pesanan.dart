import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller.dart';

class Pesanan extends StatefulWidget {
  const Pesanan({super.key});

  @override
  State<Pesanan> createState() => _PesananState();
}

final c = Get.put(Controllersr());

class _PesananState extends State<Pesanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: c.get_order_kasir(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
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
                      DateTime now =
                          DateTime.parse('${data[index]['tgl_order']}');
                      var formatter = DateFormat('dd-MM-yyyy');
                      var formatted = formatter.format(now);
                      return InkWell(
                        onTap: () {
                          Get.to(StrukPesanan(),
                              arguments: '${data[index].id}');
                        },
                        child: Card(
                          color: '${data[index]['selesai']}' == ''
                              ? Colors.white
                              : Color.fromARGB(255, 18, 117, 18),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'NAMA PEMESAN',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${data[index]['nama']}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TANGGAL PEMESANAN',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      formatted,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ALAMAT TUJUAN',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                        '${data[index]['alamat']}',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PROVINSI',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '${data[index]['kecamatan']+" (${data[index]['ongkir']})"}',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          c.update_pesanan('${data[index].id}');
                                        },
                                        child: Text(
                                          'tandai sebagai selesai',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(Get.width / 2.5, 45),
                                          primary: Colors.lightGreen,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          c.hapus_pesanan('${data[index].id}');
                                        },
                                        child: Text('hapus pesanan',
                                            style: TextStyle(fontSize: 10)),
                                        style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                Size(Get.width / 2.5, 45),
                                            backgroundColor: Colors.red),
                                      )
                                    ]),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.length);
              }
            }

            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 133, 1, 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StrukPesanan extends StatefulWidget {
  const StrukPesanan({super.key});

  @override
  State<StrukPesanan> createState() => _StrukPesananState();
}

class _StrukPesananState extends State<StrukPesanan> {
  void initState() {
    super.initState();
    refres();
  }

  void refres() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  int total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: c.get_order(Get.arguments.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              List count = data['id'];
              DateTime now = DateTime.parse('${data['tgl_order']}');
              var formatter = DateFormat('dd-MM-yyyy');
              var formatted = formatter.format(now);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Get.width,
                              child: Text(
                                'RINCIAN PESANAN',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            garis,
                            SizedBox(height: 20),
                            Text('NOMOR ORDER : ' '${data['tgl_order']}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),
                            Text('PELANGGAN : ' '${data['nama']}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),
                            Text('TANGGAL : ' '$formatted',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),
                              Text('STATUS : ''${data['status']}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 20),
                            Text('${data['take']}'.toUpperCase()+ ' JAM ${data['jam']}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400)),
                                    SizedBox(height: 10),
                          
                            garis,
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      width: double.maxFinite,
                                      child: Text('Qty Item',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      width: double.maxFinite,
                                      child: Text('Pcs',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.left),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700),
                                      ))
                                ],
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                              shrinkWrap: false,
                              physics: ScrollPhysics(
                                  parent: NeverScrollableScrollPhysics()),
                              itemBuilder: (context, index) {
                                total = total +
                                    int.parse('${data['total'][index]}');
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              width: double.maxFinite,
                                              child: Text(
                                                  '${data['nama_produk'][index]}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              width: double.maxFinite,
                                              child: Text(
                                                  '  x' +
                                                      ((int.parse(data['total']
                                                                      [index]) /
                                                                  int.parse(data[
                                                                          'harga']
                                                                      [index]))
                                                              .floor())
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.left),
                                            ),
                                          ),
                                          Flexible(
                                              flex: 1,
                                              child: Text(
                                                '${data['total'][index]}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              itemCount: count.length,
                            )),
                            SizedBox(height: 10),
                            garis,
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600)),
                                Text('Rp.' '$total',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: Get.width,
                              child: Text(
                                'PESENJAMA',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }),
    );
  }
}

var garis = SizedBox(
  height: 10,
  width: Get.width,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    shrinkWrap: false,
    physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          '=',
          style: TextStyle(color: Colors.grey),
        ),
      );
    },
    itemCount: 100,
  ),
);
