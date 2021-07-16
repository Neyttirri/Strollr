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
  List<CollectionListCard> categoryList = [
    CollectionListCard(treeImagePath, "Bäume", 4),
    CollectionListCard(plantImagePath, "Pflanzen", 5),
    CollectionListCard(animalImagePath, "Tiere", 3),
    CollectionListCard(mushroomImagePath, "Pilze", 6),
    CollectionListCard(undefinedCategoryImagePath, "Andere", 1),
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
                if (index == 0) {
                  category = Categories.tree;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryView(category: category)));
                } else if (index == 1) {
                  category = Categories.plant;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryView(category: category)));
                } else if (index == 2) {
                  category = Categories.animal;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryView(category: category)));
                } else if (index == 3) {
                  category = Categories.mushroom;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryView(category: category)));
                } else if (index == 4) {
                  category = Categories.undefined;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryView(category: category)));
                }
              },
              child: buildRouteListCard(context, index),
            );
          }),
    );
  }

  Widget buildRouteListCard(BuildContext context, int index) {
    final category = categoryList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0,10,30,10),
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: FutureBuilder(
                        future: getItemCount(category.categoryId),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "Gesammelt: ${snapshot.data}",
                              //itemCount.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: headerGreen,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          } else {
                            return Text(' ');
                          }
                        },
                      )
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

  Future<int> getItemCount(int cat) async {

    return (await DatabaseManager.instance.readALlPicturesFromCategory(cat)).length;
  }
}
