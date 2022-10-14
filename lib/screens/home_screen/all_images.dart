import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:developer' as log_print;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/helpers/counter_helper.dart';
import 'package:quote_app/helpers/image_db_helper.dart';
import 'package:quote_app/helpers/quote_db_helper.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:quote_app/quotes.dart';
import 'package:quote_app/screens/home_screen/image_screen.dart';
import 'package:quote_app/screens/home_screen/like_screen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

List<bool> learningStarList = List.generate(10, (index) => false);
List<bool> loveStarList = List.generate(10, (index) => false);
List<bool> motivationalStarList = List.generate(10, (index) => false);
List<bool> truthStarList = List.generate(10, (index) => false);

class AllImages extends StatefulWidget {
  const AllImages({Key? key}) : super(key: key);

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  List<String> name = [
    "Learning Quotes",
    "Love Quotes",
    "Motivational Quotes",
    "Truth Quotes",
  ];

  List<String> quotes = [];
  List<String> images = [];

  int minNum = 6;
  int maxNum = 12;
  int res = 0;
  Random random = Random();

  imageData() async {
    res = minNum + random.nextInt(maxNum - minNum);

    List<myImages> data = await ImageDatabaseHelper.imageDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      images.add(data[i].image);
    }
  }

  bool starTapped = false;
  int imagesCounter = 0;

  mySetState() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // quoteData();
    imageData();
    mySetState();
    //log_print.log(starList.toString(),name: "starList");
    IndexCounter.count++;
  }

  @override
  Widget build(BuildContext context) {
    List<int> argumentList = ModalRoute.of(context)!.settings.arguments as List<int>;

    if (argumentList[0] == 0) {
      //log("Tapped Learning Quotes",name : "Learning");
      quotes.addAll(learningQuotes);
    } else if (argumentList[0] == 1) {
      //log("Tapped love Quotes",name : "Love");
      quotes.addAll(loveQuotes);
    } else if (argumentList[0] == 2) {
      //log("Tapped Motivational Quotes",name : "Motivational");
      quotes.addAll(motivationalQuotes);
    } else if (argumentList[0] == 3) {
      //log("Tapped truth Quotes",name : "truth");
      quotes.addAll(truthQuotes);
    }

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
          name[argumentList[0]],
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: (quotes.length <= 10 && images.isEmpty)
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 10,
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
                                quotes[i],
                                images[i+res],
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
                                  image: NetworkImage(images[i + res]),
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
                                      quotes[i],
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
                                          text: quotes[i],
                                        ),
                                      );
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
                                          child: screenShortContainer(data: [quotes[i], images[i]]),
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
                                          child: screenShortContainer(data: [quotes[i], images[i]]),
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
                                      setState(() {
                                        if (argumentList[0] == 0) {
                                          learningStarList[i] = !learningStarList[i];
                                          if (learningStarList[i]) {
                                            quoteList.add({"quote": "${learningQuotes[i]}", "image": "${images[i]}","category": "0"});
                                          } else {
                                            quoteList.removeWhere((element) => element["quote"] == learningQuotes[i]);
                                          }
                                        } else if (argumentList[0] == 1) {
                                          loveStarList[i] = !loveStarList[i];
                                          if (loveStarList[i]) {
                                            quoteList.add({"quote": "${loveQuotes[i]}", "image": "${images[i]}","category": "1"});
                                          } else {
                                            quoteList.removeWhere((element) => element["quote"] == loveQuotes[i]);
                                            // quoteList.remove({"quote": "${loveQuotes[i]}", "image": "${images[i]}"});
                                          }
                                        } else if (argumentList[0] == 2) {
                                          motivationalStarList[i] = !motivationalStarList[i];
                                          if (motivationalStarList[i]) {
                                            quoteList.add({"quote": "${motivationalQuotes[i]}", "image": "${images[i]}","category": "2"});
                                          } else {
                                            quoteList.removeWhere((element) => element["quote"] == motivationalQuotes[i]);
                                            // quoteList.remove({"quote": "${motivationalQuotes[i]}", "image": "${images[i]}"});
                                          }

                                        } else if (argumentList[0] == 3) {
                                          truthStarList[i] = !truthStarList[i];
                                          if (truthStarList[i]) {
                                            quoteList.add({"quote": "${truthQuotes[i]}", "image": "${images[i]}","category": "3"});
                                          } else {
                                            quoteList.removeWhere((element) => element["quote"] == truthQuotes[i]);
                                            // quoteList.remove({"quote": "${truthQuotes[i]}", "image": "${images[i]}"});
                                          }
                                        }
                                      });
                                    },
                                    icon: (argumentList[0] < 3)
                                        ? (argumentList[0] < 2)
                                            ? (argumentList[0] < 1)
                                                ? (learningStarList[i])
                                                    ? Icon(
                                                        Icons.star,
                                                        size: 26,
                                                        color: Colors.blue,
                                                      )
                                                    : Icon(
                                                        Icons.star_border_outlined,
                                                        size: 26,
                                                        color: Colors.blue,
                                                      )
                                                : (loveStarList[i])
                                                    ? Icon(
                                                        Icons.star,
                                                        size: 26,
                                                        color: Colors.blue,
                                                      )
                                                    : Icon(
                                                        Icons.star_border_outlined,
                                                        size: 26,
                                                        color: Colors.blue,
                                                      )
                                            : (motivationalStarList[i])
                                                ? Icon(
                                                    Icons.star,
                                                    size: 26,
                                                    color: Colors.blue,
                                                  )
                                                : Icon(
                                                    Icons.star_border_outlined,
                                                    size: 26,
                                                    color: Colors.blue,
                                                  )
                                        : (truthStarList[i])
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
