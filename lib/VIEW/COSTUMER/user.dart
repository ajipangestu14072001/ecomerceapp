import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/auth/LoginScreen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/deatil_produk.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/history/HistoryScreen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/keranjang.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/user/ProfileScreen.dart';
import 'package:ecomerceapp/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

final c = Get.put(Controllersr());

class _UserViewState extends State<UserView> {
  String cariT = '';
  bool cari = false;
  TextEditingController search = TextEditingController();
  final List<String> dropdownItems = [
    'Profile',
    'Order History',
    'Log Out',
  ];
  String? selectedDropdownItem;

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
    Future.delayed(Duration(seconds: 4), () async {
      c.getOrderDataByUserId(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      onSelected: (String item) {
                        setState(() {
                          selectedDropdownItem = item;
                        });

                        if (selectedDropdownItem == 'Profile') {
                          Get.to(ProfileScreen());
                        } else if (selectedDropdownItem == 'Order History') {
                          Get.to(HistoryScreen());
                        }else if (selectedDropdownItem == 'Log Out') {
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
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: c.get_keranjang(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isEmpty) {
                            return Container();
                          }
                          var data = snapshot.data!.docs;
                          return InkWell(
                            onTap: () {
                              Get.to(Keranjang());
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(3, 4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.orange,
                                    size: 28,
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.topLeft,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 10,
                                    child: Text(
                                      "${data.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "PESENJAMA",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  onChanged: (value) {
                    if (search.text != '') {
                      setState(() {
                        cariT = value;
                        cari = true;
                      });
                    } else {
                      setState(() {
                        cari = false;
                      });
                    }
                  },
                  controller: search,
                  decoration: InputDecoration(
                    hintText: 'Search',
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
                    contentPadding: EdgeInsets.all(20),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 16.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: c.produk(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
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
                      itemBuilder: (context, index) {
                        print(data[index].id);
                        if (cari == true) {
                          if ('${data[index]['nama']}'
                              .toLowerCase()
                              .contains(cariT.toLowerCase())) {
                            return SizedBox(
                              height: 150,
                              width: Get.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
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
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${data[index]['nama']}',
                                                      textAlign:
                                                      TextAlign.left,
                                                      style: TextStyle(
                                                        color:
                                                        Colors.grey[800],
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                      overflow:
                                                      TextOverflow.fade,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Get.dialog(
                                                        DetailProduk(),
                                                        arguments:
                                                        '${(data[index].id)}',
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .shopping_cart_checkout,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Rp.${(data[index]['harga'])}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Expanded(
                                                child: Text(
                                                  '${(data[index]['deskripsi_produk'])}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }

                        return SizedBox(
                          height: 150,
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
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
                                                  '${data[index]['nama']}',
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
                                                  Get.dialog(
                                                    DetailProduk(),
                                                    arguments:
                                                    '${(data[index].id)}',
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .shopping_cart_checkout,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Rp.${(data[index]['harga'])}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Expanded(
                                            child: Text(
                                              '${(data[index]['deskripsi_produk'])}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


