import 'package:flutter/material.dart';

class Province {
  String name;
  int price;

  Province({required this.name, required this.price});
}

List<Province> provinces = [
  Province(name: 'Medan Amplas', price: 23000),
  Province(name: 'Medan Area', price: 13000),
  Province(name: 'Medan Barat', price: 10000),
  Province(name: 'Medan Baru', price: 15000),
  Province(name: 'Medan Belawan', price: 20000),
  Province(name: 'Medan Deli', price: 18000),
  Province(name: 'Medan Denai', price: 15000),
  Province(name: 'Medan Helvetia', price: 17000),
  Province(name: 'Medan Johor', price: 19000),
  Province(name: 'Medan Kota', price: 16000),
  Province(name: 'Medan Labuhan', price: 23000),
  Province(name: 'Medan Maimun', price: 17000),
  Province(name: 'Medan Marelan', price: 18000),
  Province(name: 'Medan Perjuangan', price: 15000),
  Province(name: 'Medan Petisah', price: 17000),
  Province(name: 'Medan Polonia', price: 19000),
  Province(name: 'Medan Sunggal', price: 19000),
  Province(name: 'Medan Selayang', price: 17000),
  Province(name: 'Medan Tembung', price: 24000),
  Province(name: 'Medan Tuntungan', price: 23000),
  Province(name: 'Medan Timur', price: 21000),
];

Province? selectedProvince;

class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Province>(
      value: selectedProvince,
      onChanged: (Province? newValue) {
        setState(() {
          selectedProvince = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Pilih Provinsi',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        isDense: true,
      ),
      items: provinces.map((Province province) {
        return DropdownMenuItem<Province>(
          value: province,
          child: Text(
            '${province.name} (${province.price})',
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}


