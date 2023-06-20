import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/deatil_produk.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/util/Province.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});

  @override
  State<Keranjang> createState() => _KeranjangState();
}

final c = Get.put(Controllersr());

class _KeranjangState extends State<Keranjang> {
  TextEditingController nama = TextEditingController();
  TextEditingController alamat = TextEditingController();
  RxInt jumlah = 1.obs;
  List cekout = [].obs;
  List namap = [].obs;
  List harga = [].obs;
  List totalharga = [].obs;
  RxInt total = 0.obs;
  late String userId;


  void getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');
    setState(() {
      userId = storedUserId ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserIdFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 28,
              )),
        ),
        title: Text(
          "Keranjang",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: c.get_keranjang(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Container(
                        margin: EdgeInsets.all(50),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/search.png'),
                              SizedBox(height: 10),
                              Text(
                                "tidak ada produk ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 135, 12, 3),
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ));
                  }
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 55),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(DetailProduk(),
                              arguments: '${data[index]['produk_id']}');
                        },
                        child: SizedBox(
                            height: 160,
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        '${data[index]['image']}',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${data[index]['nama_produk']}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (cekout.contains(
                                                        '${data[index].id}')) {
                                                    } else {
                                                      c.delete_keranjang(
                                                          '${data[index].id}');
                                                      if (total.value == 0) {
                                                      } else {
                                                        total(total.value -
                                                            int.parse(
                                                                '${data[index]['total']}'));
                                                      }
                                                    }
                                                    ;
                                                  },
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.orange))
                                            ],
                                          ),
                                          Text(
                                            'Rp.' +
                                                (int.parse('${data[index]['harga']}') *
                                                        int.parse(
                                                            '${data[index]['jumlah']}'))
                                                    .toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 120,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4,
                                                                left: 4),
                                                        child: InkWell(
                                                            onTap: () {
                                                              if (cekout.contains(
                                                                  '${data[index].id}')) {
                                                              } else {
                                                                if (int.parse(
                                                                        '${data[index]['jumlah']}') ==
                                                                    1) {
                                                                } else {
                                                                  c.update_jumlah_produk(
                                                                    '${data[index].id}',
                                                                    (int.parse('${data[index]['jumlah']}') -
                                                                            jumlah.value)
                                                                        .toString(),
                                                                    (int.parse('${data[index]['total']}') -
                                                                            (int.parse('${data[index]['harga']}')))
                                                                        .toString(),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            child: Image.asset(
                                                                'images/minus.png')),
                                                      ),
                                                      Text(
                                                        '${data[index]['jumlah']}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5,
                                                                right: 4),
                                                        child: InkWell(
                                                            onTap: () {
                                                              if (cekout.contains(
                                                                  '${data[index].id}')) {
                                                              } else {
                                                                c.update_jumlah_produk(
                                                                  '${data[index].id}',
                                                                  (int.parse('${data[index]['jumlah']}') +
                                                                          jumlah
                                                                              .value)
                                                                      .toString(),
                                                                  (int.parse('${data[index]['harga']}') *
                                                                          (int.parse('${data[index]['jumlah']}') +
                                                                              jumlah.value))
                                                                      .toString(),
                                                                );
                                                              }
                                                            },
                                                            child: Image.asset(
                                                                'images/plus.png')),
                                                      )
                                                    ]),
                                              ),
                                              Obx(
                                                () => Checkbox(
                                                    value: cekout.contains(
                                                            '${data[index].id}')
                                                        ? true
                                                        : false,
                                                    onChanged: (value) {
                                                      if (value == true) {
                                                        cekout.add(
                                                            '${data[index].id}');
                                                        if (cekout.contains(
                                                            '${data[index].id}')) {
                                                          total(total.value +
                                                              int.parse(
                                                                  '${data[index]['total']}'));
                                                          namap.add(
                                                              '${data[index]['nama_produk']}');
                                                          totalharga.add(
                                                              '${data[index]['total']}');
                                                          harga.add(
                                                              '${data[index]['harga']}');
                                                          print(cekout);
                                                          print(harga);
                                                        }
                                                      } else {
                                                        cekout.remove(
                                                            '${data[index].id}');
                                                        total(total.value -
                                                            int.parse(
                                                                '${data[index]['total']}'));
                                                        namap.remove(
                                                            '${data[index]['nama_produk']}');
                                                        totalharga.remove(
                                                            '${data[index]['total']}');
                                                        harga.remove(
                                                            '${data[index]['harga']}');
                                                        print(harga);
                                                      }
                                                      print(total);
                                                    }),
                                              )
                                            ],
                                          )
                                        ])),
                                  ]),
                                ),
                              ),
                            )),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => Text(
                        'Total : Rp.' + total.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (total.value != 0) {
                      RxString takeAway = 'DineIn'.obs;
                      RxString metodePembayaran = 'COD'.obs;
                      RxBool isDropdownVisible = false.obs;
                      Get.bottomSheet(
                        isScrollControlled: true,
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          height: 470,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list,
                                    color: Colors.orange,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Masukan nama anda untuk melanjutkan cekout',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: nama,
                                decoration: InputDecoration(
                                  hintText: 'Nama Pemesan',
                                  hintStyle: TextStyle(fontSize: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(10),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: 24.0, right: 16.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                        value: 'DineIn',
                                        groupValue: takeAway.value,
                                        onChanged: (value) {
                                          takeAway.value = value!;
                                          isDropdownVisible.value = false;
                                        },
                                        title: Text(
                                          'DineIn',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                        value: 'TakeAway',
                                        groupValue: takeAway.value,
                                        onChanged: (value) {
                                          takeAway.value = value!;
                                          isDropdownVisible.value = false;
                                        },
                                        title: Text(
                                          'TakeAway',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                        value: 'Delivery',
                                        groupValue: takeAway.value,
                                        onChanged: (value) {
                                          takeAway.value = value!;
                                          isDropdownVisible.value = (value == 'Delivery');
                                        },
                                        title: Text(
                                          'Delivery',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Metode Pembayaran"),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.zero,
                                        value: 'COD',
                                        groupValue: metodePembayaran.value,
                                        onChanged: (value) {
                                          metodePembayaran.value = value!;
                                        },
                                        title: Text(
                                          'COD',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.zero,
                                        value: 'OVO',
                                        groupValue: metodePembayaran.value,
                                        onChanged: (value) {
                                          metodePembayaran.value = value!;
                                        },
                                        title: Text(
                                          'OVO',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Obx(
                                          () => RadioListTile<String>(
                                        contentPadding: EdgeInsets.zero,
                                        value: 'Dana',
                                        groupValue: metodePembayaran.value,
                                        onChanged: (value) {
                                          metodePembayaran.value = value!;
                                        },
                                        title: Text(
                                          'Dana',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: Obx(
                                      () => isDropdownVisible.value
                                      ? Column(
                                    children: [
                                      TextField(
                                        controller: alamat,
                                        decoration: InputDecoration(
                                          hintText: 'Alamat Lengkap',
                                          hintStyle: TextStyle(fontSize: 16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Pilih Ongkir (Sesuai Kecamatan)"),
                                          ],
                                        ),
                                      ),
                                      MyDropdown(),
                                    ],
                                  )
                                      : SizedBox.shrink(),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (nama.text == '') {
                                    Get.snackbar('', 'isi nama anda terlebih dahulu',
                                        titleText: Text(
                                          'peringatan',
                                          style: TextStyle(color: Colors.red),
                                        ));
                                  } else if (takeAway.value == '') {
                                    // Aksi yang ingin Anda lakukan jika `takeAway.value` kosong
                                  } else {
                                    c.cekout(
                                      userId,
                                      nama.text,
                                      cekout.toList(),
                                      namap.toList(),
                                      harga.toList(),
                                      totalharga.toList(),
                                      total.toString(),
                                      takeAway.value,
                                      metodePembayaran.value,
                                      selectedProvince?.price.toString() ?? '',
                                      alamat.text,
                                      selectedProvince?.name ?? '',
                                    );
                                    nama.clear();
                                  }
                                },
                                child: Text('konfirmasi'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(Get.width, 50),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Aksi yang ingin Anda lakukan jika `total.value` adalah 0
                    }
                  },
                  child: Text('CekOut'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    fixedSize: Size(Get.width, 60),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
