import 'package:flutter/material.dart';
import 'WeekSchedule.dart';
import 'package:flutter/foundation.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({super.key});
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Datos de ejemplo
  final List<Map<String, dynamic>> materias = [
  ];

  final List<Map<String, dynamic>> huecosComunes = [
    
  ];

final List<Map<String, dynamic>> amigos = [
  {
    'nombre': 'Juan Pérez',
    'usuario': '@juanperez',
    'materias': [
      {
        'nombre': 'Matemáticas',
        'horario': '7:00 a.m - 8:30 a.m',
        'aula': 'Aula 201',
        'profesor': 'Dr. Pérez',
        'trimestre': 'Trimestre 3',
        'dias': ['Lunes', 'Miércoles', 'Viernes'],
      },
      {
        'nombre': 'Física',
        'horario': '10:30 a.m - 12:00 a.m',
        'aula': 'Aula 305',
        'profesor': 'Dra. Gómez',
        'trimestre': 'Trimestre 3',
        'dias': ['Martes', 'Jueves'],
      },
      {
        'nombre': 'Química',
        'horario': '12:15 p.m - 1:45 p.m',
        'aula': 'Lab Química',
        'profesor': 'Dra. Martínez',
        'trimestre': 'Trimestre 3',
        'dias': ['Lunes', 'Miércoles'],
      },
    ],
  },
  {
    'nombre': 'Ana Gómez',
    'usuario': '@anagomez',
    'materias': [
      {
        'nombre': 'Programación',
        'horario': '7:00 a.m - 8:30 a.m',
        'aula': 'Lab 101',
        'profesor': 'Ing. Rodríguez',
        'trimestre': 'Trimestre 2',
        'dias': ['Lunes', 'Viernes'],
      },
      {
        'nombre': 'Base de Datos',
        'horario': '2:00 p.m - 3:30 p.m',
        'aula': 'Aula 402',
        'profesor': 'Mg. Sánchez',
        'trimestre': 'Trimestre 2',
        'dias': ['Martes', 'Jueves'],
      },
      {
        'nombre': 'Inglés',
        'horario': '10:30 a.m - 12:00 a.m',
        'aula': 'Aula 105',
        'profesor': 'Lic. Smith',
        'trimestre': 'Trimestre 2',
        'dias': ['Miércoles', 'Viernes'],
      },
    ],
  },
  {
    'nombre': 'Pedro Ramírez',
    'usuario': '@pedroramirez',
    'materias': [
      {
        'nombre': 'Química',
        'horario': '8:45 a.m - 10:15 a.m',
        'aula': 'Lab Química',
        'profesor': 'Dra. Martínez',
        'trimestre': 'Trimestre 1',
        'dias': ['Miércoles', 'Viernes'],
      },
      {
        'nombre': 'Matemáticas',
        'horario': '12:15 a.m - 1:30 p.m',
        'aula': 'Aula 201',
        'profesor': 'Dr. Pérez',
        'trimestre': 'Trimestre 1',
        'dias': ['Lunes', 'Miércoles', 'Viernes'],
      },
      {
        'nombre': 'Física',
        'horario': '3:45 p.m - 5:15 p.m',
        'aula': 'Aula 305',
        'profesor': 'Dra. Gómez',
        'trimestre': 'Trimestre 1',
        'dias': ['Martes', 'Jueves'],
      },
    ],
  },
  {
    'nombre': 'Laura Fernández',
    'usuario': '@laurafernandez',
    'materias': [
      {
        'nombre': 'Inglés',
        'horario': '5:30 a.m - 7:00 p.m',
        'aula': 'Aula 105',
        'profesor': 'Lic. Smith',
        'trimestre': 'Trimestre 4',
        'dias': ['Lunes', 'Miércoles'],
      },
      {
        'nombre': 'Historia',
        'horario': '3:45 p.m - 5:15 p.m',
        'aula': 'Aula 203',
        'profesor': 'Prof. Johnson',
        'trimestre': 'Trimestre 4',
        'dias': ['Martes', 'Jueves'],
      },
      {
        'nombre': 'Programación',
        'horario': '7:00 a.m - 8:30 a.m',
        'aula': 'Lab 101',
        'profesor': 'Ing. Rodríguez',
        'trimestre': 'Trimestre 4',
        'dias': ['Lunes', 'Viernes'],
      },
    ],
  },
];
  void _agregarMateria(Map<String, dynamic> nuevaMateria) {
    setState(() {
      materias.add(nuevaMateria);
    });
  }
  void _eliminarMateria(Map<String, dynamic> materia) {
  setState(() {
    materias.removeWhere((m) => m['nombre'] == materia['nombre']);
  });
}
List<TimeOfDay> parseHorario(String horario) {
  List<String> parts = horario.split(' - ');
  TimeOfDay start = _parseTimePart(parts[0]);
  TimeOfDay end = _parseTimePart(parts[1]);
  return [start, end];
}

