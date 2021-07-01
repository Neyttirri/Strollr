import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strollr/collection_pages/collection_category_card.dart';
import 'package:strollr/collection_pages/collection_gallery_view.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/route_pages/new_route.dart';
import 'package:strollr/route_pages/route_details.dart';
import 'package:strollr/style.dart';
import 'package:strollr/route_pages/route_list_card.dart';
import 'package:intl/intl.dart';

import '../globals.dart';


class CollectionTwo extends StatelessWidget {

  int indexTemp = 0;

  final List<CollectionListCard> categoryList = [
    CollectionListCard(treeImagePath, "Bäume", 14),
    CollectionListCard(plantImagePath, "Pflanzen", 23),
    CollectionListCard(animalImagePath, "Tiere", 3),
    CollectionListCard(mushroomImagePath, "Pilze", 7),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryView(indexTemp : indexTemp, test: testPic,)));
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
                width: 100,
                height: 100,
                child: Image.asset(category.categoryImage),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
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

/*
Card(
        color: backgroundGrey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Row(
                    children: <Widget>[
                      Image.asset(category.categoryImage, height: 60, width: 60),
                      Spacer(),
                      Text(category.categoryName, style: new TextStyle(fontSize: 18.0),),
                    ]
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                    children: <Widget>[
                      Text(category.itemCount.toString()),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
 */

