import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/helpers/image_api_helper.dart';
import 'package:quote_app/helpers/image_db_helper.dart';
import 'package:quote_app/helpers/quote_api_helper.dart';
import 'package:quote_app/helpers/quote_db_helper.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:quote_app/utils/appRoutes.dart';
import 'package:quote_app/utils/routes.dart';
import 'package:path/path.dart' as p;

late Directory _appDocsDir;
bool connection = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _appDocsDir = (await getExternalStorageDirectory())!;

  connection = await InternetConnectionChecker().hasConnection;

  log(connection.toString(), name: "Connection");

  if (connection == true) {
    await QuoteDatabaseHelper.quoteDatabaseHelper.deleteAllData();
    await ImageDatabaseHelper.imageDatabaseHelper.deleteAllData();

    List<Quotes>? allQuotes = await QuotesAPIHelper.quotesAPIHelper.fetchQuotes();
    List<myImages>? allImages = await ImageAPIHelper.imageAPIHelper.fetchImages();

    await QuoteDatabaseHelper.quoteDatabaseHelper.insertData(allQuotes: allQuotes);
    await ImageDatabaseHelper.imageDatabaseHelper.insertData(allImages: allImages);
  } else {

    List<Quotes> quotes = await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    List<myImages> images = await ImageDatabaseHelper.imageDatabaseHelper.fetchAllData();

    log(images.toString(),name: "Images");
    log(quotes.toString(),name: "Quotes");
  }

  // log("Data inserted");
  //
  // List<Quotes> myQuote = await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
  // List<myImages> myImage = await ImageDatabaseHelper.imageDatabaseHelper.fetchAllData();
  //
  //  log(myImage.toString(),name: "Last Updated image");

  // log("Data inserted");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quote App",
      //home: HomePage(),
      initialRoute: AppRoutes().homePage,
      routes: routes,
    );
  }
}
