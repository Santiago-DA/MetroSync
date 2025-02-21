import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:metrosync/GUI/Pages/ScheduleScreen.dart';
import 'package:metrosync/Schedules/Schedule.dart';

//otras paginas
import 'lostitemsScreen.dart';
import 'profileScreen.dart';
import 'homepageScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      ScheduleScreen(key: UniqueKey()), // <-- Nueva pantalla de horarios
      HomePage(
        key: UniqueKey(),
        onMailPressed: _navigateToLostItemsPage,
      ),
      ProfilePage(key: UniqueKey()),
    ];
  }

  void _navigateToLostItemsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LostItemsPage(key: UniqueKey()),
      ),
    );
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _changePage(index),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 10.0,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '', // Ícono para horarios
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // Ícono para inicio
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // Ícono para perfil
          ),
        ],
      ),
    );
  }
}
