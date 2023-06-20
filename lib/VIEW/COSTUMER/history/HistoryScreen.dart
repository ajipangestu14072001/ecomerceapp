import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller.dart';
import '../cekout_screen.dart';
import '../user.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Controllersr controller = Get.find<Controllersr>();

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
      controller.getOrderDataByUserId(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: const Text("History"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.off(UserView());
            },
          )),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (controller.orders.isEmpty) {
              return Center(
                child: Text('Tidak ada History.'),
              );
            } else {
              return ListView.builder(
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(Cekout(), arguments: {"id": order.orderId, "totals": order.total});
                    },
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Order ID: ${order.orderId}'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: ${order.total}'),
                            SizedBox(height: 8),
                            Text('Nama Produk:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.namaProduk
                                  .map((name) => Text('- $name'))
                                  .toList(),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text('Status: ${order.status}'),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
