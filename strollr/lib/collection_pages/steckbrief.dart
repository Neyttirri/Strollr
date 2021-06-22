import 'package:flutter/material.dart';
import 'package:strollr/route_pages/route_details.dart';

import '../style.dart';

class Steckbrief extends StatelessWidget {

  final String imagePath;
  final String title;
  final String details;
  final int index;

  Steckbrief({
    required this.index,
    required this.imagePath,
    required this.title,
    required this.details,
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
                            "Eiche",
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
                            "Eiche",
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
                            "In hohen Gebirgen und der Wüste, außerdem können Eichen nicht im Schatten anderer Gehölze wachsen",
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
                            "Eichen-Arten sind sommergrüne oder immergrüne Bäume, seltener auch Sträucher",
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
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteDetails()));
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