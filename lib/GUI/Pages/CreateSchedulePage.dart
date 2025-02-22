import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateSchedulePage extends StatelessWidget {
  CreateSchedulePage({super.key});

  TextEditingController materiaNombreController = TextEditingController();
  TextEditingController aulaController = TextEditingController();
  TextEditingController profesorController = TextEditingController(); // Nuevo controlador para el profesor
  String? diaSemana;
  String? horaInicio;
  String? horaFinal;
  String? trimestre; // Nuevo campo para el trimestre

  final _formKey = GlobalKey<FormState>();
  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes'
  ];
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

  // Lista de trimestres (I a XII)
  final List<String> trimestres = List.generate(12, (index) => '${index + 1}');

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
        titleTextStyle: theme.textTheme.titleMedium,
        backgroundColor: colors.primary,
        foregroundColor: colors.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo nombre materia
              const SizedBox(height: 30), // Más espacio
              TextFormField(
                controller: materiaNombreController,
                style: TextStyle(color: Colors.black), // Texto negro
                decoration: InputDecoration(
                  labelText: 'Nombre de la Materia',
                  labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.inversePrimary),
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
              const SizedBox(height: 30), // Más espacio

              // Ingreso de Aula
              TextFormField(
                controller: aulaController,
                style: TextStyle(color: Colors.black), // Texto negro
                decoration: InputDecoration(
                  labelText: 'Ingrese el Aula',
                  labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.inversePrimary),
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
              const SizedBox(height: 30), // Más espacio

              // Campo nombre del profesor
              TextFormField(
                controller: profesorController,
                style: TextStyle(color: Colors.black), // Texto negro
                decoration: InputDecoration(
                  labelText: 'Nombre del Profesor',
                  labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.inversePrimary),
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
              const SizedBox(height: 30), // Más espacio

              // Selector de día
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.primary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black), // Texto negro
                  items: dias.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Día de la semana',
                    labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona un día';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    diaSemana = value;
                  },
                ),
              ),
              const SizedBox(height: 30), // Más espacio

              // Selector de hora grupo 1
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.primary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black), // Texto negro
                  items: horasGrupo1.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Hora de inicio",
                    labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
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
              const SizedBox(height: 30), // Más espacio

              // Selector de hora grupo 2
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.primary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black), // Texto negro
                  items: horasGrupo2.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Hora de cierre",
                    labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
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
              const SizedBox(height: 30), // Más espacio

              // Selector de trimestre
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.primary),
                ),
                child: DropdownButtonFormField<String>(
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black), // Texto negro
                  items: trimestres.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Trimestre $value'),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Trimestre',
                    labelStyle: TextStyle(color: colors.inversePrimary), // Color del label
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
              const SizedBox(height: 30), // Más espacio

              // Botón de guardar
              ElevatedButton.icon(
                icon: Icon(Icons.save, color: colors.inversePrimary),
                label: Text(
                  'Guardar Horario',
                  style: TextStyle(color: colors.inversePrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var text = materiaNombreController.text;
                    var aux = aulaController.text;
                    var profesor = profesorController.text; // Obtener el nombre del profesor
                    // SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(
                            "$text, $diaSemana, $horaInicio - $horaFinal, aula: $aux, profesor: $profesor, trimestre: $trimestre"),
                      ),
                    );
                    // Insercion a la BDD
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}