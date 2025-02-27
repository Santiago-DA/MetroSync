import 'package:flutter/material.dart';
import '../MongoManager/MongoDB.dart';
import '../User/User.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'TimeSlot.dart';
import 'package:logging/logging.dart';
import 'dart:io';

//Para guardar los documentos en la BD debo serializarlos a json.
enum Day { lunes, martes, miercoles, jueves, viernes }
class Schedule {
  ///Hacer el metodo to js
  //El usuario
  //La forma de almacenamiento que me dio deepseek
  //Creacion de bloque
  Map<Day, List<TimeSlot>> slotsPerDay = {};
  final User _user;
  var logger=Logger("MyLogger");
  //.warning
  //.severe
  //.info
  Schedule(this._user); //Constructor declaration
  MongoDB db = MongoDB();

  //Pasar la hora de inicio y fin como opciones fijas dadas por el sistemas
  void newslot(String day,String classname,TimeOfDay starthour,TimeOfDay endhour){
    //nombreClase.length > maxLongitud. Verificar en el frontend.
    TimeSlot newSlot= TimeSlot(classname, starthour, endhour);
    _aggnewSlot(day, newSlot);
  }

  Day _strtoenum(String str){
    switch (str) {
      case 'lunes':
        return Day.lunes;
      case 'martes':
        return Day.martes;
      case 'miercoles':
        return Day.miercoles;
      case 'jueves':
        return Day.jueves;
      case 'viernes':
        return Day.viernes;
    }
    return Day.lunes;
  }

  //Literally made on china
  void _aggnewSlot(String str, TimeSlot newslot) {
    Day day=_strtoenum(str);
  slotsPerDay[day] ??= [];
  final list = slotsPerDay[day]!;
  // Inserta manteniendo orden cronológico
  int index = list.indexWhere((b) => b.getstarthour().isAfter(newslot.getstarthour()));
  if (index == -1) index = list.length;
  list.insert(index, newslot);
  }
  
  void removeSlot(Day day, String className, TimeOfDay start, TimeOfDay end) {
  // Verificar si el día existe y tiene slots
  if (!slotsPerDay.containsKey(day) || slotsPerDay[day]!.isEmpty) {
    logger.warning("Intento de borrar slot en $day: No existen slots para este día");
    return;
  }

  final slots = slotsPerDay[day]!;
  
  // Buscar el slot específico
  final index = slots.indexWhere((slot) =>
    slot.getclassname() == className &&
    slot.getstarthour() == start &&
    slot.getendhour() == end);

  if (index == -1) {
    logger.warning("Slot no encontrado en $day: $className (${start.hour}:${start.minute} - ${end.hour}:${end.minute})");
    return;
  }

  // Eliminar y registrar
  slots.removeAt(index);
  logger.info("Slot eliminado en $day: $className (${start.hour}:${start.minute} - ${end.hour}:${end.minute})");

  //Actualizacion de la bd por cada metodo que cambie el horario
  //Cargar desde la bd al iniciar la sesion

  void loadfromBD(){
    //Revisar si existe una colección con el PK del usuario 
    //Si existe, cargarla, caso contrario. Se crea una.
  }

  void updateday(){
    //recibir el dia a actualizar desde el metodo de creacion
    //añadir slot a la coleccion
  }


}
}