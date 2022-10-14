import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImageDatabaseHelper {
  ImageDatabaseHelper._();

  static final ImageDatabaseHelper imageDatabaseHelper = ImageDatabaseHelper._();

  String tableName = "image";

  String colName = "src";

  Database? db;

  Future<Database> initDatabase() async {
    var db = await openDatabase("myImageDb.db");

    String dataBasePath = await getDatabasesPath();

    String path = join(dataBasePath, "myImageDB.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int vision) async {
        await db.execute("CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT,src BLOB);");
      },
    );
    return db;
  }

  Future<void> insertData({int? id,required List<myImages>? allImages}) async {
    db = await initDatabase();
    // log(allImages.toString(),name: "all Images");

    allImages?.forEach((element) async {
      String query = "INSERT INTO $tableName($colName) VALUES ('${element.image}');";
      //log(element.toString(),name: "Element");
      await db!.rawInsert(query);
    });
  }

  Future<List<myImages>> fetchAllData() async {
    db = await initDatabase();

    String query = "SELECT * FROM $tableName";

    List<Map<String, dynamic>> res = await db!.rawQuery(query);

    // log(res.toString(),name: "res");


    List<myImages> imageData = res.map((e) => myImages.fromDB(data: e)).toList();

    // log(imageData.toString(),name: "final.. imageData");

    return imageData;
  }
  Future<int> deleteAllData() async {
    db = await initDatabase();

    String query = "DELETE FROM $tableName";

    return await db!.rawDelete(query);
  }
}
