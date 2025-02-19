import 'package:flutter/material.dart';
import 'package:flutter_prueba/Schedules/ScheduleScreen.dart';
import 'package:flutter_prueba/MongoManager/Constant.dart';
import 'package:flutter_prueba/Schedules/Schedule.dart';
import 'package:mongo_dart/mongo_dart.dart'

    show Db, DbCollection, where, modify;
import '../MongoManager/MongoDB.dart';

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

// Página de inicio
class HomePage extends StatelessWidget {
  final VoidCallback onMailPressed;

  const HomePage({
    super.key,
    required this.onMailPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Página de Inicio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: onMailPressed,
              child: const Text('Objetos Perdidos'),
            ),
          ],
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