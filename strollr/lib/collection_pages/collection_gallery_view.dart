import 'package:flutter/material.dart';
import 'package:strollr/collection_pages/steckbrief.dart';
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

  GalleryView({
    required this.category,
    required this.categoryID,
  });

  @override
  Widget build(BuildContext context) {
    allPicturesInCategory = DatabaseManager.instance.readALlPicturesFromCategory(categoryID);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Gallery View", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    //print("Index = " + indexTemp.toString());
    return gridBuild();
  }

  /*
  Widget gridView() {
    return GridView.extent(
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridList(indexTemp),
    );
  }
   */

  Widget gridBuild() {
    print("Index = " + category.toString());

    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: allPicturesInCategory.toString().length,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          onTap: () {
            //selectedPicture = allPicturesInCategory;
            pictureID = selectedPicture.id!;
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Steckbrief(
              walkID: walkID,
              selectedPicture: selectedPicture,
            )));
          },
          child: Container(
            padding: EdgeInsets.all(4),
            child: Image.asset("assets/images/treeIcon.png"),
          ),
        );
      },
    );
  }

  /*
  Future<List<Picture>> readAllPictures(int index) {
    Future<List<Picture>> allPicturesInCategory;
    if(index == 0) {
      return allPicturesInCategory = DatabaseManager.instance.readALlPicturesFromCategory(0);
    } else if(index == 1) {
      return allPicturesInCategory = DatabaseManager.instance.readALlPicturesFromCategory(0);
    } else if(index == 2) {
      return allPicturesInCategory = DatabaseManager.instance.readALlPicturesFromCategory(0);
    } else if(index == 3) {
      return allPicturesInCategory = DatabaseManager.instance.readALlPicturesFromCategory(0);
    }
  }
   */
}



/*
List<Container> _buildGridList(int i) => List.generate(
    i,
    (index) => Container(
          child: Image.asset("assets/images/mushroomIcon.png"),
        ));

 */