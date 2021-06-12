import 'package:flutter/material.dart';
import 'package:strollr/model/picture_categories.dart';

class CategoriesIcons {

  static Categories chosenCategory = Categories.undefined;

  // TODO: get categories from the DB and create RadioModels
  static List<RadioModel> radioList = [
    new RadioModel(false, Icon(Icons.brush), 'Baum'),
    new RadioModel(false, Icon(Icons.brush), 'Pflanze'),
    new RadioModel(false, Icon(Icons.brush), 'Pilze'),
    new RadioModel(false, Icon(Icons.brush), 'Tier')
  ];

  static Categories getChosenCategory() {
    for (RadioModel rm in radioList) {
      if(rm.isSelected) {
        switch(rm.description) {
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

class CategoriesRadioList extends StatefulWidget {
  @override
  createState() {
    return new CategoriesRadioListState();
  }
}

class CategoriesRadioListState extends State<CategoriesRadioList> {

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _getAllCategoriesRadioButtons() {
    List<Widget> radioList = [];
    for (RadioModel radio in CategoriesIcons.radioList) {
      radioList.add(
        InkWell(
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              CategoriesIcons.radioList.forEach((element) => element.isSelected = false);
              radio.isSelected = true;
              CategoriesIcons.getChosenCategory();
            });
          },
          child: new RadioItem(radio),
        ),
      );
    }

    return radioList;
  }

  @override
  Widget build(BuildContext context) {
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
