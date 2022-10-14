import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/helpers/counter_helper.dart';
import 'package:quote_app/helpers/image_db_helper.dart';
import 'package:quote_app/helpers/quote_db_helper.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:quote_app/quotes.dart';
import 'package:quote_app/screens/home_screen/all_images.dart';
import 'package:quote_app/screens/home_screen/image_screen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

List<Map<String, String>> quoteList = [];

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  List<String> quotes = [];
  List<String> images = [];
  int imagesCounter = 0;

  quoteData() async {
    List<Quotes> data = await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      quotes.add(data[i].quote);
    }
  }

  imageData() async {
    List<myImages> data = await ImageDatabaseHelper.imageDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      images.add(data[i].image);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageData();
  }

  List starList = List.generate(quoteList.length, (index) => true);

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();
    Uint8List? bytes;

    Future saveImage(Uint8List bytes) async {
      final appStorage = await getExternalStorageDirectory();
      final file = File('${appStorage!.path}/${IndexCounter.count}.png');
      ////log("${appStorage.path}/image.png", name: "Path");
      file.writeAsBytes(bytes);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            )),
        title: Text(
          "Liked Quotes",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: starList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(),
                      settings: RouteSettings(
                        arguments: [
                          quoteList[i]["quote"],
                          quoteList[i]["image"],
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 330,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: NetworkImage("${images[i]}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: 330,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "${quoteList[i]["quote"]}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  images[i] = images[imagesCounter];
                                  if (imagesCounter < 30) {
                                    imagesCounter++;
                                  }
                                  if (imagesCounter == 29) {
                                    imagesCounter = 0;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.camera,
                                size: 26,
                                color: Colors.redAccent,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: quoteList[i]["quote"],
                                  ),
                                );
                                //log(starList.length.toString(), name: "Star list lenth");
                                //log(starList.toString(), name: "Star list content");

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Copied to Clipboard"),
                                ));
                              },
                              icon: Icon(
                                Icons.file_copy,
                                size: 26,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final byte = await screenshotController.captureFromWidget(
                                  Material(
                                    child: screenShortContainer(data: [quoteList[i]["quote"], quoteList[i]["image"]]),
                                  ),
                                );
                                final temp = await getTemporaryDirectory();
                                final path = '${temp.path}/image.jpg';
                                File(path).writeAsBytesSync(byte);

                                await Share.shareFiles([path], text: "Share this app to your friends");
                              },
                              icon: Icon(
                                Icons.share,
                                size: 26,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final byte = await screenshotController.captureFromWidget(
                                  Material(
                                    child: screenShortContainer(data: [quoteList[i]["quote"], quoteList[i]["image"]]),
                                  ),
                                );
                                setState(() {
                                  bytes = byte;
                                });
                                if (bytes != null) {
                                  saveImage(bytes!);
                                }
                                setState(() {
                                  IndexCounter.count++;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Download Success"),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.file_download,
                                size: 26,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (quoteList[i]["category"] == "0") {
                                  //log("Quote from Learning");
                                  learningQuotes.forEach((element) {
                                    if (element == quoteList[i]["quote"]) {
                                      //log(element.toString(), name: "Elment");
                                      int idx = element.indexOf(element);
                                      //log(idx.toString(), name: "idx");
                                      //log("${learningStarList[idx]}", name: "value befour");
                                      learningStarList[idx] = !learningStarList[idx];
                                      quoteList.removeWhere((element) => element["quote"] == learningQuotes[i]);
                                      //log("${learningStarList[idx]}", name: "value After.");
                                      starList[i] = !starList[i];
                                      starList.removeWhere((element) => element == false);
                                    }
                                  });
                                  //log(starList.toString(), name: "Starlist");

                                  setState(() {});
                                } else if (quoteList[i]["category"] == "1") {
                                  //log("Quote from Love");
                                  loveQuotes.forEach((element) {
                                    if (element == quoteList[i]["quote"]) {
                                      int idx = element.indexOf(element);
                                      loveStarList[idx] = !loveStarList[i];
                                      quoteList.removeWhere((element) => element["quote"] == loveQuotes[idx]);
                                      starList[i] = !starList[i];
                                      starList.removeWhere((element) => element == false);
                                    }
                                  });
                                  //log(starList.toString(), name: "Starlist");

                                  setState(() {});
                                } else if (quoteList[i]["category"] == "2") {
                                  //log("Quote from Motivational");
                                  motivationalQuotes.forEach((element) {
                                    if (element == quoteList[i]["quote"]) {
                                      int idx = element.indexOf(element);
                                      motivationalStarList[idx] = !motivationalStarList[idx];
                                      quoteList.removeWhere((element) => element["quote"] == motivationalQuotes[idx]);
                                      starList[i] = !starList[i];
                                      starList.removeWhere((element) => element == false);
                                    }
                                  });
                                  //log(starList.toString(), name: "Starlist");

                                  setState(() {});
                                } else {
                                  //log("Quote from Truth");
                                  truthQuotes.forEach((element) {
                                    if (element == quoteList[i]["quote"]) {
                                      int idx = element.indexOf(element);
                                      truthStarList[idx] = !truthStarList[idx];
                                      quoteList.removeWhere((element) => element["quote"] == truthQuotes[idx]);
                                      //log("${quoteList[i]["quote"]}",name: "Truth list element");
                                     
                                      starList[i] = !starList[i];
                                      starList.removeWhere((element) => element == false);
                                    }
                                  });
                                  //log(starList.toString(), name: "Starlist");

                                  setState(() {});
                                }
                              },
                              icon: (starList[i])
                                  ? Icon(
                                      Icons.star,
                                      size: 26,
                                      color: Colors.blue,
                                    )
                                  : Icon(
                                      Icons.star_border_outlined,
                                      size: 26,
                                      color: Colors.blue,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget screenShortContainer({required List data}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        image: DecorationImage(
          image: NetworkImage(data[1]),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Text(
                data[0],
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
