import 'package:final_project/pages/stats.dart';
import 'package:final_project/pages/todo.dart';
import 'package:final_project/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; //set to 1 so app starts on to do list page

  void _navigateBottomBar(int index) {
    setState( () {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    UserStats(),
    UserTodo(),
    UserSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5E4D7), // background of the bar
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFAAC1B2),       // active icon & label
        unselectedItemColor: Color(0xFF73877B), // inactive icons & labels
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'To Do'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
