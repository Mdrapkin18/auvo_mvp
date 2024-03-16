// bottom_nav_bar.dart
import 'package:auvo_mvp/screens/home.dart';
import 'package:auvo_mvp/screens/search_history.dart';
import 'package:auvo_mvp/screens/settings/settings.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int indexfrompage;

  const BottomNavBar({super.key, required this.indexfrompage});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var _selectedIndex;
  final List<Widget> _widgetOptions = [
    HomeScreen(index: 0), // Placeholder for HomePage widget
    SearchHistory(index: 1), // Placeholder for HistoryPage widget
    SettingsPage(index: 2), // Placeholder for SettingsPage widget
  ];

  void _onItemTapped(int index) {
    print('clicked: $index');
    print('page: ${widget.indexfrompage}');
    print('selected $_selectedIndex');
    if (widget.indexfrompage != index) {
      setState(() {
        _selectedIndex = index;
        print('selected $_selectedIndex');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _widgetOptions[index]),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: widget.indexfrompage,
      onTap: _onItemTapped,
    );
  }
}
