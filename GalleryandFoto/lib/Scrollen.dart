import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:strollr/main.dart';
//import 'package:strollr/GalleryView.dart';

import 'GalleryView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = "Strollr";

    return MaterialApp(
        title: appName,
        home: MyHomePage(
          title: appName,
        )
    );
  }
}

//------------------------------------- CHOOSES WHICH DATA IS SHOWN
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();  // CREATE THIS SCREEN

}

//----------------------------------------- HIER ALLES FUER 1 SCREEN
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // SETTINGS BUTTON
          // TextButton(
          //     onPressed: null,
          //     child: Container(
          //       margin: EdgeInsets.only(top: 30, bottom: 10),
          //       height: 40,
          //       width: 60,
          //       decoration: BoxDecoration(
          //         color: Color(0xfffafafa),
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //       ),
          //       child: Icon(Icons.settings, color: Colors.black, size: 40),
          //     )
          // ),
          // GALLERY IN SCROLL ANSICHT
          Container(
                height: 650,
                margin: EdgeInsets.only(top: 20, bottom: 15),
                child: ListView(
                  children: getGalleryCategories(),
                ),
              ),
          // ADD + BUTTON
          TextButton(
              onPressed: null, //getGalleryContainer(),
              child: Container(
                margin: EdgeInsets.only(right: 20),
                height: 40, width: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                child: Icon(Icons.add, color: Colors.white, size: 40),
              )
          ),
        ],
      ),
    );

  }
}

  int gesammelt = 5;
// EINZELN
Widget getGalleryContainer(String categoryName)
{
  String categoryImage = "assets/" + categoryName + ".png";
  if (categoryName == "Bäume") categoryImage = "assets/Baum.png";

    return new Container(
    margin: EdgeInsets.all(10),
    child : InkWell(
      child: Container (
        height: 130,
        width: 330,
        decoration: BoxDecoration(
          color: Color(0xff9e9e9e),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // boxShadow: [
          //  new BoxShadow( color: Colors.black, blurRadius: 10.0,)
          // ]
        ),
        child: Row(
            children: <Widget>[
              Expanded(
                flex: 4, // 40%
                child: Image.asset(categoryImage,
                  height: 60,
                  width: 60,
                ),
              ),
              Expanded(
                flex: 6, // 60%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName, style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.w800)),
                    Text("Gesammelt: " + gesammelt.toString()), //Text(""),
                  ],
                ),
              ),
            ])
    ),
      onTap: ( ) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView()));
        //print("tapped on container: " + categoryName);
      },
    ));

  }

List<String> galleryCategories = ["Bäume", "Pflanzen", "Pilze", "Tiere", "test"];
  // Scroll Liste
  List<Widget> getGalleryCategories()
  {
    List <Widget> galleryCategoryCards = [];
    List <Widget> rows = [];

    for (String category in galleryCategories)
    {
        galleryCategoryCards.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
        rows = [];
        rows.add(getGalleryContainer(category));
      }
    if (rows.length > 0) {
      galleryCategoryCards.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ));
    }
    return galleryCategoryCards;
  }

