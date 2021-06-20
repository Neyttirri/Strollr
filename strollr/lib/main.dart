import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/services/camera/edit_picture.dart';
import 'package:strollr/utils/shared_prefs.dart';
import 'package:geolocator/geolocator.dart';
import 'package:strollr/logger.dart';


void main() async {
  // used to interact with the Flutter engine -> make sure that you have an instance of the WidgetsBinding
  // for image_editor_pro
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  await DatabaseManager.instance.database;
  runApp(RenameMeLater());
}

class RenameMeLater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: CameraMain()));
  }
}

// camera main separatly so it is a child of MaterialApp so Navigator works and knows the right context
class CameraMain extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CameraMainState();
  }
}

class _CameraMainState extends State<CameraMain> {
  late File _imageFile;
  late Position _currentPosition;
  final _picker = ImagePicker();

  Future<void> _openCamera() async {
    var picture = (await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400))!;
    // 400x400 is less than 40kB, imageQuality is also for compressing the image

    // await Permission.locationWhenInUse.status;
    // await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('CURRENT POS: $position');
    /*
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) async {
       setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });

     */

    setState(() {
      _imageFile = File(picture.path);
      _currentPosition = position;
    });

    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.push(
        context,
        // the transition
        MaterialPageRoute(
          builder: (context) => EditPhotoScreen(
            arguments: [
              _imageFile,
              _currentPosition,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.black26,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Strollr'),
        ),
        body: Container(
          margin: EdgeInsets.all(20.0),
          constraints: BoxConstraints.loose(
              // expand -> it as much as you can as long as the height stays said height (in double)
              // loose -> does not exceed said size
              Size(400.0, 600.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/startScreen.jpg',
                fit: BoxFit
                    .cover, // how it is placed in the container ; cover -> fills as much as it can in the container
              ),
              ElevatedButton(
                onPressed: () {
                  _openCamera();
                },
                child: Text('take a piccc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
