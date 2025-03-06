import 'package:flutter/material.dart';
import '../MongoManager/MongoDB.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'TimeSlot.dart';
import 'package:logging/logging.dart';




//Para guardar los documentos en la BD debo serializarlos a json.
enum Day { lunes, martes, miercoles, jueves, viernes }
class Schedule {
 final String _username;
  Map<Day, List<TimeSlot>> slotsPerDay = {};
  var logger=Logger("MyLogger");
 
  Schedule(this._username);  //Constructor declaration
  MongoDB db = MongoDB();


   Day strtoenum(String str) {
    switch (str.toLowerCase()) {
      case 'lunes': return Day.lunes;
      case 'martes': return Day.martes;
      case 'miercoles': return Day.miercoles;
      case 'jueves': return Day.jueves;
      case 'viernes': return Day.viernes;
      default: throw ArgumentError('Día no válido: $str');
    }
  }
  //Pasar la hora de inicio y fin como opciones fijas dadas por el sistemas
  void newslot(String day, TimeSlot newSlot) {
    final dayEnum = strtoenum(day);
    _aggnewSlot(dayEnum, newSlot);
    saveToDB(); // Guardar cambios en la BD
  }
  Future<void> loadfromBD() async {
  try {
    await MongoDB.connect();
    var scheduleData = await db.findOneFrom('Schedules', where.eq('username', _username));
   
    if (scheduleData != null) {
      slotsPerDay.clear();
      var slotsData = scheduleData['slots'] as Map<String, dynamic>;
      slotsData.forEach((dayStr, slotsList) {
        Day day = strtoenum(dayStr.split('.').last); // Ej: 'lunes'
        slotsPerDay[day] = (slotsList as List)
            .map((slot) => TimeSlot.fromJson(slot))
            .toList();
      });
    }
  } catch (e) {
    print('Error cargando horario: $e');
  } finally {
    await MongoDB.close();
  }
}
Future<void> saveToDB() async {
  try {
    await MongoDB.connect(); // Abrir la conexión a la base de datos

    // Convertir el horario a JSON
    var scheduleJson = this.toJson();

    // Verificar si ya existe un horario para este usuario
    var existingSchedule = await db.findOneFrom('Schedules', where.eq('username', _username));

    if (existingSchedule != null) {
      // Si existe, actualizar el horario existente
      await db.updateOneFrom(
        'Schedules',
        where.eq('username', _username), // Filtro para encontrar el documento del usuario
        modify.set('slots', scheduleJson['slots']) // Actualizar solo el campo 'slots'
      );
      print('Horario actualizado exitosamente.');
    } else {
      // Si no existe, insertar un nuevo horario
      await db.insertInto('Schedules', scheduleJson);
      print('Nuevo horario insertado exitosamente.');
    }
  } catch (e) {
    print('Error guardando horario: $e');
    throw e;
  } finally {
    await MongoDB.close(); // Cerrar la conexión a la base de datos
  }
}



  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'slots': slotsPerDay.map((key, value) =>
        MapEntry(key.toString(), value.map((slot) => slot.toJson()).toList())),
    };
  }


  //Literally made on china
  void _aggnewSlot(Day day, TimeSlot newSlot) {
    slotsPerDay[day] ??= [];
    final list = slotsPerDay[day]!;
    // Inserta manteniendo orden cronológico
    int index = list.indexWhere((b) => b.getstarthour().isAfter(newSlot.getstarthour()));
    if (index == -1) index = list.length;
    list.insert(index, newSlot);
  }


  // Eliminar un TimeSlot del horario
void removeSlot(Day day, String className, TimeOfDay start, TimeOfDay end) async {
  if (!slotsPerDay.containsKey(day) || slotsPerDay[day]!.isEmpty) {
    logger.warning("Intento de borrar slot en $day: No existen slots para este día");
    return;
  }

  final slots = slotsPerDay[day]!;
  final index = slots.indexWhere((slot) =>
      slot.getclassname() == className &&
      slot.getstarthour() == start &&
      slot.getendhour() == end);

  if (index == -1) {
    logger.warning("Slot no encontrado en $day: $className (${start.hour}:${start.minute} - ${end.hour}:${end.minute})");
    return;
  }

  slots.removeAt(index);
  logger.info("Slot eliminado en $day: $className (${start.hour}:${start.minute} - ${end.hour}:${end.minute})");

  // Guardar cambios en la base de datos
  await saveToDB();
saveToDB(); // Guardar cambios en la BD
}
}
