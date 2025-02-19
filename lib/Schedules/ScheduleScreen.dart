import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
class ScheduleScreen extends StatelessWidget {
  // Datos de ejemplo
  
  final List<Map<String, dynamic>> materias = [
  {
    'nombre': 'Ec. Diferenciales',
    'horario': '8:45 a.m - 10:30 a.m',
    'aula': 'A1-205',
    'color': Colors.blue[200]
  },
  {
    'nombre': 'Cálculo Integral',
    'horario': '10:45 a.m - 12:30 p.m',
    'aula': 'B2-103',
    'color': Colors.green[200]
  },
  {
    'nombre': 'Física',
    'horario': '1:00 p.m - 2:30 p.m',
    'aula': 'C3-104',
    'color': Colors.red[200]
  },
  {
    'nombre': 'Química',
    'horario': '3:00 p.m - 4:30 p.m',
    'aula': 'D4-202',
    'color': Colors.orange[200]
  },
];

final List<Map<String, dynamic>> huecosComunes = [
  {
    'nombre': 'Santiago',
    'horario': '8:45 a.m - 10:30 a.m',
    'color': Colors.orange[200]
  },
  {
    'nombre': 'María',
    'horario': '2:00 p.m - 3:30 p.m',
    'color': Colors.purple[200]
  },
  {
    'nombre': 'Luis',
    'horario': '12:00 p.m - 1:30 p.m',
    'color': Colors.blue[200]
  },
  {
    'nombre': 'Carla',
    'horario': '4:00 p.m - 5:30 p.m',
    'color': Colors.green[200]
  },
];

final List<Map<String, dynamic>> amigos = [
  {
    'nombre': 'Juan Pérez',
    'usuario': '@juanperez',
    'color': Colors.yellow[200]
  },
  {
    'nombre': 'Ana Gómez',
    'usuario': '@anagomez',
    'color': Colors.pink[200]
  },
  {
    'nombre': 'Pedro Ramírez',
    'usuario': '@pedroramirez',
    'color': Colors.teal[200]
  },
  {
    'nombre': 'Laura Fernández',
    'usuario': '@laurafernandez',
    'color': Colors.cyan[200]
  },
];


  ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSeccion(
              title: 'Mi Horario Hoy',
              items: materias,
              builder: _buildTarjetaMateria,
             accion: IconButton(
                icon: const Icon(Icons.add_box, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekSchedule(),
                    ),
                  );
                },
              ),
            ),
            _buildSeccion(
              title: 'Huecos en Común',
              items: huecosComunes,
              builder: _buildTarjetaHueco,
            ),
            _buildSeccion(
              title: 'Amigos',
              items: amigos,
              builder: _buildTarjetaAmigo,
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildSeccion({
    required String title,
    required List<Map<String, dynamic>> items,
    required Widget Function(BuildContext, Map<String, dynamic>) builder,
    Widget? accion, // Nuevo parámetro opcional
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (accion != null) accion,
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => builder(context, items[index]),
          ),
        ),
        const Divider(thickness: 1.5),
      ],
    );
  }

  Widget _buildTarjetaMateria(BuildContext context, Map<String, dynamic> materia) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: materia['color'] as Color? ?? Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materia['nombre'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              materia['horario'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
           Center(
            child: Text(
              materia['aula'],
              style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
                ),
              ),
            ),
const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaHueco(BuildContext context, Map<String, dynamic> hueco) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: hueco['color'] as Color? ?? Colors.orange[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group, size: 32, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              hueco['nombre'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hueco['horario'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaAmigo(BuildContext context, Map<String, dynamic> amigo) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: amigo['color'] as Color? ?? Colors.yellow[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Text(
                amigo['nombre'].toString().substring(0, 1),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amigo['nombre'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            
            Text(
              amigo['usuario'],
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
class WeekSchedule extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> horarioSemanal = {
    'Lunes': [
      {
        'materia': 'Matemáticas',
        'horario': '8:00 - 10:00',
        'aula': 'A1-301',
        'color': Colors.blue[200]
      },
      {
        'materia': 'Física',
        'horario': '10:30 - 12:30',
        'aula': 'B2-105',
        'color': Colors.green[200]
      },
    ],
    'Martes': [
      {
        'materia': 'Química',
        'horario': '9:00 - 11:00',
        'aula': 'C3-204',
        'color': Colors.orange[200]
      },
    ],
    'Miércoles': [
      {
        'materia': 'Biología',
        'horario': '8:30 - 10:30',
        'aula': 'D4-102',
        'color': Colors.purple[200]
      },
      {
        'materia': 'Historia',
        'horario': '11:00 - 13:00',
        'aula': 'E5-303',
        'color': Colors.red[200]
      },
    ],
    'Jueves': [
      {
        'materia': 'Literatura',
        'horario': '10:00 - 12:00',
        'aula': 'F6-401',
        'color': Colors.teal[200]
      },
    ],
    'Viernes': [
      {
        'materia': 'Educación Física',
        'horario': '7:30 - 9:30',
        'aula': 'Gimnasio',
        'color': Colors.yellow[200]
      },
    ],
  };

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Semanal'),
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBotonGigante(context),
            ...horarioSemanal.entries.map((entry) => _buildDia(
                  context,
                  dia: entry.key,
                  materias: entry.value,
                )),
          ],
        ),
      ),
    );
  }

 Widget _buildBotonGigante(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateSchedulePage()),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const Center(
        child: Text(
          'Crear Mi Horario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildDia(
    BuildContext context, {
    required String dia,
    required List<Map<String, dynamic>> materias,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            dia,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: materias.length,
            itemBuilder: (context, index) => _buildTarjetaMateria(materias[index]),
          ),
        ),
        const Divider(thickness: 1.5),
      ],
    );
  }

  Widget _buildTarjetaMateria(Map<String, dynamic> materia) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: materia['color'] as Color? ?? Colors.blue[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materia['materia'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.access_time, materia['horario']),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, materia['aula']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


class CreateSchedulePage extends StatelessWidget {
  CreateSchedulePage({super.key});

  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Horario'),
        backgroundColor: const Color.fromARGB(255, 244, 209, 209),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo nombre materia
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre de la Materia',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: const Color.fromARGB(255, 244, 209, 209)),
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
              const SizedBox(height: 20),

              // Selector de día
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonFormField<String>(
                  items: dias.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Día de la semana',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecciona un día';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 20),

              // Selector de hora grupo 1
              _buildTimeSelector(
                label: 'Hora de inicio',
                items: horasGrupo1,
              ),
              const SizedBox(height: 20),

              // Selector de hora grupo 2
              _buildTimeSelector(
                label: 'Hora de cierre',
                items: horasGrupo2,
              ),
              const SizedBox(height: 30),

              // Botón de guardar
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Guardar Horario',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 209, 209),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Lógica para guardar
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector({required String label, required List<String> items}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
        validator: (value) {
          if (value == null) {
            return 'Selecciona una hora';
          }
          return null;
        },
        onChanged: (value) {},
      ),
    );
  }
}