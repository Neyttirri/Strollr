import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strollr/collection_pages/steckbrief.dart';
import 'package:strollr/collection_pages/steckbrief_secondVersion.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';

import '../style.dart';

class GalleryView extends StatelessWidget {

  int indexTemp;
  Picture test;
  //List<Picture> allPicturesInCategory;

  GalleryView({required this.indexTemp, required this.test});

  @override
  Widget build(BuildContext context) {
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
    print("Index = " + indexTemp.toString());

    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: 45,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Steckbrief_2(picture:test )));

            /*
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Steckbrief(
              index: 0,
              imagePath:"assets/images/treeIcon.png",
              title:"Baum",
              details: "Großer Baum",
            )));

             */
          },
          child: Container(
            padding: EdgeInsets.all(4),
            child: Image.asset("assets/images/treeIcon.png"),
          ),
        );
      },
    );
  }

  readAllPictures(int index) {
    if(index == 0) {
      //readALlPicturesFromCategory(index, )
    }
  }
}



/*
List<Container> _buildGridList(int i) => List.generate(
    i,
    (index) => Container(
          child: Image.asset("assets/images/mushroomIcon.png"),
        ));

 */