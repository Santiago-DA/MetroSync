// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_prueba/MongoManager/Constant.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show Db, DbCollection, where, modify;

import 'MongoManager/MongoDB.dart';

Future<void> main() async {
  //Ejemplo de como hacerlo TODO falta chequeos y Esquemas
  MongoDB mongoDB = MongoDB();
  //await mongoDB.connect();
  //await mongoDB.close();
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
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LogInPage()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'images/logo.png',
                width: 215,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),

      pages: [
        PageViewModel(
          title: "Integrate en la comunidad UNIMETANA",
          body:
          "Enterate de lo que piensan todos tus compañeros Universitarios.",
          image:
          ClipRRect(
            borderRadius: BorderRadius.circular(20),  // Set the desired radius for rounded corners
            child: Image.asset(
              'images/BANDERA_UNIMET.jpg',  // Replace with your image source
              width: 350,  // Set the width of the image
              height: 200, // Set the height of the image
              fit: BoxFit.cover,  // Set the fit for the image
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Encuentra tus objetos perdidos",
          body:
          "En comunidad todo se puede.",
          image:
          ClipRRect(
            borderRadius: BorderRadius.circular(20),  // Set the desired radius for rounded corners
            child: Image.asset(
              'images/objetos_perdidos.png',  // Replace with your image source
              width: 350,  // Set the width of the image
              height: 200, // Set the height of the image
              fit: BoxFit.cover,  // Set the fit for the image
            ),
          )
          ,
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ve tu horario y el horario de tus amigos",
          body:
          "Podrás organizarte mejor al ver los huecos que tienes en común.",
          image: _buildImage('images/horarios.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ofertas",
          body:
          "Descubre las mejores ofertas disponibles solo para ti.",
          image: _buildImage('images/ofertas_feria.png'),
          decoration: pageDecoration,
        ),


      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Saltar', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      next: const Icon(Icons.arrow_forward, color: Colors.black),
      done: const Text('Listo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.black,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

// pagina principal
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

//pagina de inicio de sesion (falta api de google para inicio de sesion
class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Inicio de sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Ir a la página principal'),
            ),
          ],
        ),
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
