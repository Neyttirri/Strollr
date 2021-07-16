import 'package:flutter/material.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/route_pages/route_details.dart';

import '../style.dart';
/*
class Steckbrief extends StatelessWidget {

  final int walkID;

  final Picture selectedPicture;

  Steckbrief({
    required this.walkID,
    required this.selectedPicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: headerGreen, //change your color here
        ),
        title: Text("Steckbrief", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "gallery_view",
                child: Image.asset(
                  "assets/images/treeIcon.png",
                  height: 360,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            selectedPicture.filename,
                            style: TextStyle(
                              color: headerGreen,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Was für einen Baum ist das?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            selectedPicture.generic1,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Wo wachsen solche Bäume nicht?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            selectedPicture.generic2,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Erzähl was du darüber weißt!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            selectedPicture.description,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
// ---------------- UNTEN LEISTE
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteDetails(walkID)));
                            },
                            child: Text('Bearbeiten'),
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 20),
                                backgroundColor: headerGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                          Spacer(),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteDetails(walkID)));
                            },
                            child: Text('Zeige Route'),
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 20),
                                backgroundColor: headerGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
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
 */


/*
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: 'gallery_tag',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      ),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
 */