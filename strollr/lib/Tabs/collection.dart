import 'package:flutter/material.dart';
import 'package:strollr/style.dart';

class Collection extends StatelessWidget {
  final imagePilze = "assets/images/mushroomIcon.png";
  final imagePflanzen = "assets/images/plantIcon.png";
  final imageTiere = "assets/images/animalFootstepIcon.png";
  final imageBaum = "assets/images/treeIcon.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sammlung", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              child: getGalleryContainer("Bäume", imageBaum, 5),
            ),
            Container(
              child: getGalleryContainer("Pflanzen",imagePflanzen, 12 ),
            ),
            Container(
              child: getGalleryContainer("Pilze", imagePilze, 2),
            ),
            Container(
              child: getGalleryContainer("Tiere", imageTiere, 4),
            ),
          ],
        ),
      ),
    );
  }

  Map whichIcon = {   // ------------------------------------------------- SAMMLUNG ICONS
    "Einstellungen" : Icon(Icons.settings, color: Colors.green, size: 50),
  };

  Widget getGalleryContainer(String categoryName, String image, int gesammelt){

    return new Container(
        margin: EdgeInsets.only(bottom: 10, top: 10), // zwischen containern also abstand ausserhalb vom container
        //padding: EdgeInsets.only(left: 10), // im container rand nach innen
        height: 110, width: 330,
        decoration: BoxDecoration(
          color: backgroundGrey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // boxShadow: [
          //  new BoxShadow( color: Colors.black, blurRadius: 10.0,)
          // ]
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4, // 40%
                child: Image.asset(image,
                  height: 60, width: 60,),
              ),
              Expanded(
                flex: 6, // 60%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(categoryName, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800 )),
                    Text("Gesammelt: " + gesammelt.toString()),
                    //Text(""),
                  ],
                ),
              ),
            ])
    );
  }

  int getAnzahlGesammelt(){
    int gesammelt = 0;
    return gesammelt;
  }
}
