import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quote_app/helpers/counter_helper.dart';
import 'package:quote_app/helpers/image_db_helper.dart';
import 'package:quote_app/helpers/quote_db_helper.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:quote_app/screens/home_screen/all_images.dart';
import 'package:quote_app/screens/home_screen/like_screen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  List<String> quotes = [];
  List<String> images = [];

  List<Color> colorList = [Colors.white, Colors.red, Colors.yellow, Colors.green, Colors.amber];
  List<String> fontFamilyList = ["Roboto", "Oswald", "Lato", "Poppins", "Kanit"];

  double fontSize = 17;
  Color textColor = Colors.white;
  TextAlign textAlign = TextAlign.center;
  TextDecoration textDecoration = TextDecoration.none;
  String fontFamily = "Roboto";

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

  bool starTapped = false;
  bool customFontTapped = false;
  int imagesCounter = 0;

  bool sizeTap = true;
  bool colorTap = false;
  bool fontTap = false;
  bool alignmentTap = false;

  bool font1 = true;
  bool font2 = false;
  bool font3 = false;
  bool font4 = false;
  bool font5 = false;

  bool alignmentRight = false;
  bool alignmentCenter = true;
  bool alignmentLeft = false;
  bool underlineText = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    quoteData();
    imageData();
    IndexCounter.count++;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    ScreenshotController screenshotController = ScreenshotController();
    Uint8List? bytes;

    Future saveImage(Uint8List bytes) async {
      final appStorage = await getExternalStorageDirectory();
      final file = File('${appStorage!.path}/${IndexCounter.count}.png');
      //log("${appStorage.path}/image.png", name: "Path");
      file.writeAsBytes(bytes);
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Screenshot(
            controller: screenshotController,
            child: screenShortContainer(data: data),
          ),
          if (customFontTapped) ...[
            Positioned(
              top: 550,
              bottom: 100,
              right: 10,
              left: 10,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF2d2d2b),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                sizeTap = true;
                                colorTap = false;
                                fontTap = false;
                                alignmentTap = false;
                              });
                            },
                            child: Text(
                              "Size",
                              style: TextStyle(color: (sizeTap) ? Colors.white : Colors.white.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sizeTap = false;
                                colorTap = true;
                                fontTap = false;
                                alignmentTap = false;
                              });
                            },
                            child: Text(
                              "Color",
                              style: TextStyle(color: (colorTap) ? Colors.white : Colors.white.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sizeTap = false;
                                colorTap = false;
                                fontTap = true;
                                alignmentTap = false;
                              });
                            },
                            child: Text(
                              "Font",
                              style: TextStyle(color: (fontTap) ? Colors.white : Colors.white.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sizeTap = false;
                                colorTap = false;
                                fontTap = false;
                                alignmentTap = true;
                              });
                            },
                            child: Text(
                              "Alignment",
                              style: TextStyle(color: (alignmentTap) ? Colors.white : Colors.white.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (sizeTap) ...[
                              Text(
                                "Text size",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (fontSize > 16) {
                                      fontSize--;
                                    }
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0XFF333333),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "A-",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("${fontSize.toInt()}", style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    fontSize++;
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0XFF333333),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "A+",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ] else if (colorTap) ...[
                              Text(
                                "Text color",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                height: 24,
                                width: 190,
                                color: Color(0XFF333333),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          textColor = colorList[i];
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        height: 24,
                                        width: 40,
                                        color: colorList[i],
                                        child: Center(
                                          child: (textColor == colorList[i]) ? Icon(Icons.check) : Container(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ] else if (fontTap) ...[
                              Text(
                                "Font style",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 26,
                                width: 190,
                                color: Color(0XFF2d2d2b),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          fontFamily = fontFamilyList[i];
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8),
                                        height: 26,
                                        width: 50,
                                        color: Colors.transparent,
                                        child: Center(
                                          child: Text(
                                            "Sample",
                                            style: TextStyle(
                                              color: (fontFamily == fontFamilyList[i]) ? Colors.white : Colors.white.withOpacity(0.5),
                                              fontFamily: fontFamilyList[i],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ] else if (alignmentTap) ...[
                              Text(
                                "Alignment",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    alignmentLeft = true;
                                    alignmentRight = false;
                                    alignmentCenter = false;
                                    textAlign = TextAlign.start;
                                  });
                                },
                                icon: Icon(Icons.format_align_left_rounded, color: (alignmentLeft) ? Colors.white : Colors.white.withOpacity(0.5)),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    alignmentLeft = false;
                                    alignmentRight = false;
                                    alignmentCenter = true;
                                    textAlign = TextAlign.center;
                                  });
                                },
                                icon: Icon(Icons.format_align_center_rounded, color: (alignmentCenter) ? Colors.white : Colors.white.withOpacity(0.5)),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    alignmentLeft = false;
                                    alignmentRight = true;
                                    alignmentCenter = false;
                                    textAlign = TextAlign.end;
                                  });
                                },
                                icon: Icon(Icons.format_align_right_rounded, color: (alignmentRight) ? Colors.white : Colors.white.withOpacity(0.5)),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    underlineText = !underlineText;
                                    if (underlineText) {
                                      textDecoration = TextDecoration.underline;
                                    } else {
                                      textDecoration = TextDecoration.none;
                                    }
                                  });
                                },
                                icon: Icon(Icons.format_underline_rounded, color: (underlineText) ? Colors.white : Colors.white.withOpacity(0.5)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          Positioned(
            top: 630,
            bottom: 30,
            right: 10,
            left: 10,
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0XFF2d2d2b),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        data[1] = images[imagesCounter];
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
                      setState(() {
                        customFontTapped = !customFontTapped;
                      });
                    },
                    icon: Icon(
                      Icons.font_download,
                      size: 26,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final byte = await screenshotController.captureFromWidget(
                        Material(
                          child: screenShortContainer(data: data),
                        ),
                      );
                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/image.jpg';
                      File(path).writeAsBytesSync(byte);

                      await Share.shareFiles([path], text: "${data[0]}");
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
                          child: screenShortContainer(data: data),
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
                ],
              ),
            ),
          ),
        ],
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
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: fontSize, decoration: textDecoration, fontFamily: fontFamily),
                textAlign: textAlign,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
