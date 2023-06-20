import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:ecomerceapp/ADMIN/KASIR/kasir.dart';
import 'package:ecomerceapp/DRIVER/DriverHome.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/auth/LoginScreen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/cekout_screen.dart';
import 'package:ecomerceapp/VIEW/COSTUMER/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'VIEW/COSTUMER/util/SharedPrefManager.dart';
import 'dart:io';


class Controllersr extends GetxController {
  FirebaseStorage storage = FirebaseStorage.instance;
  var firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxInt jumlah_produk = 0.obs;
  RxList<Order> orders = <Order>[].obs;
  void registerUser(
      String idUser, String nama, String userName, String password, String role) async {
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('user')
        .add({
      "idUser": idUser,
      "nama": nama,
      "userName": userName,
      "password": passwordHash,
      "role":role,
      "time": DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()
    });
    Get.snackbar('Sukses', 'Register Berhasil',
        backgroundColor: Colors.white38,
        borderRadius: 20,
        colorText: Colors.black);
    Get.off(LoginScreen());
  }

  void loginUser(String username, String password) {
    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    firestore
        .collection('Toko')
        .doc("ug72tF0uJnIyyLI2a6xX")
        .collection("user")
        .where('userName', isEqualTo: username)
        .where('password', isEqualTo: passwordHash)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        String role = querySnapshot.docs[0].data()['role'].toString();
        saveUserId(querySnapshot.docs[0].data()['idUser'].toString());
        saveUserData(
            querySnapshot.docs[0].data()['idUser'].toString(),
            querySnapshot.docs[0].data()['userName'].toString(),
            querySnapshot.docs[0].data()['nama'].toString());

        if (role == 'user') {
          Get.off(UserView());
        } else if (role == 'admin') {
          Get.off(Kasir());
        } else if (role == 'driver') {
          Get.off(DriverHome());
        } else {
          // Peran tidak valid
          Get.snackbar('Gagal', 'Peran pengguna tidak valid',
              backgroundColor: Colors.white38,
              borderRadius: 20,
              colorText: Colors.black);
        }
      } else {
        Get.snackbar('Gagal', 'UserName dan Password Salah',
            backgroundColor: Colors.white38,
            borderRadius: 20,
            colorText: Colors.black);
      }
    }).catchError((error) {
      print('Gagal melakukan login: $error');
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> produk() {
    var data = firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('produk')
        .orderBy("time");
    return data.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get_detail_produk(String id) {
    print(id);
    var data = firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('produk')
        .doc(id);
    return data.snapshots();
  }

  void tambah_ketroll(String nama_produk, String image, String deskripsi,
      String id, String jumlah, String harga, String total) {
    print(total);
    firestore
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('keranjang')
        .doc(id)
        .set({
      "nama_produk": nama_produk,
      "image": image,
      "deskripsi": deskripsi,
      "jumlah": jumlah,
      "total": total,
      "harga": harga,
      "produk_id": id,
      "create": DateTime.now().toIso8601String()
    });
  }

  void delete_keranjang(id) {
    firestore
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('keranjang')
        .doc(id)
        .delete();
  }

  void update_jumlah_produk(String id, String jumlah, String total) {
    print(total);
    firestore
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('keranjang')
        .doc(id)
        .update({"jumlah": jumlah, "tgl_cekout": '', "total": total});
  }

  void cekout(String userId, String username, List id, List namap, List harga,
      List total, String totalS, String takeAway, String payment, String ongkir, String alamat, String kecamatan) {
    DateTime newDate = DateTime.now();
    Duration menit = Duration(minutes: 60);
    var a = newDate.add(menit);
    print(harga.length);
    firestore
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .add({
      "userId": userId,
      "nama": username.toUpperCase(),
      "nama_produk": FieldValue.arrayUnion(namap),
      "harga": harga,
      "total": total,
      "id": FieldValue.arrayUnion(id),
      "tgl_order": DateTime.now().toIso8601String(),
      "selesai": '',
      "take": takeAway,
      "payment": payment,
      "jam": DateFormat('HH:mm').format(a).toString(),
      'status': 'BELUM DI BAYAR',
      "ongkir" : ongkir,
      "alamat": alamat,
      "kecamatan": kecamatan,
      "driverStatus":'',
      "diterimaAdmin":'false'
    }).then((value) {
      Get.off(Cekout(), arguments: {"id": value.id, "totals": totalS});
      saveIdHistory(value.id, totalS);
      print(value);
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get_order(String id) {
    var data = firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id);
    return data.snapshots();
  }

  void getOrderDataByUserId(String userId) {
    isLoading.value = true;

    firestore
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .where('userId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        var documents = querySnapshot.docs;
        List<Order> fetchedOrders = [];

        for (var document in documents) {
          var orderData = document.data();
          String orderId = document.id;
          String nama = orderData['nama'] ?? '';
          String time = orderData['jam'] ?? '';
          String status = orderData['status'] ?? '';
          String take = orderData['take'] ?? '';
          String dateOrder = orderData['tgl_order'] ?? '';
          List<String> namaProduk = List<String>.from(orderData['nama_produk'] ?? []);
          List<String> harga = List<String>.from(orderData['harga'] ?? []);
          List<String> total = List<String>.from(orderData['total'] ?? []);

          print("INI ORDER $orderId");

          fetchedOrders.add(
            Order(
              orderId: orderId,
              nama: nama,
              time: time,
              status: status,
              take: take,
              dateOrder: dateOrder,
              namaProduk: namaProduk,
              harga: harga,
              total: total,
            ),
          );
        }

        orders.assignAll(fetchedOrders);
      } else {
        print('Data tidak ditemukan.');
      }

      isLoading.value = false;
    }).catchError((error) {
      print('Terjadi kesalahan: $error');
      isLoading.value = false;
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> get_keranjang() {
    var data = firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('keranjang');
    return data.snapshots();
  }

  final imagePicker = ImagePicker();
  XFile? pickedImage = null;
  RxString image = "".obs;

  void selectedImageGalery() async {
    try {
      final cekFoto = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 60);
      if (cekFoto != null) {
        pickedImage = cekFoto;
      }
      update();
    } catch (e) {
      pickedImage = null;
      update();
    }
  }

  void resetImage() {
    pickedImage = null;
    update();
  }

  Future<String?> uploadImage(String uid) async {
    Reference storageRef = storage.ref("$uid.png");
    File file = File(pickedImage!.path);
    try {
      await storageRef.putFile(file);
      final photoUrl = await storageRef.getDownloadURL();
      await RxStatus.loading();
      resetImage();
      image(photoUrl);
      return photoUrl;
    } catch (e) {
      Get.snackbar('Gagal', 'periksa koneksi Internet anda',
          backgroundColor: Colors.grey,
          borderRadius: 20,
          colorText: Colors.red);
      return null;
    }
  }

  void tambah_produk(
      String deskripsi, String harga, String image, String nama) async {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('produk')
        .add({
      "deskripsi_produk": deskripsi,
      "harga": harga,
      "image": image,
      "nama": nama,
      "time": DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()
    });
    Get.back();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get_order_kasir() {
    var data = firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .orderBy("tgl_order", descending: true);
    return data.snapshots();
  }

  void update_pesanan(String id) {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id)
        .update({"status": 'SUDAH DI BAYAR', "selesai": id.toString(), "diterimaAdmin": 'true'});
  }

  void update_diver(String id) {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id)
        .update({"driverStatus": 'diantar'});
  }

  void update_divernew(String id) {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id)
        .update({"driverStatus": 'sudah diantar'});
  }

  void update_divernew2(String id) {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id)
        .update({"driverStatus": 'selesai'});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrderKurir() {
    return FirebaseFirestore.instance
        .collection('Toko')
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .where('status', isEqualTo: 'SUDAH DI BAYAR')
        // .orderBy('jam', descending: true)
        .snapshots();
  }

  void hapus_pesanan(String id) {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('order')
        .doc(id)
        .delete();
  }

  void hapus_produk(String id, String url) async {
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('produk')
        .doc(id)
        .delete();
    await FirebaseStorage.instance.refFromURL(url).delete();
    firestore
        .collection("Toko")
        .doc('ug72tF0uJnIyyLI2a6xX')
        .collection('keranjang')
        .doc(id)
        .delete();
  }

}

class Order {
  final String orderId;
  final String nama;
  final String time;
  final String status;
  final String take;
  final String dateOrder;
  final List<String> namaProduk;
  final List<String> harga;
  final List<String> total;

  Order({
    required this.orderId,
    required this.nama,
    required this.time,
    required this.status,
    required this.take,
    required this.dateOrder,
    required this.namaProduk,
    required this.harga,
    required this.total,
  });
}