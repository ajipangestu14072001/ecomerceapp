import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller.dart';


class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

final c = Get.put(Controllersr());

class _BerandaState extends State<Beranda> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Text(
              'Hallo Admin',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w900,
                  fontSize: 17),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tanggal',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                Text(
                DateFormat.yMMMEd().format(DateTime.now()).toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                )
              ],
            ),
       SizedBox(height: 50),
            Image.asset('images/pesenjama_logo.png'),
            Container(
              height: 100,
              width: Get.width,
           
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.lightBlue, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jumlah produk yang anda miliki',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: c.produk(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isEmpty) {
                            return Container(
                                margin: EdgeInsets.all(50),
                                child: Center(
                                  child: Text(
                                    "0",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 135, 12, 3),
                                        fontSize: 15),
                                  ),
                                ));
                          }
                          var data = snapshot.data!.docs;
                          return Text(data.length.toString() + ' produk',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w800));
                        }
                        return SizedBox();
                      }),
                  Text('')
                ],
              ),
            ),
               SizedBox(height: 20),
            Container(
              height: 100,
              width: Get.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.lightBlue, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jumlah pesanan yang anda miliki',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: c.get_order_kasir(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isEmpty) {
                            return Container(
                                margin: EdgeInsets.all(50),
                                child: Center(
                                  child: Text(
                                    "0",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 135, 12, 3),
                                        fontSize: 15),
                                  ),
                                ));
                          }
                          var data = snapshot.data!.docs;
                          return Text(data.length.toString() + ' produk',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w800));
                        }
                        return SizedBox();
                      }),
                  Text('')
                ],
              ),
            )
          ]))
        ]),
      ),
    );
  }
}
