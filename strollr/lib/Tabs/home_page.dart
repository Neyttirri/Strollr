import 'package:flutter/material.dart';
import 'package:strollr/Tabs/active_route.dart';
import 'package:strollr/Tabs/collection.dart';
import 'package:strollr/Tabs/routes.dart';
import 'package:strollr/Tabs/stats.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  int _currentIndex = 1;
  //int openAppIndex = 1;

  PageController _pageController = PageController();
  List<Widget> _screens = [
    Collection(), Routes(), Stats()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onTapChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      /*
      Navigator(
        onGenerateRoute: (settings) {
          Widget page = ActiveRoute();
          if (settings.name == 'newRoute') page = ActiveRoute();
          if (settings.name == 'Collection') page = Collection();
          if (settings.name == 'Route') page = Routes();
          if (settings.name == 'Stats') page = Stats();
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
      */
      bottomNavigationBar:
        BottomNavigationBar(
          currentIndex: this._currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: (int index){
            setState(() {
              print(index);
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
           /*
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, 'Collection');
                  break;
                case 1:
                  Navigator.pushNamed(context, 'Route');
                  break;
                case 2:
                  Navigator.pushNamed(context, 'Stats');
                  break;
              };
            },*/
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.collections),
                label: "Sammlung"),
            BottomNavigationBarItem(
                icon: const Icon(Icons.directions_walk),
                label: "Routen"),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: "Statistik"),
          ],
        )
    );
  }

  void _onTapChanged(int index) {
    setState(() {
      _currentIndex = index;

      /*
      if(index == 0) {
        _currentIndex = 3;
      } else if(index == 1) {
        _currentIndex = 1;
      } else if(index == 2) {
        _currentIndex = 4;
      }
       */
    });
  }

  void _onItemTaped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
}