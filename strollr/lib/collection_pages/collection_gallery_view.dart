import 'package:flutter/material.dart';
import 'package:strollr/collection_pages/steckbrief.dart';

import '../style.dart';

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Gallery View", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return gridBuild();
  }

  Widget gridView() {
    return GridView.extent(
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridList(25),
    );
  }

  Widget gridBuild() {
    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: 45,
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Steckbrief()));
          },
          child: Container(
            child: Image.asset("assets/images/treeIcon.png"),
          ),
        );
      },
    );
  }
}

List<Container> _buildGridList(int i) => List.generate(
    i,
    (index) => Container(
          child: Image.asset("assets/images/mushroomIcon.png"),
        ));
