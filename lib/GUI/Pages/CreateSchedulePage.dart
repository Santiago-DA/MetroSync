import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Importar la clase Schedule
import 'package:metrosync/Schedules/TimeSlot.dart'; // Importar la clase TimeSlot


class CreateSchedulePage extends StatefulWidget {
  final Function(TimeSlot, String) onSave; // Cambiar para recibir TimeSlot y String


  const CreateSchedulePage({super.key, required this.onSave});


  @override
  _CreateSchedulePageState createState() => _CreateSchedulePageState();
}


class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController materiaNombreController = TextEditingController();
  final TextEditingController aulaController = TextEditingController();
  final TextEditingController profesorController = TextEditingController();
  List<String> selectedDias = [];
  String? horaInicio;
  String? horaFinal;
  String? trimestre;


  final List<String> dias = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes'];
  final List<String> horasGrupo1 = _generarHoras(
    start: const TimeOfDay(hour: 7, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 30),
    interval: const Duration(hours: 1, minutes: 45),
  );


  final List<String> horasGrupo2 = _generarHoras(
    start: const TimeOfDay(hour: 8, minute: 30),
    end: const TimeOfDay(hour: 19, minute: 0),
    interval: const Duration(hours: 1, minutes: 45),
  );


  final List<String> trimestres = List.generate(12, (index) => '${index + 1}');

  bool _isEndTimeAfterStartTime(TimeOfDay startTime, TimeOfDay endTime) {
  final start = startTime.hour * 60 + startTime.minute;
  final end = endTime.hour * 60 + endTime.minute;
  return end > start;
}
  // Convertir String a TimeOfDay
  TimeOfDay _parseTime(String timeStr) {
    final format = DateFormat('h:mm a');
    final date = format.parse(timeStr);
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }


  // Generar lista de horas
  static List<String> _generarHoras({
    required TimeOfDay start,
    required TimeOfDay end,
    required Duration interval,
  }) {
    final horas = <String>[];
    DateTime current = DateTime(2023, 1, 1, start.hour, start.minute);
    final endTime = DateTime(2023, 1, 1, end.hour, end.minute);


    while (current.isBefore(endTime) || current.isAtSameMomentAs(endTime)) {
      horas.add(DateFormat('h:mm a').format(current));
      current = current.add(interval);
    }
    return horas;
  }


 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  return Scaffold(
    appBar: AppBar(
      title: const Text('Nueva Clase'),
      centerTitle: true,
      titleTextStyle: theme.textTheme.titleSmall,
      backgroundColor: colors.surface,
      foregroundColor: colors.inversePrimary,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Campo nombre materia
              const SizedBox(height: 30),
              TextFormField(
                cursorColor: colors.primary,
                controller: materiaNombreController,
                style: TextStyle(color: colors.inversePrimary),
                decoration: InputDecoration(
                  labelText: 'Nombre de la Materia',
                  labelStyle: TextStyle(color: colors.inversePrimary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primary, width: 2), // Borde resaltado
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Ingreso de Aula
              TextFormField(
                cursorColor: colors.primary,
                controller: aulaController,
                style: TextStyle(color: colors.inversePrimary),
                decoration: InputDecoration(
                  labelText: 'Ingrese el Aula',
                  labelStyle: TextStyle(color: colors.inversePrimary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primary, width: 2), // Borde resaltado
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el aula';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Campo nombre del profesor
              TextFormField(
                cursorColor: colors.primary,
                controller: profesorController,
                style: TextStyle(color: colors.inversePrimary),
                decoration: InputDecoration(
                  labelText: 'Nombre del Profesor',
                  labelStyle: TextStyle(color: colors.inversePrimary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primary, width: 2), // Borde resaltado
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del profesor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Selector de día
             Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: colors.surface,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: colors.inversePrimary),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Días de la semana',
        style: TextStyle(color: colors.inversePrimary),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: dias.map((dia) {
          return FilterChip(
            label: Text(
              dia,
              style: Theme.of(context).textTheme.bodyLarge, // Aplicar TextTheme.bodyLarge
            ),
            selected: selectedDias.contains(dia),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedDias.add(dia);
                } else {
                  selectedDias.remove(dia);
                }
              });
            },
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: selectedDias.contains(dia)
                    ? colors.primary // Borde primario cuando está seleccionado
                    : colors.inversePrimary, // Borde normal cuando no está seleccionado
                width: 2, // Grosor del borde
              ),
              borderRadius: BorderRadius.circular(20), // Bordes redondeados
            ),
            backgroundColor: colors.surface, // Fondo del chip
            selectedColor: colors.surface, // Fondo del chip cuando está seleccionado
            checkmarkColor: colors.primary, // Color del ícono de selección
          );
        }).toList(),
      ),
    ],
  ),
),
const SizedBox(height: 20),

              // Selector de hora grupo 1
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.inversePrimary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.inversePrimary),
                  items: horasGrupo1.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Hora de inicio",
                    labelStyle: TextStyle(color: colors.inversePrimary),
                    
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una hora';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    horaInicio = value;
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Selector de hora grupo 2
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.inversePrimary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.inversePrimary),
                  items: horasGrupo2.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Hora de cierre",
                    labelStyle: TextStyle(color: colors.inversePrimary),
                    
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona una hora';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    horaFinal = value;
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Selector de trimestre
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.inversePrimary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: colors.inversePrimary),
                  items: trimestres.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Trimestre $value'),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Trimestre',
                    labelStyle: TextStyle(color: colors.inversePrimary),
                    
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona un trimestre';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    trimestre = value;
                  },
                ),
              ),
              const SizedBox(height: 29),

              // Botón de guardar
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (selectedDias.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecciona al menos un día')),
                      );
                      return;
                    }

                    if (horaInicio == null || horaFinal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecciona una hora de inicio y cierre')),
                      );
                      return;
                    }

                    // Convertir las horas de String a TimeOfDay
                    final startTime = _parseTime(horaInicio!);
                    final endTime = _parseTime(horaFinal!);
                    if (!_isEndTimeAfterStartTime(startTime, endTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La hora final debe ser posterior a la hora de inicio')),
        );
        return;
      }
                    // Crear un TimeSlot para cada día seleccionado
                    for (final dia in selectedDias) {
                      final newSlot = TimeSlot(
                        materiaNombreController.text,
                        startTime,
                        endTime,
                        profesorController.text,
                        trimestre!,
                        aulaController.text,
                      );

                      // Llamar a onSave con el TimeSlot y el día
                      widget.onSave(newSlot, dia);
                    }

                    // Mostrar SnackBar de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Clase guardada exitosamente!'),
                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                        duration: const Duration(seconds: 1),
                      ),
                    );

                    // Cerrar la página después de guardar
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.save, color: colors.surface),
                label: Text(
                  'Guardar Materia',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}