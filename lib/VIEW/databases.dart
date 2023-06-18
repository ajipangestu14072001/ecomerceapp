import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class Databases extends GetxController {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('produk.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _creatDB);
  }

  Future _creatDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableProuduk ( 
  ${DB.id} $idType, 
  ${DB.image} $textType,
  ${DB.nama} $textType,
  ${DB.deskripsi} $textType,
  ${DB.harga} $textType,
  ${DB.time} $textType

  )
''');
  }

  Future<D> create(D data) async {
    final db = await database;
    final id = await db.insert(tableProuduk, data.toJson());
    return data.copy(id: id);
  }

  Future<List<D>> getProduk() async {
    final db = await database;
    final orderby = '${DB.time} ASC';
    final result = await db.query(tableProuduk, orderBy: orderby);
    return result.map((e) => D.fromJson(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await database;
    int deletes = await db.delete(
      tableProuduk,
      where: '${DB.id} = ?',
      whereArgs: [id],
    );
    return deletes;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
  
}

//model-----------

final String tableProuduk = 'Produk';

class DB {
  static final List<String> values = [id, image, nama, deskripsi, harga, time];
  static final String id = 'id';
  static final String image = 'image';
  static final String nama = 'nama';
  static final String deskripsi = 'deskripsi';
  static final String harga = 'harga';
  static final String time = 'time';
}

class D {
  final int? id;
  final String image;
  final String nama;
  final String deskripsi;
  final String harga;
  final DateTime time;

  const D(
      {this.id,
      required this.image,
      required this.nama,
      required this.deskripsi,
      required this.harga,
      required this.time});

  D copy({
    final int? id,
    String? image,
    String? nama,
    String? deskripsi,
    String? harga,
    DateTime? time,
  }) =>
      D(
        id: id ?? this.id,
        image: image ?? this.image,
        nama: nama ?? this.nama,
        deskripsi: deskripsi ?? this.deskripsi,
        harga: harga ?? this.harga,
        time: time ?? this.time,
      );

  static D fromJson(Map<String, Object?> json) => D(
        id: json[DB.id] as int?,
        image: json[DB.image] as String,
        nama: json[DB.nama] as String,
        deskripsi: json[DB.deskripsi] as String,
        harga: json[DB.harga] as String,
        time: DateTime.parse(json[DB.time] as String),
      );

  Map<String, Object?> toJson() => {
        DB.id: id,
        DB.image: image,
        DB.nama: nama,
        DB.deskripsi: deskripsi,
        DB.harga: harga,
        DB.time: time.toIso8601String()
      };
}
