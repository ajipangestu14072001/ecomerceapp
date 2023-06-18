import 'package:ecomerceapp/VIEW/COSTUMER/auth/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller.dart';
import '../user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
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
                      Image.asset('images/pesenjama_logo.png', height: 200),
                      SizedBox(height: 10),
                      // Shimmer.fromColors(
                      //   baseColor: Color.fromARGB(255, 2, 2, 2),
                      //   highlightColor: Colors.white,
                      //   child: Text(
                      //     'PESENJAMA',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //         fontSize: 25,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.grey[300]),
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextField(
                          controller: nameController,
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
                            controller.loginUser(nameController.text, passwordController.text);
                            Isloading(false);
                          });
                        },
                        child: Text(
                          'Login',
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
                          const Text('Belum Punya Akun?'),
                          TextButton(
                            child: const Text(
                              'Daftar',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Get.off(RegisterScreen());
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
        ));
  }
}
