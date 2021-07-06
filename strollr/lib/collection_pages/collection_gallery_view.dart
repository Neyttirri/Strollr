import 'package:flutter/material.dart';
import 'package:strollr/collection_pages/steckbrief.dart';
import 'package:strollr/collection_pages/steckbrief_secondVersion.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';

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

    pictures.forEach((element) {
      pictureList.add(Picture(
          pictureData: element.pictureData,
          filename: element.filename,
          createdAtTime: element.createdAtTime,
          generic1: element.generic1,
          generic2: element.generic2,
          description: element.description,
          location: element.location,
          category: element.category,
          walk_id: element.walk_id));
    });

    return true;
  }

  GalleryView({
    required this.category,
  }) {
    categoryID = DatabaseManager.idToCategoryMap.keys.firstWhere((
        element) => DatabaseManager.idToCategoryMap[element] == category);
  }

  @override
  Widget build(BuildContext context) {
    allPicturesInCategory =
        DatabaseManager.instance.readALlPicturesFromCategory(categoryID);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerGreen),
          onPressed: () => Navigator.of(context).pop(),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Steckbrief_2(
                                picture: pictureList[index],
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: new DecorationImage(
                            image: MemoryImage(pictureList[index].pictureData),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
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
                          builder: (context) =>
                              Steckbrief_2(
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
                builder: (context) =>
                    Steckbrief_2(
                      picture: selectedPicture,
                    ),
            )
            );
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
                builder: (context) =>
                    Steckbrief(
                      walkID: walkID,
                      selectedPicture: selectedPicture,
                    )));
          },
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
        );
      },
    );
  }

}
