import 'package:flutter/material.dart';
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
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.collections),
                label: "Sammlung"),
            BottomNavigationBarItem(
                icon: const Icon(Icons.directions_walk),
                label: "Routen"),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: "Statistik")
          ],
        )
    );
  }

  void _onTapChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTaped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
}