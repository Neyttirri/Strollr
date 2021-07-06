import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/utils/shared_prefs.dart';
import 'package:animated_check/animated_check.dart';

import '../logger.dart';

class SavePhotoScreen extends StatelessWidget {
  final File image;
  final String generic1;
  final String generic2;
  final String description;
  final Categories category;
  final String imagePath;
  final DateTime createdAt = DateTime.now();
  final Position location;
  late final int walkId;
  late final String filename;
  late final int categoryId;

  final gpx = Gpx();

  SavePhotoScreen({
    required this.image,
    required this.generic1,
    required this.generic2,
    required this.description,
    required this.category,
    required this.imagePath,
    required this.location,
  }) {
    walkId = _getWalkId();
    filename = _getFilename();
  }

  String _getFilename() {
    String categoryLabel = category.toShortString();
    List<String> pathList = imagePath.split('/');
    String extension = pathList[pathList.length - 1].split('.')[1];
    String dateFormatted =
        "${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year.toString()}_${createdAt.hour.toString().padLeft(2, '0')}-${createdAt.minute.toString().padLeft(2, '0')}-${createdAt.second.toString().padLeft(2, '0')}";
    return '${categoryLabel}_$dateFormatted.$extension';
  }

  Future<int> _getCategoryId() async {
    var cat = category.toShortString();
    final db = await DatabaseManager.instance.database;
    final List<Map> map = await db
        .rawQuery('SELECT ID FROM categories WHERE description = ?', [cat]);

    if (map.isNotEmpty) {
      int id = -1;
      map.forEach((element) {
        id = element[PictureCategoriesField.id] as int;
      });
      return id;
    } else {
      throw Exception('Category ${category.toShortString()} not found!');
    }
  }

  int _getWalkId() {
    // get id from the shared prefs
    return SharedPrefs.getCurrentWalkId();
  }

  String _getLocation() {
    gpx.creator = 'picture-location';
    gpx.wpts = [Wpt(lat: location.latitude, lon: location.longitude)];
    return GpxWriter().asString(gpx, pretty: true);
  }

  void _saveInDatabase() async {
    Picture picture = Picture(
        pictureData: await image.readAsBytes(),
        createdAtTime: createdAt,
        generic1: generic1,
        generic2: generic2,
        description: description,
        location: _getLocation(),
        category: await DatabaseManager.instance.getCategoryIdFromCategory(category),
        walk_id: walkId,
        filename: filename);

    await DatabaseManager.instance.insertPicture(picture);
  }

  @override
  Widget build(BuildContext context) {
    _saveInDatabase();
    /*
    ApplicationLogger.getLogger('SavePictureScreen', colors: true)
        .d('build | deleting file...');
    image.deleteSync();

     */
    return ConfirmationAnimation();
  }
}

class ConfirmationAnimation extends StatefulWidget {
  @override
  _ConfirmationAnimationState createState() => _ConfirmationAnimationState();
}


class _ConfirmationAnimationState extends State<ConfirmationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));

    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));

    Future.delayed(Duration(milliseconds: 1500)).then(
          (value) => Navigator.pop(
        context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: AnimatedCheck(
                progress: _animation,
                size: MediaQuery.of(context).size.width * 0.6,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
