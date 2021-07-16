import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/style.dart';
import 'package:strollr/utils/loading_screen.dart';
import 'save_picture.dart';
import '../globals.dart';
import '../logger.dart';

class DescribePhotoScreen extends StatefulWidget {
  final List arguments;

  DescribePhotoScreen({required this.arguments});

  @override
  _DescribePhotoScreenState createState() => _DescribePhotoScreenState();
}

class _DescribePhotoScreenState extends State<DescribePhotoScreen>
    with SingleTickerProviderStateMixin {
  // keep the state on a global (not local) level -> here: to show the image in another widget but in the same state
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final double distanceBetweenElements = 50;
  bool _loading = true;
  String genericInfo1 = '';
  String genericInfo2 = '';
  String description = '';

  Categories chosenCategory = Categories.undefined;
  late File image;
  late AnimationController _animationController;

  // TODO: prob smarter
  List<RadioModel> radioCategoryList = [
    new RadioModel(false, Image.asset(treeImagePath), 'Baum'),
    new RadioModel(false, Image.asset(plantImagePath), 'Pflanze'),
    new RadioModel(false, Image.asset(mushroomImagePath), 'Pilze'),
    new RadioModel(false, Image.asset(animalImagePath), 'Tier')
  ];

  @override
  void initState() {
    super.initState();
    __initializeAsync();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        elevation: 10,
        title: Text(
          "Steckbrief zum Bild",
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          // icon button to confirm changes and proceed to save info and image
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
                ApplicationLogger.getLogger('_DescribePhotoScreenState',
                    colors: true)
                    .d('saving image and info with path: ${image.path} ');
                await Future.delayed(Duration(seconds: 0)).then(
                      (value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavePhotoScreen(
                        generic1: genericInfo1,
                        generic2: genericInfo2,
                        description: description,
                        category: getChosenCategory(),
                        image: image,
                        imagePath: image.path,
                        location: widget.arguments[1],
                        //imageLocation: widget.arguments[1]
                      ),
                    ),
                  ),
                );
              }
          ),
        ],
      ),
      body: _loading
          ? LoadingScreen()
          : //SingleChildScrollView(
          //child:
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: backgroundGrey,
              ),
              // here are all the fields the user has to fill
              child: ListView(
                children: [
                  Text(
                    'Wähle eine Kategorie: ',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _getCategoryField(),
                  // get all categories with icons, as a list that is horizontally scrollable
                  (chosenCategory != Categories.undefined)
                      // show the questions after the user has chosen a category -> animated widgets
                      // if the user has not chosen a category -> show the picture the user took
                      ? SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 1), // move from bottom to top
                            end: Offset.zero,
                          ).animate(_animationController),
                          child: FadeTransition(
                            opacity: _animationController,
                            child: Column(
                              children: [
                                _getQuestionsForCategory(),
                                _getDescriptionField(),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            image: new DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _generateQuestion(
      String question, String helpText, bool isFirstQuestion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          question,
          style: TextStyle(
            color: Colors.green,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          cursorColor: Colors.black,
          textCapitalization: TextCapitalization.sentences,
          textAlignVertical: TextAlignVertical.center,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          onChanged: (value) {
            if (isFirstQuestion) {
              this.genericInfo1 = value;
            } else {
              this.genericInfo2 = value;
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            helperText: helpText,
            helperMaxLines: 3,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.green.shade300,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.green.shade500,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getQuestionsForCategory() {
    _animationController.forward();
    return Column(
      children: [
        _generateQuestion(questionsForCategory[chosenCategory]![0],
            questionsForCategory[chosenCategory]![1], true),
        Padding(padding: EdgeInsets.only(top: distanceBetweenElements)),
        _generateQuestion(questionsForCategory[chosenCategory]![2],
            questionsForCategory[chosenCategory]![3], false),
      ],
    );
  }

  Widget _getDescriptionField() {
    return Container(
      margin: EdgeInsets.only(top: distanceBetweenElements),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            descriptionField,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            cursorColor: Colors.black,
            textCapitalization: TextCapitalization.sentences,
            textAlignVertical: TextAlignVertical.center,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (value) {
              this.description = value;
            },
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.green.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
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

  Widget _getCategoryField() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [..._getAllCategoriesRadioButtons()],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getAllCategoriesRadioButtons() {
    List<Widget> radioList = [];
    for (RadioModel radio in radioCategoryList) {
      radioList.add(
        InkWell(
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              radioCategoryList
                  .forEach((element) => element.isSelected = false);
              radio.isSelected = true;
              chosenCategory = getChosenCategory();
              ApplicationLogger.getLogger('_DescribePhotoScreenState',
                      colors: true)
                  .d('chosen category: ${chosenCategory.toString()} ');
              _animationController.reset();
            });
          },
          child: new RadioItem(radio),
        ),
      );
    }

    return radioList;
  }

  Categories getChosenCategory() {
    for (RadioModel rm in radioCategoryList) {
      if (rm.isSelected) {
        switch (rm.description) {
          case 'Baum':
            chosenCategory = Categories.tree;
            break;
          case 'Pflanze':
            chosenCategory = Categories.plant;
            break;
          case 'Pilze':
            chosenCategory = Categories.mushroom;
            break;
          case 'Tier':
            chosenCategory = Categories.animal;
            break;
          default:
            chosenCategory = Categories.undefined;
            break;
        }
      }
    }
    return chosenCategory;
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 10, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            // TODO: % of the screen or hard coded?
            height: MediaQuery.of(context).size.width * 0.20,
            width: MediaQuery.of(context).size.width * 0.20,
            child: Center(
              child: _item.buttonIcon,
            ),
            decoration: BoxDecoration(
              color:
              _item.isSelected ? Colors.green.shade300 : Colors.grey.shade300,
              border: Border.all(
                  width: 1.0,
                  color:
                  _item.isSelected ? Colors.green.shade500 : Colors.grey.shade300),
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
          ),
          Container(
            margin: EdgeInsets.all(2),
            child: Text(_item.description),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final Widget buttonIcon;
  final String description;

  RadioModel(this.isSelected, this.buttonIcon, this.description);
}
