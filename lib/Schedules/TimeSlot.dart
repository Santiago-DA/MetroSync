import 'package:flutter/material.dart';

class TimeSlot{
  //Nombre de clase (con limte de caracteres por la BD)
  //Hora inicio de clase (Ofrecer horas y minutos por separado, guardarlo con algun tipo de formato de hora)
  //Hora final de la clase
  //Atributos finales no pueden  darse un valor luego de que hayan sido inicializados. Si no son finales, debes inicializarlos de una o (preferiblemente, con el constructor). No pueden ser null por una actualizacion "Null safty" de dart (2.12)
  final String _classname;
  final TimeOfDay _starthour;
  final TimeOfDay _endhour;
  
  TimeSlot(this._classname,this._starthour,this._endhour);
  
  String toString() {
    return '$_classname : $_starthour - $_endhour';
  }

  String getclassname(){
    return _classname;
  }

  TimeOfDay getstarthour(){
    return _starthour;
  }

  TimeOfDay getendhour(){
    return _endhour;
  }
}