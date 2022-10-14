import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quote_app/helpers/image_db_helper.dart';
import 'package:quote_app/helpers/quote_db_helper.dart';
import 'package:quote_app/modals/image.dart';
import 'package:quote_app/modals/quote.dart';
import 'package:quote_app/screens/home_screen/all_images.dart';
import 'package:quote_app/screens/home_screen/like_screen.dart';
import 'package:quote_app/utils/colours.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Color> colors = [
    Colors.redAccent.withOpacity(0.8),
    Colors.orangeAccent.withOpacity(0.8),
    Colors.blueAccent.withOpacity(0.8),
    Colors.purpleAccent.withOpacity(0.8),
    Colors.green.withOpacity(0.8),
  ];

  List<String> quotes = [];
  List<String> name = [
    "Learning Quotes",
    "Love Quotes",
    "Motivational Quotes",
    "Truth Quotes",
  ];

  quoteData() async {
    List<Quotes> data = await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      quotes.add(data[i].quote);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Animal.animal.fetchImages();
    quotes.clear();
    quoteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      drawer: Drawer(
        backgroundColor: Colors.black,
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 55,
        backgroundColor: colorWhite,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
        leading: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset(
                  "assets/images/menu.png",
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "Deep Life Quotes and Sayings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(
            Icons.notifications,
            color: Colors.orangeAccent,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LikeScreen(),));
              log(quoteList.toString(),name: "Quote list");
            },
            icon: Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: ImageDatabaseHelper.imageDatabaseHelper.fetchAllData(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  // List<Quotes>? quoteData = snapshot.data;
                  List<myImages>? imageData = snapshot.data;
                  log(imageData!.length.toString(), name: "Images");
                  log(quotes.length.toString(), name: "Quotes");
                  //log(quoteData.toString(), name: "Snapshot quote Data");
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CarouselSlider.builder(
                        itemCount: 5,
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 0,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                        ),
                        itemBuilder: (context, i, pageViewIndex) {
                          return Container(
                            decoration: BoxDecoration(
                              color: colors[i],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageData[i].image),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                height: 200,
                                width: 290,
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
                          );
                        },
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFFa25684),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.widgets_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Catagories",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFF7589c8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Pic Quotes",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFFb99041),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.brightness_5,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Letest",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Color(0XFF6c9978),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Articles",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            FutureBuilder(
              future: ImageDatabaseHelper.imageDatabaseHelper.fetchAllData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("ERROR: ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<myImages>? imageData = snapshot.data as List<myImages>?;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            "Most Populer",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllImages(),
                                      settings: RouteSettings(
                                        arguments: [i],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      child: Container(
                                        height: 120,
                                        width: 145,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(image: NetworkImage(imageData![i].image), fit: BoxFit.cover),
                                        ),
                                      ),
                                      elevation: 2,
                                      color: Colors.transparent,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      name[i],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: 4,
                          ),
                          height: 340,
                          width: 370,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
