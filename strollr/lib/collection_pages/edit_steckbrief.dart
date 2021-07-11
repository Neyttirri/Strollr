import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:strollr/collection_pages/steckbrief_secondVersion.dart';
import 'package:strollr/db/database_manager.dart';
import 'package:strollr/model/picture_categories.dart';
import 'package:strollr/model/picture.dart';
import 'package:strollr/style.dart';
import '../globals.dart';
import '../logger.dart';

class EditSteckbriefScreen extends StatefulWidget {
  final Picture picture;
  late int navigationID;

    EditSteckbriefScreen({required this.picture, required this.navigationID});

    @override
    _EditSteckbriefScreenState createState() => _EditSteckbriefScreenState();

}

class _EditSteckbriefScreenState extends State<EditSteckbriefScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  final double distanceBetweenElements = 25;
  late String genericInfo1;
  late String genericInfo2;
  late String description;

  late Picture image;
  late Categories chosenCategory;

  late int _navigationID;


  List<RadioModel> radioCategoryList = [
    new RadioModel(false, Image.asset(treeImagePath), 'Baum', Categories.tree),
    new RadioModel(
        false, Image.asset(plantImagePath), 'Pflanze', Categories.plant),
    new RadioModel(
        false, Image.asset(mushroomImagePath), 'Pilze', Categories.mushroom),
    new RadioModel(
        false, Image.asset(animalImagePath), 'Tier', Categories.animal)
  ];

  // for each category there are two questions
  // in the list the order is: question - helper text to first question - next question - helper text to second question

  @override
  void initState() {
    super.initState();
    _navigationID = widget.navigationID;
    image = widget.picture;
    genericInfo1 = image.generic1;
    genericInfo2 = image.generic2;
    description = image.description;
    chosenCategory = idToCategoryMap[image.category]!;
    radioCategoryList.forEach((element) {
      if (element.category == chosenCategory) {
        element.isSelected = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 10,
        title: Text(
          "Steckbrief bearbeiten",
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              ApplicationLogger.getLogger('_EditSteckbriefScreenState',
                      colors: true)
                  .d('updating image and info');
              _updatePicture();
              Future.delayed(Duration(milliseconds: 1500)).then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Steckbrief_2(picture: image, navigationID: _navigationID)),
                ),
              );
              //Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundGrey,
        ),
        // here are all the fields the user has to fill
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                'Kategorie: ',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _getCategoryField(),
            // get all categories with icons, as a list that is horizontally scrollable
            Column(
              children: [
                chosenCategory != Categories.undefined
                    ? _getQuestionsForCategory()
                    : Text(''),
                _getDescriptionField(),
              ],
            ),
          ],
        ),
      ),
    );
    // bottomNavigationBar: _buildFunctions(),
  }

  Widget _generateQuestion(
      String question, String helpText, bool isFirstQuestion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
          child: Text(
            question,
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          controller: TextEditingController()
            ..text = isFirstQuestion ? image.generic1 : image.generic2,
          cursorColor: Colors.black,
          //textCapitalization: TextCapitalization.words,
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
              borderRadius: BorderRadius.circular(15),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              descriptionField,
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextField(
            controller: TextEditingController()..text = image.description,
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
              chosenCategory = radio.category;
              ApplicationLogger.getLogger('_DescribePhotoScreenState',
                      colors: true)
                  .d('chosen category: ${chosenCategory.toString()} ');
            });
          },
          child: new RadioItem(radio),
        ),
      );
    }

    return radioList;
  }

  _updatePicture() async {
    image.generic1 = genericInfo1;
    image.generic2 = genericInfo2;
    image.description = description;
    image.category = await DatabaseManager.instance
        .getCategoryIdFromCategory(chosenCategory);
    await DatabaseManager.instance.updatePicture(image);
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
  final Categories category;

  RadioModel(this.isSelected, this.buttonIcon, this.description, this.category);
}
