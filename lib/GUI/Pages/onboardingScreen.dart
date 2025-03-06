import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'loginScreen.dart';

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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      globalBackgroundColor: colorScheme.surface,
      allowImplicitScrolling: true,
      autoScrollDuration: 20000,
      infiniteAutoScroll: false,
      //Posible logo en el onboarding
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 15),
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(20),
      //         child: Image.asset(
      //           'assets/images/logo.png',
      //           width: 215,
      //           height: 70,
      //           errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      //             return Icon(Icons.error);
      //           },
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      pages: [
        PageViewModel(
          title: "Integrate en la comunidad",
          body: "Enterate de lo que piensan todos tus compañeros Universitarios.",
          image: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 360,
              height: 185,
              color: Colors.grey[50]!,
              child: Image.asset(
                'assets/images/logo_unimet.png',
                width: 350,
                height: 200,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Icon(Icons.error);
                },
              ),
            ),
          ),
          decoration: pageDecoration.copyWith(
            pageColor: colorScheme.surface,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            bodyTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        PageViewModel(
          title: "Encuentra tus objetos perdidos",
          body: "En comunidad todo se puede.",
          image: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/objetos_perdidos.png',
              width: 350,
              height: 200,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),
          decoration: pageDecoration.copyWith(
            pageColor: colorScheme.surface,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            bodyTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        PageViewModel(
          title: "Ve tu horario y el horario de tus amigos",
          body: "Podrás organizarte mejor al ver los huecos que tienen en común.",
          image: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 230,
            color: Colors.grey[50]!,
            child: Image.asset(
            'assets/images/animacion_horario.png',
            width: 350,
            height: 200,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Icon(Icons.error);
              },
              ),
              ),
            ),
          decoration: pageDecoration.copyWith(
            pageColor: colorScheme.surface,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            bodyTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        PageViewModel(
          title: "Encuentra ofertas",
          body: "Descubre las mejores ofertas disponibles solo para ti.",
          image: _buildImage('images/ofertas_feria.png'),
          decoration: pageDecoration.copyWith(
            pageColor: colorScheme.surface,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            bodyTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: Icon(Icons.arrow_back, color: colorScheme.primary),
      skip: Text(
        'Saltar',
        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
      ),
      next: Icon(Icons.arrow_forward, color: colorScheme.primary),
      done: Text(
        'Listo',
        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.primary),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: colorScheme.primary,
        activeColor: colorScheme.surface,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
