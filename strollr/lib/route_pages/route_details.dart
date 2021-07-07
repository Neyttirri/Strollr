import 'package:flutter/material.dart';
import 'package:strollr/Tabs/routes.dart';
import '../style.dart';
import 'package:gpx/gpx.dart';
import 'package:strollr/maps_test_two.dart';
import 'dbInterface.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController _controller =
    TextEditingController(); // Name aus Datenbank
bool _isEnable = false;
late int walkId;
late String nName;

class RouteDetails extends StatefulWidget {
  late int walkId;

  RouteDetails(int walkId) {
    this.walkId = walkId;

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
                Navigator.of(context).pop();
              }),
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [RouteForm(walkId), buttonRow(context)],
                  ),
                ))));
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

    map.createPolyLines(route);
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
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: FutureBuilder(
              future: setDistance(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData){
                  return Row(
                    children: <Widget>[
                      Text("Distanz:", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text(distance.toString() + 'km', style: TextStyle(fontSize: 18),),
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
                      Text(duration.toString() + 'h', style: TextStyle(fontSize: 18),),
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

class SaveButton extends StatefulWidget {
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          padding:
          EdgeInsets.all(10),
          primary: Colors.white,
          textStyle: TextStyle(fontSize: 18),
          backgroundColor: headerGreen,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await DbRouteInterface.setWalkName(walkId: walkId, name: nName);

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Route wird gespeichert', style: TextStyle(fontSize: 50),)));
            setState(() {
              _isEnable = false;
            });
            Navigator.of(context).pop();
                //.push(MaterialPageRoute(builder: (context) => Routes()));
            // neuen Routennamen in Datenbank übernehmen
          }
        },
        child: Text('Speichern'),
      ),
    );
  }
}

Widget deleteButton(BuildContext context) {
  return SizedBox(
    width: 150,
    //height: 50,
    child: ElevatedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(10),
        primary: headerGreen,
        textStyle: TextStyle(fontSize: 18),
        backgroundColor: Colors.white,
      ),
      onPressed: () async {
        await DbRouteInterface.deleteWalk(walkId: walkId);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Route wird gelöscht', style: TextStyle(fontSize: 20),)));
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Routes()), (Route<dynamic> route) => false);
      },
      child: Text(' Route löschen'),
    ),
  );
}

Widget buttonRow(BuildContext context) {
  return Container(
      padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [deleteButton(context), SaveButton()],
      ));
}
