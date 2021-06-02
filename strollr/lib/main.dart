import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strollr/services/camera/edit_picture.dart';

void main() {
  // used to interact with the Flutter engine -> make sure that you have an instance of the WidgetsBinding
  // for image_editor_pro
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RenameMeLater());
}

class RenameMeLater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: CameraMain()));
  }

}

// camera main separatly so it is a child of MaterialApp so Navigator works and knows the right context
class CameraMain extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CameraMainState();
  }
}

class _CameraMainState extends State<CameraMain> {
  late File imageFile;
  final picker = ImagePicker();

  Future<void> _openGallery(BuildContext context) async {
    var picture = (await picker.getImage(source: ImageSource.gallery))!;
    setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> _openCamera() async {
    var picture = (await picker.getImage(source: ImageSource.camera))!;
    setState(() {
      imageFile = File(picture.path);
    });

    Future.delayed(Duration(seconds: 0)).then(
      (value) => Navigator.push(
        context,
        // the transition
        MaterialPageRoute(
          builder: (context) => EditPhotoScreen(
            arguments: [imageFile],
          ),
        ),
      ),
    );


  }

/*
  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('choose source:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
 */

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
