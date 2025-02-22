import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateSchedulePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

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

  final List<String> dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
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
          child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),  
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.primary),
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
                          label: Text(dia),
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
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
               // Más espacio
              
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
              const SizedBox(height: 28), // Más espacio

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
              const SizedBox(height: 29), // Más espacio

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
                    
                    final newSubject = {
                      'nombre': materiaNombreController.text,
                      'horario': '$horaInicio - $horaFinal',
                      'aula': aulaController.text,
                      'profesor': profesorController.text,
                      'trimestre': trimestre,
                      'dias': List<String>.from(selectedDias),
                    };
                    
                    // Mostrar SnackBar con los datos
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Clase guardada exitosamente!',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text('Nombre: ${newSubject['nombre']}'),
                            Text('Horario: ${newSubject['horario']}'),
                            Text('Aula: ${newSubject['aula']}'),
                            Text('Días: ${(newSubject['dias'] as List<String>).join(', ')}'),
                          ],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    
                    // Guardar y cerrar
                    widget.onSave(newSubject);
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.save, color: colors.inversePrimary),
                label: Text('Guardar Horario'),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
