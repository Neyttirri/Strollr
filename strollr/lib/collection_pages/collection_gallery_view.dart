import 'package:flutter/material.dart';
import 'package:strollr/Tabs/collectionTwo.dart';
import 'package:strollr/collection_pages/steckbrief.dart';
import 'package:strollr/collection_pages/steckbrief_secondVersion.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';

import '../globals.dart';
import '../style.dart';

class GalleryView extends StatelessWidget {
  //int indexTemp;
  Categories category;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerGreen),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CollectionTwo()),
          ),
        ),
        title: Text("Gallery View", style: TextStyle(color: headerGreen)),
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
                              image: MemoryImage(pictureList[index].pictureData),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    ),
                  );
                });
          } else {
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      //selectedPicture = allPicturesInCategory;
                      pictureID = selectedPicture.id!;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Steckbrief_2(
                                picture: selectedPicture,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Image.asset("assets/images/treeIcon.png"),
                    ),
                  );
                });
          }
        },
      ),
    );
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
                    )));
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
      pageBuilder: (context, animation, secondaryAnimation) => Steckbrief_2(picture: picture),
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
