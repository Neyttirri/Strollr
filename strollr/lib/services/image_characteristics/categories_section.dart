import 'package:flutter/material.dart';

class CategoriesRadioList extends StatefulWidget {
  @override
  createState() {
    return new CategoriesRadioListState();
  }
}

class CategoriesRadioListState extends State<CategoriesRadioList> {
  List<RadioModel> sampleData = [];

  @override
  void initState() {
    super.initState();
    _fillCategoriesRadioList();
  }

  void _fillCategoriesRadioList() {
    // TODO: get categories from the DB and create RadioModels
    sampleData.add(new RadioModel(false, Icon(Icons.brush), 'Baum'));
    sampleData.add(new RadioModel(false, Icon(Icons.brush), 'Pflanze'));
    sampleData.add(new RadioModel(false, Icon(Icons.brush), 'Pilze'));
    sampleData.add(new RadioModel(false, Icon(Icons.brush), 'Tier'));
  }

  List<Widget> _getAllCategoriesRadioButtons() {
    List<Widget> radioList = [];
    for (RadioModel radio in sampleData) {
      radioList.add(
        InkWell(
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              radio.isSelected = true;
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
              color: _item.isSelected ? Colors.green.shade300 : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.green.shade500 : Colors.grey),
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
