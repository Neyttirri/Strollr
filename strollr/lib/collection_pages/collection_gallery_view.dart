import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:strollr/Tabs/collectionTwo.dart';
import 'package:strollr/collection_pages/steckbrief_secondVersion.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';

import '../globals.dart';
import '../style.dart';

class GalleryView extends StatelessWidget {

  Categories category;

  late int navigationID = 1;
  late int categoryID;
  late int walkID;
  late int pictureID;

  late Future<List<Picture>> allPicturesInCategory;
  late List<Picture> allPictures;

  late Picture selectedPicture;

  final List<Picture> pictureList = [];

  Future<bool> buildPictureList() async {
    List<Picture> pictures =
        await DatabaseManager.instance.readALlPicturesFromCategory(categoryID);

    pictureList.addAll(pictures);
    return true;
  }

  GalleryView({
    required this.category,
  }) {
    categoryID = idToCategoryMap.keys.firstWhere(
        (element) => idToCategoryMap[element] == category,
        orElse: () => 1);
  }

  late String _title = "";


  @override
  Widget build(BuildContext context) {
    if(category.index == 0) {
      _title = "Andere";
      print(category.index.toString());
    } else if(category.index == 2) {
      _title = "Meine Tiere";
    }  else if(category.index == 3) {
      _title = "Meine Bäume";
    } else if(category.index == 4) {
      _title = "Meine Planzen";
    } else if(category.index == 5) {
      _title = "Meine Pilze";
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerGreen),
          onPressed: () {
            Navigator.of(context).pop();
            //Navigator.of(context).pop();
          },
        ),
        title: Text(_title, style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: buildPictureList(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: pictureList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          _createRoute(pictureList[index]));
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Hero(
                        tag: "gallery_view",
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: new DecorationImage(
                              image: Image.memory(pictureList[index].pictureData, scale: 0.2, filterQuality: FilterQuality.none,).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("Noch keine Bilder vorhanden", style: TextStyle(fontSize: 20, color: headerGreen)),
            );
          }
        },
      ),
    );
  }

  img.Image _getImage(int index) {

    return img.decodeImage(pictureList[index].pictureData)!;
    /*
    late ui.Image image;
    ui.decodeImageFromList(pictureList[index].pictureData, (result) { image = result; });
    late ByteData? bytes;
    image.toByteData().then((value) => bytes = value);
    if(bytes == null)
      return Uint8List(0);

     */
    //return Image.memory(decoded);
  }

  Widget mainWidget() {
    return gridBuildWithoutData();
  }

  Widget gridBuildWithoutData() {
    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          onTap: () {
            //selectedPicture = allPicturesInCategory;
            pictureID = selectedPicture.id!;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Steckbrief_2(
                picture: selectedPicture,
                navigationID: navigationID,
              ),
            ));
          },
          child: Container(
            padding: EdgeInsets.all(4),
            child: Image.asset("assets/images/treeIcon.png"),
          ),
        );
      },
    );
  }

  Widget gridBuildWithData() {
    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: pictureList.length,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          onTap: () {
            pictureID = selectedPicture.id!;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Steckbrief_2(
                  picture: selectedPicture,
                  navigationID: navigationID,
                )
            ));
          },
          child: Hero(
            tag: "gallery_view",
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: new DecorationImage(
                  image: MemoryImage(pictureList[index].pictureData),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          )
        );
      },
    );
  }

  Route _createRoute(Picture picture) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Steckbrief_2(picture: picture, navigationID: navigationID,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        }
    );
  }
}