TimeOfDay _parseTimePart(String part) {
  part = part.trim().toLowerCase();
  bool isAM = part.contains('a.m');
  String timeStr = part.replaceAll(RegExp(r'[a.m.p.m. ]'), '');
  List<String> components = timeStr.split(':');
  int hour = int.parse(components[0]);
  int minute = components.length > 1 ? int.parse(components[1]) : 0;

  if (!isAM && hour != 12) {
    hour += 12;
  } else if (isAM && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

TimeOfDay _minutesToTime(int minutes) {
  int hour = minutes ~/ 60;
  int minute = minutes % 60;
  return TimeOfDay(hour: hour, minute: minute);
}


List<List<int>> _generateFixedIntervals() {
  List<List<int>> intervals = [];
  int startMinutes = 7 * 60; // 7:00 AM en minutos
  const int classDuration = 90; // 1h30 en minutos
  const int breakDuration = 15; // 15 min de descanso

  // Generar intervalos hasta las 7:00 PM (19:00)
  while (startMinutes + classDuration <= 19 * 60) {
    int endMinutes = startMinutes + classDuration;
    intervals.add([startMinutes, endMinutes]);
    startMinutes = endMinutes + breakDuration;
  }

  return intervals;
}


Map<String, List<List<TimeOfDay>>> _calculateCommonFreeTime(
  List<Map<String, dynamic>> userSubjects,
  List<Map<String, dynamic>> friendSubjects,
) {
  String currentDay = _obtenerDiaActual();
  List<List<int>> fixedIntervals = _generateFixedIntervals();

  // Obtener horarios ocupados del usuario
  List<List<int>> userOccupied = [];
  for (var subject in userSubjects.where((s) => (s['dias'] as List).contains(currentDay))) {
    List<TimeOfDay> times = parseHorario(subject['horario']);
    userOccupied.add([_timeToMinutes(times[0]), _timeToMinutes(times[1])]);
  }

  // Obtener horarios ocupados del amigo
  List<List<int>> friendOccupied = [];
  for (var subject in friendSubjects.where((s) => (s['dias'] as List).contains(currentDay))) {
    List<TimeOfDay> times = parseHorario(subject['horario']);
    friendOccupied.add([_timeToMinutes(times[0]), _timeToMinutes(times[1])]);
  }

  // Encontrar bloques libres comunes
 List<List<int>> commonFree = [];
for (var interval in fixedIntervals) {
  final fixedStart = interval[0];
  final fixedEnd = interval[1];

  // Verificar si el usuario está libre
  bool isUserFree = !userOccupied.any((occupied) {
    if (occupied != null && occupied.length == 2 && occupied[0] != null && occupied[1] != null) {
      int start = occupied[0];
      int end = occupied[1];
      return (start < fixedEnd) && (end > fixedStart);
    }
    return false; // Si la lista no es válida, considera que está ocupado
  });

  // Verificar si el amigo está libre
  bool isFriendFree = !friendOccupied.any((occupied) {
    if (occupied != null && occupied.length == 2 && occupied[0] != null && occupied[1] != null) {
      int start = occupied[0];
      int end = occupied[1];
      return (start < fixedEnd) && (end > fixedStart);
    }
    return false; // Si la lista no es válida, considera que está ocupado
  });

  if (isUserFree && isFriendFree) {
    commonFree.add(interval);
  }
}

  // Formatear resultado
  Map<String, List<List<TimeOfDay>>> result = {};
  if (commonFree.isNotEmpty) {
    result[currentDay] = commonFree.map((interval) {
      return [
        _minutesToTime(interval[0]),
        _minutesToTime(interval[1])
      ];
    }).toList();
  }

  return result;
}
void _sincronizarConAmigo(Map<String, dynamic> amigo) {
  Map<String, List<List<TimeOfDay>>> commonFreeTime =
      _calculateCommonFreeTime(materias, amigo['materias']);

  List<Map<String, dynamic>> nuevosHuecos = [];
  String currentDay = _obtenerDiaActual();

  if (commonFreeTime.containsKey(currentDay)) {
    for (var interval in commonFreeTime[currentDay]!) {
      String horario = '${_formatTime(interval[0])} - ${_formatTime(interval[1])}';
      nuevosHuecos.add({
        'nombre': amigo['nombre'],
        'horario': horario,
        'dias': [currentDay],
      });
    }
  }

  setState(() {
    // Eliminar huecos anteriores del mismo amigo y día
    huecosComunes.removeWhere((h) => 
        h['nombre'] == amigo['nombre'] && 
        h['dias'].contains(currentDay));

    // Agregar nuevos huecos
    huecosComunes.addAll(nuevosHuecos);
  });
}

String _formatTime(TimeOfDay time) {
  String period = time.hour >= 12 ? 'p.m.' : 'a.m.';
  int hour = time.hour % 12;
  if (hour == 0) hour = 12;
  String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}
  String _obtenerDiaActual() {
    final now = DateTime.now();
    final weekday = now.weekday;
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  // Función para filtrar materias del día actual
  List<Map<String, dynamic>> _materiasDelDia() {
    final diaActual = _obtenerDiaActual();
    
    return materias.where((materia) {
      final dias = List<String>.from(materia['dias'] ?? []);
      return dias.contains(diaActual);
    }).toList();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 4),
            _buildSeccion(
              context: context,
              height: 140,
              title: 'Mi Horario Hoy ',
              items: _materiasDelDia(),
              builder: _buildTarjetaMateria,
              accion: IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeekSchedule(
                        materias: materias,
                        onSubjectAdded: _agregarMateria,
                        onSubjectDeleted: _eliminarMateria,
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildSeccion(
              context: context,
              height: 130,
              title: 'Huecos en Común',
              items: huecosComunes,
              builder: _buildTarjetaHueco,
            ),
            _buildSeccion(
              context: context,
              height: 180,
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
    required BuildContext context,
    required double height,
    required String title,
    required List<Map<String, dynamic>> items,
    required Widget Function(BuildContext, Map<String, dynamic>) builder,
    Widget? accion,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(26.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium,
              ),

              if (accion != null) accion,

            ],
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => builder(context, items[index]),
          ),
        ),
        Divider(thickness: 10, color: theme.colorScheme.surface),
      ],
    );
  }

  Widget _buildTarjetaMateria(
      BuildContext context, Map<String, dynamic> materia) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        _mostrarPopupMateria(context, materia);
        
      },
      onLongPress: () => _mostrarDialogoEliminar(context, materia),
      child: Container(
        width: 200,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary, // Usar el color primario del tema
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
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                materia['horario'],
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  materia['aula'],
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
  void _mostrarDialogoEliminar(BuildContext context, Map<String, dynamic> materia) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Eliminar materia', style: Theme.of(context).textTheme.displayLarge),
      content: Text('¿Seguro que quieres eliminar ${materia['nombre']}?', 
               style: Theme.of(context).textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(
            color: Theme.of(context).colorScheme.primary)),
        ),
        TextButton(
          onPressed: () {
            _eliminarMateria(materia);
            Navigator.pop(context);
          },
          child: Text('Eliminar', style: TextStyle(
            color: Theme.of(context).colorScheme.error)),
        ),
      ],
    ),
  );
}

  void _mostrarPopupMateria(BuildContext context, Map<String, dynamic> materia) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            materia['nombre'],
            style: theme.textTheme.displayLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Horario: ${materia['horario']}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Aula: ${materia['aula']}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Profesor: ${materia['profesor']}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Trimestre: ${materia['trimestre']}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el popup
              },
              child: Text(
                'Cerrar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTarjetaHueco(BuildContext context, Map<String, dynamic> hueco) {
    final theme = Theme.of(context);

    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary, // Usar el color primario del tema
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
            Icon(Icons.group, size: 32, color: theme.colorScheme.inversePrimary),
            const SizedBox(height: 8),
            Text(
              hueco['nombre'],
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hueco['horario'],
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaAmigo(BuildContext context, Map<String, dynamic> amigo) {
    final theme = Theme.of(context);

    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary, // Usar el color primario del tema
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
            // Ícono de account_circle
            Icon(
              Icons.account_circle,
              size: 48,
              color: theme.colorScheme.inversePrimary,
            ),
            const SizedBox(height: 8),
            // Nombre y apellido
            Text(
              amigo['nombre'],
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Username
            Text(
              amigo['usuario'],
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            // Botón para sincronizar
            ElevatedButton(
              
              onPressed: () => _sincronizarConAmigo(amigo),
              
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.inversePrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Sincronizar',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}