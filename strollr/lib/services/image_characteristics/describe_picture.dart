import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:strollr/utils/loading_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strollr/services/camera/save_picture.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;

import 'categories_section.dart';

class DescribePhotoScreen extends StatefulWidget {
  final List arguments;

  DescribePhotoScreen({required this.arguments});

  @override
  _DescribePhotoScreenState createState() => _DescribePhotoScreenState();
}

class _DescribePhotoScreenState extends State<DescribePhotoScreen> {
  // keep the state on a global (not local) level -> here: to show the image in another widget but in the same state
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _loading = true;
  late File image;
  String color = '';
  String size = '';
  String description = '';

  @override
  void initState() {
    super.initState();
    __initializeAsync();
  }

  Future<void> __initializeAsync() async {
    image = widget.arguments[0];
    Future.delayed(Duration(seconds: 0)).whenComplete(() => setState(() {
          _loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 10, // TODO makes sense?
            title: Text(
              "Steckbrief",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  // TODO -> next screen (see await crop();)
                },
              ),
            ]),
        body: _loading
            ? LoadingScreen()
            : //SingleChildScrollView(
            //child:
            Container(
                // use the picture that was just made as a background (blurred)
                alignment: Alignment.topCenter,
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                // rectangle on top of the image - color 0xDDDDDDDD (or white?)  with opacity
                // here are all the fields the user has to fill
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white.withOpacity(0.6),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        //height: MediaQuery.of(context).size.height * 0.9,
                        child: ListView(
                          children: <Widget>[
                            Text(
                              'Wähle Kategorie: ',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            CategoriesRadioList(),
                            _getColorField(),
                            _getSizeField(),
                            _getDescriptionField(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
        // bottomNavigationBar: _buildFunctions(),
        //   ),
        );
  }

  Widget _getColorField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Was für Farben sind auf den Bild? ',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.words,
            textAlignVertical: TextAlignVertical.center,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (value) {
              this.color = value;
            },
            decoration: InputDecoration(
              helperText: 'zB lila, grün, ...',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.green.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.green.shade500,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSizeField() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wie groß ist es? (bessere Formulierung vllt) ',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.words,
            textAlignVertical: TextAlignVertical.center,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (value) {
              this.size = value;
            },
            decoration: InputDecoration(
              helperText: 'zB wie ein Elefant',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.green.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.green.shade500,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDescriptionField() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Erzähl was du darüber weißt! ',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.words,
            textAlignVertical: TextAlignVertical.center,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (value) {
              this.description = value;
            },
            maxLines: 10,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.green.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.green.shade500,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
