import 'package:flutter/material.dart';
import 'Pages/onboardingScreen.dart';
import 'theme/light_mode.dart';
import 'theme/dark_mode.dart';


import 'package:metrosync/MongoManager/Constant.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show Db, DbCollection, where, modify;
import '../MongoManager/MongoDB.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Navigation Bar',
      theme: lightMode,
      home: OnBoardingPage(),
    );
  }
}







