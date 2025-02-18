// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_prueba/MongoManager/Constant.dart';
import 'package:flutter_prueba/Schedules/Schedule.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show Db, DbCollection, where, modify;
import 'MongoManager/MongoDB.dart';
import 'GUI/GUI.dart';
import 'User/User.dart';
Future<void> main() async {
  //Ejemplo de como hacerlo TODO falta chekeos y Squemas
  MongoDB mongoDB = MongoDB();
  //await mongoDB.connect();
  //await mongoDB.close();
  //###########################Gabriel##############################
  /*Tiene que funcionar:
    ~Crear bloques de hora
    ~Mostrar informacion de los bloques de hora
    ~Eliminar bloques de hora
  */
  User currentuser= User('betatester', 'AAAA', '@betatester', 'Beta App', 'Tester');
  //Days=>lunes, martes, miercoles, jueves, viernes.
  currentuser.getmyschedule().newslot('lunes', 'randomclass', TimeOfDay(hour: 8, minute: 45), TimeOfDay(hour: 10, minute: 15));
  print(currentuser.getmyschedule().slotsPerDay[Day.lunes]);
  //###########################Gabriel##############################
  runApp(MyApp());
}

