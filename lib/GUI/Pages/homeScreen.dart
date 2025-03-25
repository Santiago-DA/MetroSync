import 'package:flutter/material.dart';

import 'package:metrosync/GUI/Pages/ScheduleScreen.dart';

// Otras páginas

import 'profileScreen.dart';
import 'homepageScreen.dart';
import "userlistScreen.dart";
import "FriendRequestsPage.dart";
import 'lostitemsScreen.dart';

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

    // Lista de páginas
    _pages = [
      ScheduleScreen(key: UniqueKey()), // Pantalla de horarios
      HomePage(
        key: UniqueKey(),
        onMailPressed: _navigateToFriendRequestsPage,
        onhandpressed: _navigateToUP,
      ),
      LostItemsPage(key: UniqueKey()),// Pantalla de inicio
      ProfilePage(key: UniqueKey()), // Pantalla de perfil
    ];
  }

  // Navegar a la página de objetos perdidos

  void _navigateToFriendRequestsPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FriendRequestsPage(key: UniqueKey()),
    ),
  );
}

  void _navigateToUP() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Userlist(key: UniqueKey()),
      ),
    );
  }


  // Cambiar de página
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _pages[_currentIndex], // Mostrar la página actual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _changePage(index), // Cambiar de página al tocar un ícono
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 10.0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '', // Ícono para horarios
          ),
          BottomNavigationBarItem(
            icon: Opacity(
            opacity: 1,
            child: Icon(Icons.home),
          ),
            label: '', // Ícono para inicio
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: '', // Ícono para perfil
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