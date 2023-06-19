import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../ADMIN/KASIR/pesanan.dart';
import '../VIEW/COSTUMER/auth/LoginScreen.dart';
import '../controller.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}
final c = Get.put(Controllersr());
int total = 0;
final List<String> dropdownItems = [
  'Log Out'
];
String? selectedDropdownItem;

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Icon(
        Icons.motorcycle,
        color: Colors.orange,
      ),
      title: Text(
        'Driver',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String item) {
              setState(() {
                selectedDropdownItem = item;
              });

              if (selectedDropdownItem == 'Log Out') {
                Get.to(LoginScreen());
              }
            },
            itemBuilder: (BuildContext context) {
              return dropdownItems.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        )
      ],
    ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: c.getOrderKurir(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 133, 1, 1),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Tidak ada produk'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                margin: EdgeInsets.all(50),
                child: Center(
                  child: Text(
                    "Tidak ada produk",
                    style: TextStyle(
                      color: Color.fromARGB(255, 135, 12, 3),
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }

            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                DateTime now = DateTime.parse('${data[index]['tgl_order']}');
                String buttonText = '${data[index]['driverStatus']}' == '' ? 'Antar Pesanan' : 'Sudah di Antar';
                var formatter = DateFormat('dd-MM-yyyy');
                var formatted = formatter.format(now);
                return InkWell(
                  onTap: () {
                    Get.to(StrukPesanan(), arguments: '${data[index].id}');
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NAMA PEMESAN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${data[index]['nama']}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TANGGAL PEMESANAN',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                formatted,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (buttonText == 'Antar Pesanan') {
                                    print("RUN 1");
                                    c.update_diver('${data[index].id}');
                                  } else if (buttonText == 'Sudah di Antar') {
                                    print("RUN 2");
                                    c.update_divernew('${data[index].id}');
                                  }
                                },
                                child: Text(
                                  '${data[index]['driverStatus']}' == '' ? 'Antar Pesanan' : 'Sudah di Antar',
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

                              // ElevatedButton(
                              //   onPressed: () {
                              //     c.hapus_pesanan('${data[index].id}');
                              //   },
                              //   child: Text('hapus pesanan',
                              //       style: TextStyle(fontSize: 10)),
                              //   style: ElevatedButton.styleFrom(
                              //     fixedSize: Size(Get.width / 2.5, 45),
                              //     backgroundColor: Colors.red,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

