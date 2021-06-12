import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/utils/loading_screen.dart';
import 'package:strollr/services/camera/save_picture.dart';
import 'categories_section.dart';

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
  String color = '';
  String size = '';
  String description = '';

  Categories chosenCategory = Categories.undefined;
  late File image;
  late AnimationController _animationController;

  // TODO: get categories from the DB and create RadioModels
  List<RadioModel> radioCategoryList = [
    new RadioModel(false, Icon(Icons.brush), 'Baum'),
    new RadioModel(false, Icon(Icons.brush), 'Pflanze'),
    new RadioModel(false, Icon(Icons.brush), 'Pilze'),
    new RadioModel(false, Icon(Icons.brush), 'Tier')
  ];

  // for each category there are two questions
  // in the list the order is: question - helper text to first question - next question - helper text to second question
  Map<Categories, List<String>> questionsForCategory = {
    Categories.animal: [
      'Was für ein Tier ist das?',
      'helperText1..tbd',
      'Womit ernährt sich das Tier?',
      'helperText2..tbd'
    ],
    Categories.mushroom: [
      'Was für ein Pilz ist das?',
      'helperText3..tbd',
      'Ist es giftig oder kann man es essen?',
      'helperText4..tbd'
    ],
    Categories.plant: [
      'Was für eine Pflanze ist das?',
      'helperText5..tbd',
      'Wann und wie oft blühtet diese Pflanze?',
      'helperText6..tbd'
    ],
    Categories.tree: [
      'Was für einen Baum ist das?',
      'helperText7..tbd',
      'Wo wachsen solche Bäume nicht?',
      'helperText8..tbd'
    ],
  };

  @override
  void initState() {
    super.initState();
    __initializeAsync();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    //Timer(Duration(milliseconds: 200), () => _animationController.forward());
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
        // TODO makes sense?
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
              await Future.delayed(Duration(seconds: 0)).then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavePhotoScreen(
                      color: color,
                      size: size,
                      description: description,
                      category: CategoriesIcons.getChosenCategory(),
                      imageBytes: _getImageData() as Uint8List,
                      imagePath: image.path,
                      //imageLocation: widget.arguments[1]
                    ),
                  ),
                ),
              );
            },
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
                color: Color(0xFFDDDDDD),
              ),
              // here are all the fields the user has to fill
              child: ListView(
                children: <Widget>[
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: new DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.fill,
                            ),
                          ), // just an empty TODO: show image here
                        ),
                ],
              ),
            ),
    );
    // bottomNavigationBar: _buildFunctions(),
  }

  Widget _generateQuestion(String question, String helpText) {
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
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          onChanged: (value) {
            this.color = value;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            helperText: helpText,
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
    return Column(children: [
      _generateQuestion(questionsForCategory[chosenCategory]![0],
          questionsForCategory[chosenCategory]![1]),
      Padding(padding: EdgeInsets.only(top: distanceBetweenElements)),
      _generateQuestion(questionsForCategory[chosenCategory]![2],
          questionsForCategory[chosenCategory]![3]),
    ]);
  }

  Widget _getDescriptionField() {
    return Container(
      margin: EdgeInsets.only(top: distanceBetweenElements),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Erzähl was du darüber weißt! ',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
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
              getChosenCategory();
              print(getChosenCategory());
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

  Future<Uint8List> _getImageData() async {
    return await image.readAsBytes();
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            // TODO: % of the screen or hard coded?
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.height * 0.07,
            child: Center(
              child: _item.buttonIcon,
            ),
            decoration: BoxDecoration(
              color:
                  _item.isSelected ? Colors.green.shade300 : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color:
                      _item.isSelected ? Colors.green.shade500 : Colors.grey),
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

/*
Widget _getColorField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Was für Farben sind auf dem Bild? ',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
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
              filled: true,
              fillColor: Colors.white,
              helperText: 'zB lila, grün, ...',
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
              filled: true,
              fillColor: Colors.white,
              helperText: 'zB wie ein Elefant',
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
 */
