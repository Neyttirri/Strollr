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
  runApp(MyApp());
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
