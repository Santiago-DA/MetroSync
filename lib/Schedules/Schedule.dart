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
 final String _username;
  Map<Day, List<TimeSlot>> slotsPerDay = {};
  var logger=Logger("MyLogger");
  
  Schedule(this._username);  //Constructor declaration
  MongoDB db = MongoDB();

  //Pasar la hora de inicio y fin como opciones fijas dadas por el sistemas
  void newslot(
    String day,
    String classname,
    TimeOfDay starthour,
    TimeOfDay endhour,
    String profesor,
    String trimestre,
    String lugar
  ) {
    TimeSlot newSlot = TimeSlot(
      classname,
      starthour,
      endhour,
      profesor,
      trimestre,
      lugar
    );
    _aggnewSlot(day, newSlot);
  }
   Future<void> loadfromBD() async {
    try {
      await MongoDB.connect();
      var scheduleData = await db.findOneFrom('Schedules', where.eq('username', _username));
      
      if (scheduleData != null) {
        // Lógica para cargar los slots desde JSON
      }
    } catch (e) {
      print('Error cargando horario: $e');
    } finally {
      await MongoDB.close();
    }
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
  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'slots': slotsPerDay.map((key, value) => 
        MapEntry(key.toString(), value.map((slot) => slot.toJson()).toList())),
    };
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



  void updateday(){
    //recibir el dia a actualizar desde el metodo de creacion
    //añadir slot a la coleccion
  }
 


}
}