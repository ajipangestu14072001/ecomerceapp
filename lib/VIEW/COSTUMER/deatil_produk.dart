import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/user.dart';
import 'package:ecomerceapp/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProduk extends StatefulWidget {
  const DetailProduk({super.key});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

final c = Get.put(Controllersr());

class _DetailProdukState extends State<DetailProduk> {
  RxInt jumlah = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: c.get_detail_produk(Get.arguments.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>;
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(3, 4),
                                              blurRadius: 10)
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Colors.black,
                                        size: 28,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: Get.height / 3,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data['image']))),
                            ),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data['nama'],
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            child: Row(
                                          children: <Widget>[
                                            Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (jumlah.toInt() == 1) {
                                                    } else {
                                                      jumlah(
                                                          jumlah.value.toInt() -
                                                              1);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.red),
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )),
                                            Container(
                                              color: Colors.grey[200],
                                              width: 48,
                                              height: 48,
                                              child: Center(
                                                child: Obx(
                                                  () => Text(
                                                    (jumlah.value).toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15),
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    jumlah(
                                                        jumlah.value.toInt() +
                                                            1);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.red),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        )),
                                        Container(
                                            child: Text(
                                          'Rp.' + data['harga'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              "Product description",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              data['deskripsi_produk'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            child: Obx(
                                              () => Text(
                                                'Total : ' +
                                                    (int.parse(
                                                              data['harga'],
                                                            ) *
                                                            jumlah.toInt())
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              c.isLoading(true);
                                              Future.delayed(
                                                  Duration(seconds: 3),
                                                  () async {
                                                c.isLoading(false);
                                                var total = await (int.parse(
                                                          data['harga'],
                                                        ) *
                                                        jumlah.toInt())
                                                    .toString();

                                                c.tambah_ketroll(
                                                  data['nama'],
                                                  data['image'],
                                                  data['deskripsi_produk'],
                                                  Get.arguments.toString(),
                                                  jumlah.toString(),
                                                  data['harga'],
                                                  total,
                                                );
                                                Get.defaultDialog(
                                                  title: "BERHASIL",
                                                  titleStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black,
                                                  ),
                                                  content: Text(
                                                    data['nama'] +
                                                        ' di tambahkan ke keranjang',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onConfirm: () {
                                                    Get.back();
                                                  },
                                                buttonColor: Colors.orange,
                                                confirmTextColor: Colors.white
                                                 
                                                );
                                              });
                                            },
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(3, 4),
                                                      blurRadius: 10)
                                                ],
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text("Tambah Keranjang",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => c.isLoading.isTrue
                          ? Container(
                              height: Get.height,
                              width: Get.width,
                              color: Color.fromARGB(94, 0, 0, 0),
                              child: Center(child: CircularProgressIndicator(color: Colors.white,)),
                            )
                          : Container(),
                    )
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 133, 1, 1),
                ),
              );
            }));
  }
}
