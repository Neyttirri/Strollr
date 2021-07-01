// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strollr/main_screen.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/route_pages/active_route.dart';
import 'package:strollr/utils/shared_prefs.dart';
import 'globals.dart';
import 'db/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await DatabaseManager.instance.database;
  testPic = await _createTestPicture();
  runApp(MyApp());
}

Future<Picture> _createTestPicture() async {
  final bytes = (await rootBundle.load('assets/images/startScreen.jpg'))
      .buffer
      .asUint8List();
  return Picture(
    pictureData: bytes,
    filename: 'someNameHere.jpg',
    createdAtTime: DateTime.parse("2021-05-22 11:40:00Z"),
    generic1: 'black, if that is a color',
    generic2: 'not too big',
    description: 'gonna put sth here later',
    location: 'some gps data',
    category: 3,
    walk_id: 1,
  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strollr',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
      routes: {
        'main_screen': (BuildContext ctx) => MainScreen(),
        'active_route': (BuildContext ctx) => ActiveRoute(),
      },
    );
  }
}
