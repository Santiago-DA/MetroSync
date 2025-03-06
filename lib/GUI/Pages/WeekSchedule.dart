import 'package:flutter/material.dart';
import 'CreateSchedulePage.dart';

class WeekSchedule extends StatefulWidget {
  final List<Map<String, dynamic>> materias;
  final Function(Map<String, dynamic>) onSubjectAdded;
  final Function(Map<String, dynamic>) onSubjectDeleted;
  const WeekSchedule({
    super.key,
    required this.materias,
    required this.onSubjectAdded,
    required this.onSubjectDeleted
  });

  @override
  State<WeekSchedule> createState() => _WeekScheduleState();
}

class _WeekScheduleState extends State<WeekSchedule> {
  late List<Map<String, dynamic>> _materias;

  @override
  void initState() {
    super.initState();
    _materias = widget.materias;
  }

  @override
  void didUpdateWidget(covariant WeekSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.materias != oldWidget.materias) {
      setState(() {
        _materias = widget.materias;
      });
    }
  }
  void _eliminarMateria(Map<String, dynamic> materia) {
    // Actualizar lista local y padre
    setState(() {
      _materias.removeWhere((m) => m['nombre'] == materia['nombre']);
    });
    widget.onSubjectDeleted(materia); // Notificar al padre
  }

  Map<String, List<Map<String, dynamic>>> get _horarioSemanal {
    final horario = <String, List<Map<String, dynamic>>>{
      'Lunes': [],
      'Martes': [],
      'Miércoles': [],
      'Jueves': [],
      'Viernes': [],
    };

    for (var materia in _materias) {
      final dias = List<String>.from(materia['dias'] ?? []);
      for (var dia in dias) {
        if (horario.containsKey(dia)) {
          final materiaCopy = Map<String, dynamic>.from(materia);
          horario[dia]!.add(materiaCopy);
        }
      }
    }
    return horario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Semanal'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBotonGigante(context),
            ..._horarioSemanal.entries.map((entry) => _buildDia(
                  context,
                  dia: entry.key,
                  materias: entry.value,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaMateria(Map<String, dynamic> materia, BuildContext context) {
    return GestureDetector(
      onTap: () => _mostrarPopupMateria(context, materia),
      onLongPress: () => _mostrarDialogoEliminar(context, materia), 
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                materia['nombre'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.access_time, materia['horario'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, materia['aula'], context),
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
          onPressed: () =>  {
             _eliminarMateria(materia),
              Navigator.pop(context),
          },
          child: Text('Eliminar', style: TextStyle(
            color: Theme.of(context).colorScheme.error)),
        ),
      ],
    ),
  );
}
  
  void _mostrarPopupMateria(BuildContext context, Map<String, dynamic> materia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            materia['nombre'],
            style: Theme.of(context).textTheme.displayLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.access_time, materia['horario'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, materia['aula'], context),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, materia['profesor'], context),
              const SizedBox(height: 8),
              _buildInfoRow(
                  Icons.calendar_today, 
                  'Trimestre: ${materia['trimestre']}', 
                  context),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBotonGigante(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateSchedulePage(
              onSave: (nuevaMateria) {
                
                setState(() {
                  widget.onSubjectAdded(nuevaMateria);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            'Agregar clase',
            style: Theme.of(context).textTheme.displayMedium,
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: materias.length,
            itemBuilder: (context, index) => _buildTarjetaMateria(
              materias[index],
              context,
            ),
          ),
        ),
        Divider(thickness: 2, color: Theme.of(context).colorScheme.surface),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
