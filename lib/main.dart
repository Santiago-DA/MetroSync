// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(key: UniqueKey()),
    );
  }
}

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
      SchedulePage(key: UniqueKey()), 
      HomePage(
        key: UniqueKey(),
        onMailPressed: _navigateToLostItemsPage, 
      ),
      ProfilePage(key: UniqueKey()), 
    ];
  }

  // Método para navegar a la página de objetos perdidos
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
      body: _pages[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _changePage(index), 
        backgroundColor: Colors.white,
        elevation: 10.0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

// Página de inicio
class HomePage extends StatelessWidget {
  final VoidCallback onMailPressed;

  const HomePage({
    super.key,
    required this.onMailPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text(
            'Página de Inicio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.outbox_rounded, size: 30),
            onPressed: onMailPressed,
          ),
        ),
      ],
    );
  }
}

// Página de horarios
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Página de Horarios',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Página de perfil
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Página Perfil',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Página de Objetos Perdidos
class LostItemsPage extends StatelessWidget {
  const LostItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, 
        title: const SizedBox.shrink(), 
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        
      ),
      body: const Center(
        child: Text(
          'Página de Objetos Perdidos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}