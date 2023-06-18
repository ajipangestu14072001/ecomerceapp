
import 'package:ecomerceapp/VIEW/COSTUMER/user.dart';
import 'package:ecomerceapp/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final ca = Get.put(Controllersr());

class _LoginState extends State<Login> {
  RxBool Isloading = false.obs;
  RxBool error = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('images/image_banner.png', height: 100),
              SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 2, 2, 2),
                highlightColor: Colors.white,
                child: Text(
                  'PESENJAMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 30),
             
              ElevatedButton(
                onPressed: () async {
                  Isloading(true);
                  Future.delayed(Duration(seconds: 4), () async {
                    Get.off(UserView());
                    Isloading(false);
                  });
                },
                child: Text(
                  'Selamat Datang User',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(Get.width, 50)),
              )
            ]),
          ),
          Obx(
            () => Isloading.isTrue
                ? Container(
                    alignment: Alignment.center,
                    color: Color.fromARGB(56, 0, 0, 0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ),
         
        ],
      ),
    );
  }
}

