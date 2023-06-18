import 'package:ecomerceapp/VIEW/COSTUMER/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

import '../../../controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  var uuid = Uuid();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool Isloading = false.obs;
  RxBool error = false.obs;
  final controller = Get.put(Controllersr());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nama Lengkap',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Isloading(true);
                        Future.delayed(Duration(seconds: 4), () async {
                          controller.registerUser(
                              uuid.v1(),
                              nameController.text,
                              userNameController.text,
                              passwordController.text);
                          Isloading(false);
                        });
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: Size(Get.width, 50)),
                    ),
                    Row(
                      children: [
                        const Text('Sudah Punya Akun?'),
                        TextButton(
                          child: const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Get.off(LoginScreen());
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
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
      ),
    );
  }
}
