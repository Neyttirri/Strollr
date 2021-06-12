import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture_categories.dart';

class SavePhotoScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String color;
  final String size;
  final String description;
  final Categories category;
  final String imagePath;
  final DateTime createdAt = DateTime.now();
  //final Position imageLocation;

  late String filename;
  var gpx = Gpx();

  SavePhotoScreen(
      {required this.imageBytes,
      required this.color,
      required this.size,
      required this.description,
      required this.category,
      required this.imagePath,
      }); //required this.imageLocation

  void getFilename() {
    String categoryLabel = category.toString();
    List<String> pathList = imagePath.split('/');
    String extension = pathList[pathList.length - 1].split('.')[1];
    String dateFormatted =
        "${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year.toString()}_${createdAt.hour.toString().padLeft(2, '0')}-${createdAt.minute.toString().padLeft(2, '0')}-${createdAt.second.toString().padLeft(2, '0')}";
    filename = '${categoryLabel}_$dateFormatted.$extension';
    print(filename);
  }

  Future<int> getCategoryId() async {
    final db = await DatabaseManager.instance.database;
    final map = await db.rawQuery(
        'SELECT ID FROM categories WHERE description = ?',
        [category.toString()]);

    if (map.isNotEmpty) {
      return map.first[0] as int;
    } else {
      throw Exception('Category $category not found!');
    }
  }

  void getWalkId() {
    // TODO: Shared preferences, save the current walk ID, read it from there for the pic -> maybe?
  }

  String getLocation() {
    /*
    gpx.creator = 'picture-location';
    gpx.wpts = [ Wpt(lat: imageLocation.latitude, lon: imageLocation.longitude)];
    return GpxWriter().asString(gpx, pretty: true);

     */
    return '';
  }

  @override
  Widget build(BuildContext context) {
    print('save image file dart');
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Export Photo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
