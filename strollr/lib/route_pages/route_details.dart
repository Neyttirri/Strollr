import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strollr/Tabs/routes.dart';
import '../style.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/maps_test_two.dart';
import 'dbInterface.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _controller = TextEditingController(); // Name aus Datenbank
bool _isEnable = false;
late int walkId;
late String nName;

class RouteDetails extends StatefulWidget {
  late int walkId;
  late int navigationID;

  RouteDetails(int walkId, int navigationID) {
    this.walkId = walkId;
    this.navigationID = navigationID;

    setTextEditor();
  }

  setTextEditor() async {
    String name = await DbRouteInterface.getWalkName(walkId: walkId);

    _controller = TextEditingController(text: name);
  }

  _RouteDetailsState createState() => _RouteDetailsState(walkId);
}

class _RouteDetailsState extends State<RouteDetails> {
  late int walkId;
  late int navigationID = widget.navigationID;

  final int ID_DELETE = 0;
  final int ID_SAVE = 1;

  _RouteDetailsState(int walkId){
    this.walkId = walkId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Routenübersicht',
              style: TextStyle(color: headerGreen)),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: headerGreen),
              onPressed: () {
                //Navigator.of(context).pop();
                if(navigationID == 1) {
                  Navigator.of(context).pop();
                } else if(navigationID == 2) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Routes()));
                }
              }),
          iconTheme: IconThemeData(
            color: headerGreen,
          ),
          actions: [
            getImageMenuRoute(context),
          ],
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SingleChildScrollView(
              child: Column(
                children: [RouteForm(walkId)],
              ),
            ),
        ),
    );
  }

  Widget getImageMenuRoute(BuildContext context) {
    return PopupMenuButton(
      elevation: 3.2,
      offset: Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      onSelected: (choice) {
        if (choice == ID_DELETE) {
          confirmDeleting(context);
        } else if (choice == ID_SAVE) {
          saveRoute(context);
        } else
          print('nothing chosen !!  ');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.delete),
              Container(
                margin: EdgeInsets.only(left:10),
                child: Text('Löschen'),
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
              Icon(Icons.save_alt),
              Container(
                margin: EdgeInsets.only(left:10),
                child: Text('Speichern'),
              ),
            ],
          ),
          //width: 10,
        ),
      ],
    );
  }
  deleteRoute(BuildContext context) async {
    await DbRouteInterface.deleteWalk(walkId: walkId);
    Fluttertoast.showToast(
      msg: 'Gelöscht',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      textColor: Color(0xffffffff),
    );
  }

  confirmDeleting(BuildContext context) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'Bist du sicher, dass du die Route löschen möchtest?'),
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
                  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Routes()), (route) => false);
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Routes()));

                  Navigator.of(context).pop();

                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).maybePop();
                  });
                  deleteRoute(context);
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
  saveRoute(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await DbRouteInterface.setWalkName(walkId: walkId, name: nName);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Route wird gespeichert', style: TextStyle(fontSize: 20),)));
      setState(() {
        _isEnable = false;
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Routes()), (route) => false);
      //Navigator.of(context).pop();
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Routes()));
      //.push(MaterialPageRoute(builder: (context) => Routes()));
      // neuen Routennamen in Datenbank übernehmen
    }
  }
}

class RouteForm extends StatefulWidget {
  late int walkId;

  RouteForm(int walkId){
    this.walkId = walkId;
  }

  @override
  RouteFormState createState() => RouteFormState(walkId);
}

class RouteFormState extends State<RouteForm> {
  //related to WalkID
  late MapView map;

  late String name;
  late String started;
  late double distance;
  late String duration;
  late Gpx route;

  RouteFormState(int id){
    walkId = id;

    setRoute();
  }

  @override
  void initState() {
    super.initState();

    map = new MapView();

    ///creates polylines after widget is built
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => drawDemPolylines());
  }

  drawDemPolylines() async {
    await setRoute();

    var gpxString = GpxWriter().asString(route, pretty: true);
    print(gpxString);

    map.createPolyLines(gpx: route, walkId: walkId);
  }

  setRoute() async {
    route = await DbRouteInterface.getWalkRoute(walkId: walkId);
  }

  ///returns true when each attribute is set
  Future<bool> setName() async {
    name = await DbRouteInterface.getWalkName(walkId: walkId);

    print(name);

    return true;
  }


  Future<bool> setDistance() async {
    distance = await DbRouteInterface.getWalkDistance(walkId: walkId);

    distance = double.parse((distance).toStringAsFixed(2));

    return true;
  }

  Future<bool> setDuration() async {
    duration = await DbRouteInterface.getWalkDuration(walkId: walkId);

    return true;
  }

  Future<bool> setStarted() async {
    started = await DbRouteInterface.getWalkName(walkId: walkId);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // walkID
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FutureBuilder(
                future: setName(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData){
                    return nameWidget(context);
                  }
                  return Row();
                }),
          ),
          Row(
            children: [new Expanded(child: map)],
          ), //insert map
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: FutureBuilder(
              future: setDistance(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return Row(
                    children: <Widget>[
                      Text("Distanz:", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text(distance.toString() + ' km', style: TextStyle(fontSize: 18),),
                    ],
                  );
                }
                else {
                  return Row(
                    children: <Widget>[
                      Text("Distanz:", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text('', style: TextStyle(fontSize: 18),),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: FutureBuilder(
              future: setDuration(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return Row(
                    children: <Widget>[
                      Text("Dauer:", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text(duration.toString() + ' h', style: TextStyle(fontSize: 18),),
                    ],
                  );
                }
                else {
                  return Row(
                    children: <Widget>[
                      Text("Dauer:", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text('', style: TextStyle(fontSize: 18),),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget nameWidget(BuildContext context){
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: _controller,
          enabled: _isEnable,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
              hintText: 'Gib deiner Route einen Namen',
              //labelText: 'Routenname'
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          validator: (value) {
            nName = value!;

            if (value.isEmpty) {
              return 'Bitte gib einen Routennamen ein';
            }
            return null;
          },
          style: TextStyle(
            color: headerGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      IconButton(
          onPressed: () {
            setState(() {
              _isEnable = true;
            });
          },
          icon: Icon(Icons.edit))
    ]);
  }
}
