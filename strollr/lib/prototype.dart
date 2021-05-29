import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    ),
    home: MyHomePage(title: 'Strollr'),
   );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  //RestorableInt _currentIndex = RestorableInt(0);

  void _incrementCounter() {
    setState(() {
    _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
          'You have pushed the button this many times:',
          ),
          MyButton(_counter),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      ),
    bottomNavigationBar:
    BottomNavigationBar(
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.collections), label: "Collection"),
        BottomNavigationBarItem(icon: const Icon(Icons.directions_walk), label: "Routes"),
        BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: "Statistik")
      ],
      //currentIndex: _currentIndex.value,
    ),
    );
  }
}

class MyButton extends StatelessWidget {
  int counter;
  MyButton(int this.counter);

  @override
  Widget build(BuildContext context) {
  return InkWell(
    onTap: () {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Strollr"))
        );
      },
    child: Container(
      padding: EdgeInsets.all(12),
      child: Text(
        '$counter',
        style: Theme.of(context).textTheme.headline4,
        ),
      )
    );
  }
}

class DrawerExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}