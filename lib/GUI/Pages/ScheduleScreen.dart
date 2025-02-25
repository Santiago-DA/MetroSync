import 'package:flutter/material.dart';
import 'WeekSchedule.dart';

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
    {
      'nombre': 'Santiago',
      'horario': '8:45 a.m - 10:30 a.m',
    },
    {
      'nombre': 'María',
      'horario': '2:00 p.m - 3:30 p.m',
    },
    {
      'nombre': 'Luis',
      'horario': '12:00 p.m - 1:30 p.m',
    },
    {
      'nombre': 'Carla',
      'horario': '4:00 p.m - 5:30 p.m',
    },
  ];

  final List<Map<String, dynamic>> amigos = [
    {
      'nombre': 'Juan Pérez',
      'usuario': '@juanperez',
    },
    {
      'nombre': 'Ana Gómez',
      'usuario': '@anagomez',
    },
    {
      'nombre': 'Pedro Ramírez',
      'usuario': '@pedroramirez',
    },
    {
      'nombre': 'Laura Fernández',
      'usuario': '@laurafernandez',
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
    final diaActual = "Lunes";
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
            _buildSeccion(
              context: context,
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
              title: 'Huecos en Común',
              items: huecosComunes,
              builder: _buildTarjetaHueco,
            ),
            _buildSeccion(
              context: context,
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
          height: 160,
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary, // Usar el color primario del tema
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
            color: Theme.of(context).colorScheme.secondary)),
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
                  color: theme.colorScheme.secondary,
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
        color: theme.colorScheme.secondary, // Usar el color primario del tema
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
        color: theme.colorScheme.secondary, // Usar el color primario del tema
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
              onPressed: () {
                print('Sincronizar con ${amigo['nombre']}');
              },
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