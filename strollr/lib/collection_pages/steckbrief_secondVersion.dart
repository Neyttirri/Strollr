import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:strollr/collection_pages/collection_gallery_view.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/route_pages/route_details.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../globals.dart';
import '../logger.dart';
import '../style.dart';
import 'edit_steckbrief.dart';

class Steckbrief_2 extends StatelessWidget {
  late Picture picture;
  late final Categories categoryPicture;
  final int ID_SHARE = 0;
  final int ID_DELETE = 1;
  final int ID_DOWNLOAD = 2;

  Steckbrief_2({required this.picture}) {
    categoryPicture = idToCategoryMap[picture.category]!;
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: headerGreen, //change your color here
        ),
        title: Text("Steckbrief", style: TextStyle(color: headerGreen)),
        backgroundColor: Colors.white,
        actions: [
          getImageMenu(context),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "gallery_view",
                child: Image.memory(picture.pictureData),
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
                          SizedBox(
                            height: 20,
                          ),
                          categoryPicture != Categories.undefined ?
                              Column(
                                children: [
                                  Text(
                                    questionsForCategory[categoryPicture]![0],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    picture.generic1,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    questionsForCategory[categoryPicture]![2],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    picture.generic2,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    descriptionField,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    picture.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              )

                          : Column(
                            children: [
                              Text(
                                'Erzähl was das ist oder füge es zu einer Kategorie zu!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                picture.description,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          )
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditSteckbriefScreen(picture: picture,)));
                            },
                            child: Text('Bearbeiten'),
                            style: OutlinedButton.styleFrom(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 20),
                                backgroundColor: headerGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          Spacer(),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RouteDetails(picture.walk_id,)));
                            },
                            child: Text('Zeige Route'),
                            style: OutlinedButton.styleFrom(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 20),
                                backgroundColor: headerGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
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

  Widget getImageMenu(BuildContext context) {
    return PopupMenuButton(
      elevation: 3.2,
      offset: Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      onSelected: (choice) {
        if (choice == ID_SHARE) {
          _shareImage(context);
        } else if (choice == ID_DELETE) {
          _confirmDeleting(context);
        } else if (choice == ID_DOWNLOAD) {
          _saveImageInGallery();
        } else
          print('nothing chosen !!  ');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.share),
                Container(
                  margin: EdgeInsets.only(left:10),
                  child: Text('teilen'),
                ),
              ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 1,
          child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.delete_outline),
                Container(
                  margin: EdgeInsets.only(left:10),
                  child: Text('löschen'),
                ),
              ],
          ),
          //width: 10,
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.download),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 90,
                    child: Text(
                  'in Galerie speichern',
                  maxLines: 2,
                  softWrap: true,
                )),
              ],
          ),
        ),
      ],
    );
  }

  _shareImage(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/imageToShare.jpg').create();
    file.writeAsBytesSync(picture.pictureData);
    ApplicationLogger.getLogger('Steckbrief', colors: true)
        .d('_shareImage | Sharing image with id ${picture.id}...');
    await Share.shareFiles([file.path],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    file.delete();
  }

  _deleteImage(BuildContext context) async {
    await DatabaseManager.instance.deletePicture(picture.id as int);
    Fluttertoast.showToast(
      msg: 'Gelöscht',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      textColor: Color(0xffffffff),
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
        builder: (context) => GalleryView(category: categoryPicture)));
  }

  _confirmDeleting(BuildContext context) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'Bist du sicher, dass du das Bild und den Steckbrief löschen möchtest?'),
          buttonPadding: EdgeInsets.only(left: 15, right: 15),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                child: const Text(
                  'Ja',
                  style: TextStyle(fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteImage(context);
                },
              ),
              TextButton(
                child: const Text(
                  'Nein',
                  style: TextStyle(fontSize: 16),
                ),
                style: TextButton.styleFrom(primary: Colors.green),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  _saveImageInGallery() async {
    final tempDir = await getTemporaryDirectory();
    String imageName = picture.filename;
    final file = await new File('${tempDir.path}/$imageName').create();
    print(file.path);
    file.writeAsBytesSync(picture.pictureData);
    var result = await GallerySaver.saveImage(file.path, albumName: 'Strollr');
    ApplicationLogger.getLogger('Steckbrief', colors: true)
        .d('_saveImageInGallery | Image saved in gallery: $result');
    file.delete();
  }
}
