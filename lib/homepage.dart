import 'package:flutter/material.dart';
import 'package:final_project/models/todo_item.dart';
import 'package:final_project/pages/stats.dart';
import 'package:final_project/pages/todo.dart';
import 'package:final_project/pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // app starts on "To Do" page

  // 🔥 Use the SAME TYPE that UserStats expects
  List<TodoItem> tasks = [];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build pages dynamically so they always get the latest tasks
    final List<Widget> _pages = [
      UserStats(tasks: tasks),  // PASS TodoItem list here
      UserTodo(tasks: tasks),   // (we can link this later)
      UserSettings(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5E4D7),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFAAC1B2),
        unselectedItemColor: const Color(0xFF73877B),
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.equalizer), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'To Do'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
