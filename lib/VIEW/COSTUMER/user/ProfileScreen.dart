import 'package:ecomerceapp/VIEW/COSTUMER/auth/LoginScreen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String name;
  void getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserName = prefs.getString('userName');
    String? storedName = prefs.getString('name');
    setState(() {
      username = storedUserName ?? '';
      name = storedName ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserIdFromSharedPrefs();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Profile"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.off(UserView());
              },
            )),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Column(
                          children: [
                            Row(
                              children:  [
                                Icon(Icons.person, color: Colors.orange),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Text(username,
                                        style: TextStyle(color: Colors.grey)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text("Nama Lengkap"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Row(
                          children:  [
                            Icon(Icons.person, color: Colors.orange),
                            SizedBox(width: 20),
                            Expanded(
                                child: Text(name,
                                    style: TextStyle(color: Colors.grey))),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.off(LoginScreen());
                        },
                        child: Text(
                          'Keluar',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fixedSize: Size(Get.width, 50)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
