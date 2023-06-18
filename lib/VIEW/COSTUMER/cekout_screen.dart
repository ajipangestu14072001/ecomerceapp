import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/history/HistoryScreen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/pdf/PdfHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller.dart';

class Cekout extends StatefulWidget {
  const Cekout({super.key});

  @override
  State<Cekout> createState() => _CekoutState();
}

final c = Get.put(Controllersr());

class _CekoutState extends State<Cekout> {
  var data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Detail"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'images/background_intro.png',
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(.2),
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: c.get_order(Get.arguments['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List count = data['nama_produk'];
                    print(count.length);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Rincian Pesanan',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Icon(Icons.shopping_bag,
                                          color: Colors.orange)
                                    ],
                                  ),
                                  SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("NAMA PEMESAN",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        data['nama'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("TANGGAL CEKOUT",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        DateFormat('dd-MM-yyyy')
                                            .format(
                                                DateTime.parse(data['tgl_order']))
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("METODE PEMBAYARAN",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        data['payment'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("NOMOR ORDER",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      SelectableText(
                                        Get.arguments['id'],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("TANGGAL ORDER",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      SelectableText(
                                        data['tgl_order'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                      SelectableText(
                                        data['status'].toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data['take'].toString().toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900)),
                                      Text(
                                        'JAM ' +
                                            data['jam'].toString().toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  garis,
                                  SizedBox(height: 20),
                                  SizedBox(
                                      width: Get.width,
                                      child: Text(
                                        'Menu yang di pesan',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.orange),
                                        textAlign: TextAlign.center,
                                      )),
                                  SizedBox(
                                      height: 150,
                                      width: Get.width,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      data['nama_produk'][index]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.5)),
                                                  Text(
                                                      'x ' +
                                                          ((int.parse(data['total'][index]) / int.parse(data['harga'][index]))
                                                                  .floor())
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          height: 1.5)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Get.width,
                                                child: Text(
                                                  'Rp.' +
                                                      data['total'][index]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              garis,
                                              SizedBox(height: 20)
                                            ],
                                          );
                                        },
                                        itemCount: count.length,
                                      )),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Pesanan',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      Text('Rp.' + 
                                            Get.arguments['totals'].toString(),
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  garis,
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () async{
                                      launchWhatsapp("6281345602416",Get.arguments['id']);
                                    },
                                    child: Text('WhatsApp'),
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(Get.width, 40),
                                        backgroundColor: Colors.orange),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                      'silahkan konfirmasi dengan menghubungi whatsapp ke nomor xxxxxx dengan mencantumkan nomor order anda',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                     createPDF(data);
                                    },
                                    child: Text('Lihat PDF'),
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(Get.width, 40),
                                        backgroundColor: Colors.orange),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.off(HistoryScreen());
                                    },
                                    child: Text('Kembali'),
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(Get.width, 40),
                                        backgroundColor: Colors.orange),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 133, 1, 1),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

var garis = Container(
  decoration: BoxDecoration(
      border:
          Border(bottom: BorderSide(color: Color.fromARGB(99, 158, 158, 158)))),
);

void launchWhatsapp(
    String phone,
    String message,
    ) async {
  final url = 'https://wa.me/$phone?text=$message';

  await launchUrlString(
    url,
    mode: LaunchMode.externalApplication,
  );
}




