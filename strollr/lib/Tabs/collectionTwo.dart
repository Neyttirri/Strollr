import 'package:flutter/material.dart';
import 'package:strollr/collection_pages/collection_category_card.dart';
import 'package:strollr/collection_pages/collection_gallery_view.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/style.dart';
import '../globals.dart';


class CollectionTwo extends StatelessWidget {

  int indexTemp = 0;
  late Categories category;

  final List<CollectionListCard> categoryList = [
    CollectionListCard(treeImagePath, "Bäume", 14),
    CollectionListCard(plantImagePath, "Pflanzen", 23),
    CollectionListCard(animalImagePath, "Tiere", 3),
    CollectionListCard(mushroomImagePath, "Pilze", 7),
    CollectionListCard(undefinedCategoryImagePath, "Andere", 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategorien", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: categoryList.length, //Database length
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: () {
                indexTemp = index;
                if(index == 0) {
                  category = Categories.tree;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(category : category)));
                } else if(index == 1) {
                  category = Categories.plant;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(category : category)));
                } else if(index == 2) {
                  category = Categories.animal;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(category : category)));
                } else if(index == 3) {
                  category = Categories.mushroom;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(category : category)));
                } else if(index == 4) {
                  category = Categories.undefined;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(category : category)));
                }
              },
              child: buildRouteListCard(context, index),
            );

          }
      ),
    );
  }

  Widget buildRouteListCard(BuildContext context, int index) {
    final category = categoryList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: Image.asset(category.categoryImage),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 30, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.categoryName,
                      style: TextStyle(
                        fontSize: 22,
                        color: headerGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      child: Text(
                        "Gesammelt: ",
                        style: TextStyle(
                          fontSize: 20,
                          color: headerGreen,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

