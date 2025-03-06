import 'package:flutter/material.dart';


class TimeSlot {
  final String _classname;
  final TimeOfDay _starthour;
  final TimeOfDay _endhour;
  final String _profesor;
  final String _trimestre;
  final String _lugar;
 
  TimeSlot(
    this._classname,
    this._starthour,
    this._endhour,
    this._profesor,
    this._trimestre,
    this._lugar
  );
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      json['classname'],
      TimeOfDay(hour: json['start']['hour'], minute: json['start']['minute']),
      TimeOfDay(hour: json['end']['hour'], minute: json['end']['minute']),
      json['profesor'],
      json['trimestre'],
      json['lugar'],
    );
  }
  String toString() {
    return '$_classname - $_trimestre\nProf: $_profesor\nLugar: $_lugar\nHorario: $_starthour - $_endhour';
  }
   Map<String, dynamic> toJson() {
    return {
      'classname': _classname,
      'start': {'hour': _starthour.hour, 'minute': _starthour.minute},
      'end': {'hour': _endhour.hour, 'minute': _endhour.minute},
      'profesor': _profesor,
      'trimestre': _trimestre,
      'lugar': _lugar,
    };
  }




  // Getters existentes
  String getclassname() => _classname;
  TimeOfDay getstarthour() => _starthour;
  TimeOfDay getendhour() => _endhour;
 
  // Nuevos getters
  String getProfesor() => _profesor;
  String getTrimestre() => _trimestre;
  String getLugar() => _lugar;
}
